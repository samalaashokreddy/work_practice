# Databricks notebook source
# MAGIC %md
# MAGIC # Customer Data Validation Notebook
# MAGIC 
# MAGIC This notebook performs comprehensive validation of customer data including:
# MAGIC - Data completeness checks
# MAGIC - Format validation
# MAGIC - Business rule validation
# MAGIC - Data quality scoring
# MAGIC 
# MAGIC ## Input
# MAGIC - Raw customer data from ADLS Gen2 raw zone
# MAGIC 
# MAGIC ## Output
# MAGIC - Validated data to ADLS Gen2 validated zone
# MAGIC - Validation results and quality metrics
# MAGIC - Error records for investigation

# COMMAND ----------

# MAGIC %md
# MAGIC ## 1. Setup and Configuration

# COMMAND ----------

# Import required libraries
from pyspark.sql import SparkSession
from pyspark.sql.functions import *
from pyspark.sql.types import *
import logging
from datetime import datetime, timedelta
import json
from typing import Dict, List, Any

# COMMAND ----------

# Initialize Spark session with optimizations
spark = SparkSession.builder \
    .appName("CustomerDataValidation") \
    .config("spark.sql.adaptive.enabled", "true") \
    .config("spark.sql.adaptive.coalescePartitions.enabled", "true") \
    .config("spark.sql.adaptive.skewJoin.enabled", "true") \
    .config("spark.sql.adaptive.localShuffleReader.enabled", "true") \
    .config("spark.sql.adaptive.advisoryPartitionSizeInBytes", "128m") \
    .getOrCreate()

# COMMAND ----------

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# COMMAND ----------

# Configuration
CONFIG = {
    "storage_account": dbutils.secrets.get(scope="banking-secrets", key="storage-account-name"),
    "raw_zone_path": "abfss://raw-zone@{}.dfs.core.windows.net/customer-data/",
    "validated_zone_path": "abfss://validated-zone@{}.dfs.core.windows.net/customer-data/",
    "error_zone_path": "abfss://error-zone@{}.dfs.core.windows.net/validation-errors/",
    "validation_results_path": "abfss://validated-zone@{}.dfs.core.windows.net/validation-results/"
}

# COMMAND ----------

# Data Quality Rules Configuration
DATA_QUALITY_RULES = {
    "customer_profile": {
        "required_fields": ["customer_id", "first_name", "last_name", "email", "phone", "date_of_birth"],
        "format_rules": {
            "email": r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$",
            "phone": r"^[0-9]{10}$",
            "ssn": r"^\d{3}-\d{2}-\d{4}$",
            "zip_code": r"^\d{5}(-\d{4})?$"
        },
        "business_rules": {
            "min_age": 18,
            "max_age": 120,
            "min_income": 0,
            "max_income": 10000000,
            "valid_states": ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", 
                           "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", 
                           "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", 
                           "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", 
                           "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]
        }
    },
    "kyc_documents": {
        "required_fields": ["document_id", "document_type", "issue_date", "expiry_date"],
        "business_rules": {
            "document_not_expired": True,
            "issue_date_before_expiry": True,
            "valid_document_types": ["passport", "drivers_license", "state_id", "military_id"]
        }
    }
}

# COMMAND ----------

# MAGIC %md
# MAGIC ## 2. Data Loading

# COMMAND ----------

def load_raw_data():
    """
    Load raw customer data from ADLS Gen2
    """
    try:
        raw_path = CONFIG["raw_zone_path"].format(CONFIG["storage_account"])
        logger.info(f"Loading raw data from: {raw_path}")
        
        # Read data with schema inference
        raw_df = spark.read.format("parquet").load(raw_path)
        
        # Cache the dataframe for multiple operations
        raw_df.cache()
        
        logger.info(f"Loaded {raw_df.count()} records from raw zone")
        return raw_df
        
    except Exception as e:
        logger.error(f"Error loading raw data: {str(e)}")
        raise

# COMMAND ----------

# Load raw data
raw_df = load_raw_data()

# COMMAND ----------

# MAGIC %md
# MAGIC ## 3. Data Quality Validation Functions

# COMMAND ----------

def check_completeness(df: DataFrame, required_fields: List[str]) -> DataFrame:
    """
    Check data completeness for required fields
    """
    completeness_checks = []
    
    for field in required_fields:
        if field in df.columns:
            null_percentage = (count(when(col(field).isNull(), field)) / count("*") * 100).alias(f"{field}_null_percentage")
            completeness_checks.append(null_percentage)
        else:
            # Field is missing entirely
            lit(100.0).alias(f"{field}_null_percentage")
    
    return df.select(completeness_checks)

# COMMAND ----------

def check_format_validation(df: DataFrame, format_rules: Dict[str, str]) -> DataFrame:
    """
    Validate data format using regex patterns
    """
    format_checks = []
    
    for field, pattern in format_rules.items():
        if field in df.columns:
            is_valid = when(regexp_extract(col(field), pattern, 0) == col(field), "valid").otherwise("invalid").alias(f"{field}_format_valid")
            format_checks.append(is_valid)
    
    return df.select(format_checks)

# COMMAND ----------

def check_business_rules(df: DataFrame, business_rules: Dict[str, Any]) -> DataFrame:
    """
    Validate business rules
    """
    business_checks = []
    
    # Age validation
    if "min_age" in business_rules and "max_age" in business_rules:
        age_valid = when(
            (datediff(current_date(), to_date(col("date_of_birth"), "yyyy-MM-dd")) / 365 >= business_rules["min_age"]) &
            (datediff(current_date(), to_date(col("date_of_birth"), "yyyy-MM-dd")) / 365 <= business_rules["max_age"]),
            "valid"
        ).otherwise("invalid").alias("age_valid")
        business_checks.append(age_valid)
    
    # Income validation
    if "min_income" in business_rules and "max_income" in business_rules:
        income_valid = when(
            (col("annual_income") >= business_rules["min_income"]) &
            (col("annual_income") <= business_rules["max_income"]),
            "valid"
        ).otherwise("invalid").alias("income_valid")
        business_checks.append(income_valid)
    
    # State validation
    if "valid_states" in business_rules:
        state_valid = when(
            col("state").isin(business_rules["valid_states"]),
            "valid"
        ).otherwise("invalid").alias("state_valid")
        business_checks.append(state_valid)
    
    return df.select(business_checks)

# COMMAND ----------

def calculate_data_quality_score(df: DataFrame) -> DataFrame:
    """
    Calculate overall data quality score
    """
    # Count total validations
    validation_columns = [col for col in df.columns if col.endswith(('_valid', '_null_percentage'))]
    
    # Calculate score based on validation results
    valid_count = sum([when(col(c) == "valid", 1).otherwise(0) for c in df.columns if c.endswith('_valid')])
    total_validations = len([c for c in df.columns if c.endswith('_valid')])
    
    # Calculate completeness score
    null_percentage_cols = [c for c in df.columns if c.endswith('_null_percentage')]
    avg_null_percentage = sum([col(c) for c in null_percentage_cols]) / len(null_percentage_cols)
    completeness_score = (100 - avg_null_percentage) / 100
    
    # Overall quality score
    quality_score = ((valid_count / total_validations) * 0.7 + completeness_score * 0.3) * 100
    
    return df.withColumn("data_quality_score", quality_score)

# COMMAND ----------

# MAGIC %md
# MAGIC ## 4. Execute Validation

# COMMAND ----------

def validate_customer_data(df: DataFrame) -> Dict[str, DataFrame]:
    """
    Perform comprehensive customer data validation
    """
    validation_results = {}
    
    # 1. Completeness Check
    logger.info("Performing completeness checks...")
    completeness_results = check_completeness(df, DATA_QUALITY_RULES["customer_profile"]["required_fields"])
    validation_results["completeness"] = completeness_results
    
    # 2. Format Validation
    logger.info("Performing format validation...")
    format_results = check_format_validation(df, DATA_QUALITY_RULES["customer_profile"]["format_rules"])
    validation_results["format"] = format_results
    
    # 3. Business Rule Validation
    logger.info("Performing business rule validation...")
    business_results = check_business_rules(df, DATA_QUALITY_RULES["customer_profile"]["business_rules"])
    validation_results["business_rules"] = business_results
    
    # 4. Combine all validation results
    logger.info("Combining validation results...")
    all_validations = df.crossJoin(completeness_results) \
                       .crossJoin(format_results) \
                       .crossJoin(business_results)
    
    # 5. Calculate quality score
    logger.info("Calculating data quality score...")
    final_results = calculate_data_quality_score(all_validations)
    validation_results["final"] = final_results
    
    return validation_results

# COMMAND ----------

# Execute validation
validation_results = validate_customer_data(raw_df)

# COMMAND ----------

# MAGIC %md
# MAGIC ## 5. Separate Valid and Invalid Records

# COMMAND ----------

def separate_valid_invalid_records(df: DataFrame) -> Dict[str, DataFrame]:
    """
    Separate records into valid and invalid based on quality score
    """
    # Define quality threshold
    QUALITY_THRESHOLD = 80.0
    
    # Separate records
    valid_records = df.filter(col("data_quality_score") >= QUALITY_THRESHOLD)
    invalid_records = df.filter(col("data_quality_score") < QUALITY_THRESHOLD)
    
    logger.info(f"Valid records: {valid_records.count()}")
    logger.info(f"Invalid records: {invalid_records.count()}")
    
    return {
        "valid": valid_records,
        "invalid": invalid_records
    }

# COMMAND ----------

# Separate records
separated_records = separate_valid_invalid_records(validation_results["final"])

# COMMAND ----------

# MAGIC %md
# MAGIC ## 6. Generate Validation Summary

# COMMAND ----------

def generate_validation_summary(validation_results: Dict[str, DataFrame]) -> Dict[str, Any]:
    """
    Generate validation summary statistics
    """
    summary = {}
    
    # Overall statistics
    total_records = validation_results["final"].count()
    valid_records = separated_records["valid"].count()
    invalid_records = separated_records["invalid"].count()
    
    summary["total_records"] = total_records
    summary["valid_records"] = valid_records
    summary["invalid_records"] = invalid_records
    summary["validation_rate"] = (valid_records / total_records * 100) if total_records > 0 else 0
    
    # Average quality score
    avg_quality_score = validation_results["final"].agg(avg("data_quality_score")).collect()[0][0]
    summary["average_quality_score"] = avg_quality_score
    
    # Field-level statistics
    field_stats = {}
    for field in DATA_QUALITY_RULES["customer_profile"]["required_fields"]:
        null_percentage_col = f"{field}_null_percentage"
        if null_percentage_col in validation_results["final"].columns:
            null_percentage = validation_results["final"].agg(avg(null_percentage_col)).collect()[0][0]
            field_stats[field] = {
                "null_percentage": null_percentage,
                "completeness_rate": 100 - null_percentage
            }
    
    summary["field_statistics"] = field_stats
    
    # Validation timestamp
    summary["validation_timestamp"] = datetime.now().isoformat()
    
    return summary

# COMMAND ----------

# Generate summary
validation_summary = generate_validation_summary(validation_results)

# COMMAND ----------

# Display summary
print("=== VALIDATION SUMMARY ===")
print(f"Total Records: {validation_summary['total_records']}")
print(f"Valid Records: {validation_summary['valid_records']}")
print(f"Invalid Records: {validation_summary['invalid_records']}")
print(f"Validation Rate: {validation_summary['validation_rate']:.2f}%")
print(f"Average Quality Score: {validation_summary['average_quality_score']:.2f}")

print("\n=== FIELD STATISTICS ===")
for field, stats in validation_summary["field_statistics"].items():
    print(f"{field}: {stats['completeness_rate']:.2f}% complete")

# COMMAND ----------

# MAGIC %md
# MAGIC ## 7. Save Results

# COMMAND ----------

def save_validation_results(valid_records: DataFrame, invalid_records: DataFrame, summary: Dict[str, Any]):
    """
    Save validation results to ADLS Gen2
    """
    try:
        # Save valid records
        valid_path = CONFIG["validated_zone_path"].format(CONFIG["storage_account"])
        logger.info(f"Saving valid records to: {valid_path}")
        valid_records.write.mode("overwrite").parquet(valid_path)
        
        # Save invalid records
        error_path = CONFIG["error_zone_path"].format(CONFIG["storage_account"])
        logger.info(f"Saving invalid records to: {error_path}")
        invalid_records.write.mode("append").parquet(error_path)
        
        # Save validation summary
        summary_path = CONFIG["validation_results_path"].format(CONFIG["storage_account"])
        summary_df = spark.createDataFrame([summary])
        logger.info(f"Saving validation summary to: {summary_path}")
        summary_df.write.mode("append").json(f"{summary_path}/validation-summary")
        
        logger.info("Validation results saved successfully")
        
    except Exception as e:
        logger.error(f"Error saving validation results: {str(e)}")
        raise

# COMMAND ----------

# Save results
save_validation_results(separated_records["valid"], separated_records["invalid"], validation_summary)

# COMMAND ----------

# MAGIC %md
# MAGIC ## 8. Cleanup

# COMMAND ----------

# Unpersist cached dataframes
raw_df.unpersist()

# COMMAND ----------

# MAGIC %md
# MAGIC ## 9. Validation Complete
# MAGIC 
# MAGIC The customer data validation has been completed successfully. The results include:
# MAGIC - Valid records saved to the validated zone
# MAGIC - Invalid records saved to the error zone for investigation
# MAGIC - Validation summary with quality metrics
# MAGIC - Field-level completeness statistics 