
# RAK Bank Azure Data Migration Project

## Introduction

RAK Bank, one of the leading financial institutions in the UAE, undertook a major initiative to modernize its data infrastructure by migrating its on-premise data systems to Microsoft Azure. The objective of this project was to enhance scalability, improve data processing speed, and reduce the overhead of maintaining legacy systems. This migration aligned with RAK Bank’s strategic focus on digital transformation and harnessing cloud capabilities to optimize operations, enable advanced analytics, and ensure data security.

## Project Scope

The migration project encompassed the following key areas:
- **Data Sources**: Migration of structured and unstructured data from multiple on-premise systems including customer databases, transaction logs, financial reports, and other core banking systems.
- **Azure Services Utilized**:
  - Azure Data Lake Storage (ADLS) for secure and scalable data storage.
  - Azure Synapse Analytics for advanced analytics and data warehousing.
  - Azure Data Factory (ADF) for orchestrating ETL/ELT pipelines.
  - Azure SQL Database and Cosmos DB for hosting transactional and non-relational data.
  - Azure Active Directory (AAD) for access control and security.
- **ETL Process**: Custom ETL pipelines were developed using Azure Data Factory to ensure seamless data migration with transformations and quality checks in place.
- **Data Security**: End-to-end encryption, role-based access, and multi-factor authentication were implemented to comply with UAE banking regulations and ensure data integrity during and after migration.

## Challenges and Solutions

- **Challenge 1: Data Compatibility**
  - **Solution**: Data from legacy systems was transformed into Azure-compatible formats using Azure Data Factory’s mapping data flows and Databricks for complex data transformation logic.
  
- **Challenge 2: Data Volume**
  - **Solution**: Azure Data Lake was leveraged to store and process large volumes of data, ensuring cost-effective and scalable storage solutions.
  
- **Challenge 3: Minimal Downtime**
  - **Solution**: The migration was executed in phases using a hybrid cloud approach. Critical systems were prioritized, and fallback strategies were implemented to minimize disruption to banking operations.

## Key Features

- **High Scalability**: By migrating to Azure, RAK Bank achieved high scalability to handle increased customer demand and data growth.
- **Advanced Analytics**: Azure Synapse Analytics provided advanced data analytics capabilities, enabling the bank to generate insights from both structured and unstructured data.
- **Improved Security**: With Azure’s built-in security features such as encryption and AAD, data security and compliance were greatly enhanced.
  
## Outcome

The successful completion of the Azure data migration project resulted in:
- Reduced operational costs due to decreased reliance on on-premise infrastructure.
- Faster data processing times, leading to improved customer services.
- The ability to harness real-time analytics for decision-making processes.
- Enhanced data security measures to protect sensitive customer information.



# RAK Bank Azure Data Migration Project - Schema Diagram

## High-Level Schema

The RAK Bank Azure Data Migration project contains the following key entities:

1. **Customers**
2. **Accounts**
3. **Transactions**
4. **Loans**
5. **Cards**
6. **Branches**
7. **Employees**
8. **Audit**

These entities are interconnected through various relationships such as foreign keys (FKs) to represent the logical flow of data within the bank's system.

---

### Customers Table

| Column Name          | Data Type      | Description                                    |
|----------------------|----------------|------------------------------------------------|
| `customer_id`         | INT (PK)       | Unique identifier for the customer             |
| `first_name`          | VARCHAR(100)   | First name of the customer                     |
| `last_name`           | VARCHAR(100)   | Last name of the customer                      |
| `email`               | VARCHAR(255)   | Email address of the customer                  |
| `phone_number`        | VARCHAR(20)    | Phone number of the customer                   |
| `date_of_birth`       | DATE           | Customer's date of birth                       |
| `address`             | VARCHAR(255)   | Address of the customer                        |
| `city`                | VARCHAR(100)   | City of the customer                           |
| `country`             | VARCHAR(100)   | Country of the customer                        |
| `national_id`         | VARCHAR(50)    | National ID number                             |
| `customer_since`      | DATE           | The date the customer joined                   |
| `customer_status`     | VARCHAR(50)    | Active/Inactive status                         |

---

### Accounts Table

| Column Name          | Data Type      | Description                                    |
|----------------------|----------------|------------------------------------------------|
| `account_id`          | INT (PK)       | Unique identifier for the account              |
| `customer_id`         | INT (FK)       | Reference to the customer                      |
| `account_type`        | VARCHAR(50)    | Type of the account (e.g., Savings, Current)   |
| `balance`             | DECIMAL(15,2)  | Current balance of the account                 |
| `currency`            | VARCHAR(10)    | Currency of the account (e.g., AED, USD)       |
| `branch_id`           | INT (FK)       | Branch where the account is held               |
| `account_status`      | VARCHAR(50)    | Active/Inactive status                         |
| `date_opened`         | DATE           | Date the account was opened                    |

---

### Transactions Table

| Column Name           | Data Type      | Description                                    |
|-----------------------|----------------|------------------------------------------------|
| `transaction_id`       | INT (PK)       | Unique identifier for the transaction          |
| `account_id`           | INT (FK)       | Reference to the account                       |
| `transaction_type`     | VARCHAR(50)    | Type of transaction (e.g., Credit, Debit)      |
| `amount`               | DECIMAL(15,2)  | Transaction amount                             |
| `transaction_date`     | DATE           | Date of the transaction                        |
| `description`          | VARCHAR(255)   | Transaction description                        |
| `balance_after_txn`    | DECIMAL(15,2)  | Account balance after the transaction          |
| `branch_id`            | INT (FK)       | Branch where the transaction occurred          |

---

### Loans Table

| Column Name           | Data Type      | Description                                    |
|-----------------------|----------------|------------------------------------------------|
| `loan_id`              | INT (PK)       | Unique identifier for the loan                 |
| `customer_id`          | INT (FK)       | Reference to the customer                      |
| `loan_type`            | VARCHAR(50)    | Type of loan (e.g., Personal, Home, Auto)      |
| `loan_amount`          | DECIMAL(15,2)  | Total loan amount                              |
| `interest_rate`        | DECIMAL(5,2)   | Interest rate on the loan                      |
| `loan_status`          | VARCHAR(50)    | Loan status (e.g., Approved, Pending, Closed)  |
| `loan_start_date`      | DATE           | Date the loan was issued                       |
| `loan_end_date`        | DATE           | Date the loan is to be repaid                  |

---

### Cards Table

| Column Name           | Data Type      | Description                                    |
|-----------------------|----------------|------------------------------------------------|
| `card_id`              | INT (PK)       | Unique identifier for the card                 |
| `customer_id`          | INT (FK)       | Reference to the customer                      |
| `card_type`            | VARCHAR(50)    | Type of card (e.g., Credit, Debit)             |
| `card_number`          | VARCHAR(16)    | Card number (masked for security)              |
| `card_status`          | VARCHAR(50)    | Card status (e.g., Active, Blocked)            |
| `expiry_date`          | DATE           | Expiry date of the card                        |
| `issue_date`           | DATE           | Date the card was issued                       |
| `credit_limit`         | DECIMAL(15,2)  | Credit limit (if applicable)                   |

---

### Branches Table

| Column Name           | Data Type      | Description                                    |
|-----------------------|----------------|------------------------------------------------|
| `branch_id`            | INT (PK)       | Unique identifier for the branch               |
| `branch_name`          | VARCHAR(100)   | Name of the branch                             |
| `branch_code`          | VARCHAR(10)    | Branch code for transactions                   |
| `city`                 | VARCHAR(100)   | City where the branch is located               |
| `country`              | VARCHAR(100)   | Country where the branch is located            |
| `phone_number`         | VARCHAR(20)    | Contact number of the branch                   |

---

### Employees Table

| Column Name           | Data Type      | Description                                    |
|-----------------------|----------------|------------------------------------------------|
| `employee_id`          | INT (PK)       | Unique identifier for the employee             |
| `first_name`           | VARCHAR(100)   | Employee's first name                          |
| `last_name`            | VARCHAR(100)   | Employee's last name                           |
| `position`             | VARCHAR(50)    | Job title of the employee                      |
| `branch_id`            | INT (FK)       | Branch where the employee works                |
| `email`                | VARCHAR(255)   | Contact email of the employee                  |
| `phone_number`         | VARCHAR(20)    | Employee's contact number                      |
| `hire_date`            | DATE           | Date the employee was hired                    |
| `salary`               | DECIMAL(10,2)  | Employee's salary                              |

---

### Audit Table

| Column Name           | Data Type      | Description                                    |
|-----------------------|----------------|------------------------------------------------|
| `audit_id`             | INT (PK)       | Unique identifier for the audit                |
| `table_name`           | VARCHAR(100)   | Name of the table being audited                |
| `operation_type`       | VARCHAR(50)    | Type of operation (Insert, Update, Delete)     |
| `performed_by`         | VARCHAR(100)   | Name or ID of the user who performed the operation |
| `operation_time`       | TIMESTAMP      | Time the operation was performed               |
| `details`              | JSON           | Detailed log of changes                        |

---

## Extended Tables for 200 Columns

To complete the schema with 200 columns, the following additional tables can be included:

### Customer Contacts Table

| Column Name           | Data Type      | Description                                    |
|-----------------------|----------------|------------------------------------------------|
| `contact_id`           | INT (PK)       | Unique identifier for the contact              |
| `customer_id`          | INT (FK)       | Reference to the customer                      |
| `emergency_contact_name` | VARCHAR(100) | Name of the emergency contact                  |
| `emergency_contact_number` | VARCHAR(20) | Emergency contact number                      |

---

### Loan Payments Table

| Column Name           | Data Type      | Description                                    |
|-----------------------|----------------|------------------------------------------------|
| `payment_id`           | INT (PK)       | Unique identifier for the payment              |
| `loan_id`              | INT (FK)       | Reference to the loan                          |
| `payment_amount`       | DECIMAL(15,2)  | Amount of the loan payment                     |
| `payment_date`         | DATE           | Date of the payment                            |
| `payment_status`       | VARCHAR(50)    | Status of the payment (e.g., Completed, Pending) |

---

### Transaction Fees Table

| Column Name           | Data Type      | Description                                    |
|-----------------------|----------------|------------------------------------------------|
| `fee_id`               | INT (PK)       | Unique identifier for the fee                  |
| `transaction_id`       | INT (FK)       | Reference to the transaction                   |
| `fee_amount`           | DECIMAL(15,2)  | Fee amount for the transaction                 |
| `fee_type`             | VARCHAR(50)    | Type of fee (e.g., Service Fee, Penalty)       |
| `description`          | VARCHAR(255)   | Description of the fee                         |

---


# Azure Data Factory Pipeline with Medallion Architecture

# Step 1: Ingest data to the Bronze layer (Raw Layer)
# Bronze layer holds raw data directly from various source systems.

# Ingest data from multiple sources (SQL, Blob Storage, etc.) to Azure Data Lake Storage (ADLS) Gen2

# Bronze Layer Ingestion Code
bronze_ingest_pipeline = """
{
  "name": "BronzeLayerIngestionPipeline",
  "properties": {
    "activities": [
      {
        "name": "CopyDataFromSQLToBronze",
        "type": "Copy",
        "inputs": [ { "name": "SQLSourceDataset" } ],
        "outputs": [ { "name": "BronzeADLSDataset" } ],
        "typeProperties": {
          "source": {
            "type": "AzureSqlSource",
            "sqlReaderQuery": "SELECT * FROM Orders"
          },
          "sink": {
            "type": "AzureDataLakeStoreSink",
            "fileName": "orders_raw.csv",
            "folderPath": "adls/bronze/orders/"
          }
        }
      }
    ]
  }
}
"""

# Step 2: Apply transformations to move data from Bronze to Silver layer
# The Silver layer contains cleaned, de-duplicated, and transformed data.

# Silver Layer Transformations
silver_transformations_pipeline = """
{
  "name": "SilverLayerTransformationsPipeline",
  "properties": {
    "activities": [
      {
        "name": "RemoveDuplicates",
        "type": "DatabricksNotebook",
        "inputs": [ { "name": "BronzeADLSDataset" } ],
        "outputs": [ { "name": "SilverADLSDataset" } ],
        "typeProperties": {
          "notebookPath": "/Notebooks/RemoveDuplicates"
        }
      },
      {
        "name": "FilterNullValues",
        "type": "DatabricksNotebook",
        "inputs": [ { "name": "BronzeADLSDataset" } ],
        "outputs": [ { "name": "SilverADLSDataset" } ],
        "typeProperties": {
          "notebookPath": "/Notebooks/FilterNulls"
        }
      },
      {
        "name": "StandardizeDateFormats",
        "type": "MappingDataFlow",
        "inputs": [ { "name": "BronzeADLSDataset" } ],
        "outputs": [ { "name": "SilverADLSDataset" } ],
        "typeProperties": {
          "formatSettings": {
            "dateFormat": "yyyy-MM-dd"
          }
        }
      }
    ]
  }
}
"""

# Sample transformations in the Silver Layer
silver_transformations_code = """
# 1. Removing duplicates based on unique keys
df_silver = df_bronze.dropDuplicates(['order_id'])

# 2. Filtering null values
df_silver = df_silver.filter(df_silver['customer_id'].isNotNull())

# 3. Standardizing date formats
df_silver = df_silver.withColumn('order_date', to_date(df_silver['order_date'], 'yyyy-MM-dd'))

# 4. Masking sensitive data (PII masking)
df_silver = df_silver.withColumn('customer_ssn', regexp_replace('customer_ssn', '[0-9]{3}-[0-9]{2}', 'XXX-XX'))

# 5. Calculating new columns (age calculation from date of birth)
df_silver = df_silver.withColumn('customer_age', datediff(current_date(), df_silver['dob'])/365)

# 6. Aggregating totals for orders
df_silver = df_silver.groupBy('customer_id').agg(sum('order_total').alias('total_spent'))

# 7. Joining tables (e.g., orders with customers)
df_silver = df_silver.join(customers_df, 'customer_id', 'inner')

# 8. Reformatting string columns
df_silver = df_silver.withColumn('customer_name', initcap(df_silver['customer_name']))

# 9. Normalizing numeric columns
df_silver = df_silver.withColumn('order_total_normalized', (df_silver['order_total'] - min_val)/(max_val - min_val))

# 10. Removing special characters from text fields
df_silver = df_silver.withColumn('product_description', regexp_replace(df_silver['product_description'], '[^a-zA-Z0-9]', ' '))
"""

# Step 3: Apply business-level aggregation to move data from Silver to Gold layer
# The Gold layer contains high-level aggregated data for reporting, analytics, and business use cases.

# Gold Layer Aggregations Pipeline
gold_aggregations_pipeline = """
{
  "name": "GoldLayerAggregationsPipeline",
  "properties": {
    "activities": [
      {
        "name": "AggregateCustomerSpending",
        "type": "DatabricksNotebook",
        "inputs": [ { "name": "SilverADLSDataset" } ],
        "outputs": [ { "name": "GoldADLSDataset" } ],
        "typeProperties": {
          "notebookPath": "/Notebooks/AggregateCustomerSpending"
        }
      },
      {
        "name": "SummarizeMonthlySales",
        "type": "DatabricksNotebook",
        "inputs": [ { "name": "SilverADLSDataset" } ],
        "outputs": [ { "name": "GoldADLSDataset" } ],
        "typeProperties": {
          "notebookPath": "/Notebooks/SummarizeMonthlySales"
        }
      },
      {
        "name": "CalculateCustomerLifetimeValue",
        "type": "MappingDataFlow",
        "inputs": [ { "name": "SilverADLSDataset" } ],
        "outputs": [ { "name": "GoldADLSDataset" } ],
        "typeProperties": {
          "calculations": [
            { "name": "lifetime_value", "formula": "sum(order_total * order_frequency)" }
          ]
        }
      }
    ]
  }
}
"""

# Sample transformations in the Gold Layer
gold_transformations_code = """
# 1. Aggregating customer total spending
df_gold = df_silver.groupBy('customer_id').agg(sum('order_total').alias('total_spent'))

# 2. Monthly sales summary
df_gold = df_silver.groupBy('year', 'month').agg(sum('order_total').alias('monthly_sales'))

# 3. Calculating customer lifetime value (CLV)
df_gold = df_gold.withColumn('customer_lifetime_value', col('total_spent') * col('order_frequency'))

# 4. Identifying top N customers by revenue
df_gold = df_gold.orderBy(desc('total_spent')).limit(100)

# 5. Business KPIs (Key Performance Indicators)
df_gold = df_silver.groupBy('product_category').agg(sum('order_total').alias('category_sales'))

# 6. Calculating revenue growth month over month
df_gold = df_gold.withColumn('revenue_growth', (col('monthly_sales') - lag('monthly_sales').over(window)) / lag('monthly_sales').over(window))

# 7. Creating derived columns for reporting
df_gold = df_gold.withColumn('avg_order_value', col('total_spent') / col('order_count'))

# 8. Generating customer segmentation based on total spending
df_gold = df_gold.withColumn('customer_segment', when(col('total_spent') > 5000, 'VIP').otherwise('Regular'))

# 9. Calculating product-level sales performance
df_gold = df_silver.groupBy('product_id').agg(sum('order_total').alias('product_sales'))

# 10. Removing obsolete data from gold layer
df_gold = df_gold.filter(df_gold['product_sales'] > 0)
"""

---

### Summary of Transformation Steps in Each Layer:

- **Bronze Layer**: Ingests raw data from SQL databases, blob storage, etc., and stores it in ADLS in the raw format. No transformations occur here.
- **Silver Layer**: Data cleansing, deduplication, filtering, standardization, and masking occur. Key transformations are filtering nulls, removing duplicates, masking sensitive data, standardizing formats, and deriving new columns.
- **Gold Layer**: Aggregation and business-level KPIs are calculated. Typical transformations include aggregations, joining datasets, creating derived columns (e.g., CLV), and calculating growth metrics.

### Exhaustive Notes on ADF Pipeline:

- **Bronze Layer**: Holds raw, unprocessed data directly from the source systems. This layer acts as the foundation for all further transformations.
- **Silver Layer**: Contains transformed, cleaned, and validated data. Typical transformations include deduplication, PII masking, standardization of formats (dates, strings, etc.), and basic data calculations.
- **Gold Layer**: Data is highly aggregated and ready for business consumption. This layer focuses on aggregating totals, calculating KPIs, and preparing the data for reporting and analytics.
- **Orchestration in ADF**: Pipelines in ADF orchestrate data movement between the layers. ADF can trigger external compute (Databricks, HDInsight, etc.) for advanced transformations.
- **Mapping Data Flows**: Used for simple transformations like column renaming, data type conversion, and simple aggregations.
- **Databricks Notebooks**: Used for more complex transformations, including joins, complex aggregations, and machine learning model integration.
- **End-to-End Security**: Ensure proper role-based access, encryption at rest, and data masking to meet compliance requirements.
- **Handling Duplicates**: One of the key steps in the Silver layer is removing duplicates based on unique business keys such as customer IDs or order numbers.
- **Null Handling**: Silver layer also involves filtering out null values or imputing missing values where necessary.
- **Business KPIs**: Gold layer prepares data for business consumption and focuses on KPIs, customer segmentation, sales aggregation, etc.




