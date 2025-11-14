# Healthcare Domain: IoMT Data Ingestion and Monitoring Platform

## Project Overview

This project delivers a comprehensive Internet of Medical Things (IoMT) data ingestion and monitoring platform, built on Microsoft Azure. The platform is designed to securely collect, process, and analyze data from a diverse array of medical devices and healthcare systems, supporting real-time patient monitoring, predictive analytics, and regulatory compliance. The architecture ensures data integrity, scalability, and rapid insights for healthcare providers and administrators.

## Data Sources

The platform integrates five key data sources:

1. **On-Premise SQL Server**: Electronic Health Records (EHR) and patient management data are sourced from an on-premise SQL Server, ensuring integration with legacy hospital systems.
2. **REST API**: Medical device telemetry and wearable sensor data are ingested via secure REST APIs, supporting a wide range of IoMT devices.
3. **Azure SQL Database**: Clinical trial data and research logs are stored in Azure SQL, providing structured, cloud-native datasets.
4. **Azure Blob Storage**: Medical images, scanned documents, and batch uploads are stored in Azure Blob Storage for further analysis.
5. **Azure Cosmos DB**: Real-time alerts and device event streams are captured in Azure Cosmos DB, enabling high-velocity, low-latency data ingestion.

## Azure Data Factory (ADF) for Ingestion and Orchestration

Azure Data Factory orchestrates the ingestion of data from all sources. The Self-Hosted Integration Runtime enables secure extraction from on-premise SQL Server, while native connectors and REST activities handle cloud and API sources. ADF pipelines manage scheduling, error handling, and data lineage, ensuring reliable and auditable workflows.

## Data Lake Storage with Delta Format

All ingested data is stored in Azure Data Lake Storage Gen2, organized into Bronze, Silver, and Gold layers using Delta Lake:

- **Bronze Layer**: Raw device data, logs, and records are stored as-is, preserving original fidelity for traceability.
- **Silver Layer**: Data is cleansed, deduplicated, and enriched with patient and device metadata. Business logic is applied to standardize formats and validate readings.
- **Gold Layer**: Curated datasets are prepared for advanced analytics, reporting, and machine learning.

Delta Lake provides ACID compliance, time travel for historical analysis, and schema enforcement, ensuring data quality and regulatory compliance.

## Data Processing with Azure Databricks

Azure Databricks notebooks (PySpark) process and transform data between layers. In the Silver Layer, device readings are validated, outliers are flagged, and patient records are joined with device data. Aggregations and predictive models are applied in the Gold Layer, supporting real-time monitoring and alerting.

## Azure Synapse Analytics for Reporting

Curated Gold Layer data is loaded into Azure Synapse Analytics, where it is modeled for clinical dashboards and regulatory reporting. Synapse provides scalable analytics, supporting both ad-hoc queries and scheduled reports for healthcare administrators and clinicians.

## Power BI for Visualization

Power BI connects to Synapse Analytics, enabling interactive dashboards for patient monitoring, device performance, and compliance tracking. Real-time data refreshes ensure that healthcare providers have up-to-date insights for decision-making.

## High-Level Architecture Flow

1. Data is ingested from on-premise SQL Server (via Self-Hosted IR), REST APIs, Azure SQL, Blob Storage, and Cosmos DB using ADF.
2. Raw data lands in the Bronze Layer of ADLS Gen2 (Delta Lake).
3. Azure Databricks processes data into Silver (cleansed, validated) and Gold (curated, aggregated) layers.
4. Gold Layer data is loaded into Azure Synapse Analytics for reporting.
5. Power BI dashboards provide real-time monitoring and analytics for healthcare stakeholders.

## Delta Lake Advantages

Delta Lake ensures data reliability with ACID transactions, supports historical analysis with time travel, and enforces schema consistency. These features are critical for healthcare, where data integrity and compliance are paramount.

## Scalability, Real-Time Analytics, and Business Insights

The platform is designed for scalability, supporting thousands of devices and high-frequency data streams. Real-time analytics enable proactive patient care and rapid response to critical events. Power BI delivers actionable insights, improving patient outcomes and operational efficiency in healthcare settings. 

## Azure Databricks Workflow: End-to-End Data Movement and Transformation

### Overview
This section details the full Azure Databricks workflow for ingesting IoMT and healthcare data from five sources, landing it in ADLS Gen2, and transforming it through Bronze, Silver, and Gold layers using PySpark. Each stage includes code samples, flow diagrams, and explanations for best practices and architectural decisions.

---

### 1. Ingestion to Landing Zone (ADLS Gen2)

All five sources are ingested into a raw landing zone in ADLS Gen2. This is typically done using Databricks notebooks scheduled via jobs or orchestrated by ADF, but here we focus on the Databricks code.

#### PySpark Example: Ingesting from Multiple Sources
```python
from pyspark.sql import SparkSession
import requests

spark = SparkSession.builder.getOrCreate()

# On-Premise SQL Server (EHR data)
sql_server_df = spark.read.format("jdbc").option("url", "jdbc:sqlserver://<server>:1433;databaseName=<db>") \
    .option("user", "<user>").option("password", "<password>") \
    .option("dbtable", "dbo.EHR").load()
sql_server_df.write.mode("overwrite").parquet("abfss://landing@<storage_account>.dfs.core.windows.net/sqlserver/")

# REST API (IoMT device telemetry)
api_url = "https://api.iotdevices.com/telemetry"
api_data = requests.get(api_url).json()
api_df = spark.createDataFrame(api_data)
api_df.write.mode("overwrite").parquet("abfss://landing@<storage_account>.dfs.core.windows.net/api/")

# Azure SQL Database (clinical trials)
az_sql_df = spark.read.format("jdbc").option("url", "jdbc:sqlserver://<azuresqlserver>.database.windows.net:1433;databaseName=<db>") \
    .option("user", "<user>").option("password", "<password>") \
    .option("dbtable", "dbo.ClinicalTrials").load()
az_sql_df.write.mode("overwrite").parquet("abfss://landing@<storage_account>.dfs.core.windows.net/azuresql/")

# Azure Blob Storage (medical images)
blob_df = spark.read.format("binaryFile").load("abfss://data@<storage_account>.dfs.core.windows.net/images/")
blob_df.write.mode("overwrite").parquet("abfss://landing@<storage_account>.dfs.core.windows.net/blob/")

# Azure Cosmos DB (device events)
cosmos_df = spark.read.format("cosmos.oltp").options(
    endpoint="<cosmos_endpoint>",
    key="<cosmos_key>",
    database="<db>",
    container="events"
).load()
cosmos_df.write.mode("overwrite").parquet("abfss://landing@<storage_account>.dfs.core.windows.net/cosmos/")
```

**Reasoning:**
- Using PySpark for all sources ensures scalability and parallelism.
- Data is written in Parquet format for efficient storage and downstream processing.
- Each source lands in a separate folder for traceability and schema evolution.

---

### 2. Landing Zone to Bronze Layer (Delta Lake)

The next step is to convert raw landing data into Delta format in the Bronze layer. This preserves raw data but enables ACID transactions and schema enforcement.

#### Flow Diagram: Ingestion to Bronze
```mermaid
flowchart TD
    LZ["Landing Zone"] --> BZ["Bronze Layer (Delta)"]
```

#### PySpark Example: Convert to Delta Bronze
```python
from delta.tables import DeltaTable

landing_path = "abfss://landing@<storage_account>.dfs.core.windows.net/sqlserver/"
bronze_path = "abfss://bronze@<storage_account>.dfs.core.windows.net/sqlserver/"

raw_df = spark.read.parquet(landing_path)
raw_df.write.format("delta").mode("overwrite").save(bronze_path)
# Repeat for other sources...
```

**Reasoning:**
- Delta format enables ACID compliance, time travel, and scalable upserts.
- Keeping Bronze as a near-raw copy supports traceability and reprocessing.

---

### 3. Bronze to Silver Layer (Cleansing, Deduplication)

The Silver layer applies business logic, deduplication, and joins with reference data.

#### Flow Diagram: Bronze to Silver
```mermaid
flowchart TD
    BZ["Bronze Layer (Delta)"] --> SL["Silver Layer (Delta)"]
```

#### PySpark Example: Cleansing and Deduplication
```python
bronze_path = "abfss://bronze@<storage_account>.dfs.core.windows.net/sqlserver/"
silver_path = "abfss://silver@<storage_account>.dfs.core.windows.net/ehr/"

bronze_df = spark.read.format("delta").load(bronze_path)

# Deduplicate by patient_id and timestamp
silver_df = bronze_df.dropDuplicates(["patient_id", "timestamp"])

# Enrich with device metadata
device_meta_df = spark.read.format("delta").load("abfss://bronze@<storage_account>.dfs.core.windows.net/api/")
silver_df = silver_df.join(device_meta_df, "device_id", "left")

silver_df.write.format("delta").mode("overwrite").save(silver_path)
```

**Reasoning:**
- Deduplication ensures data quality for downstream analytics.
- Enrichment with device metadata supports patient monitoring and compliance.

---

### 4. Silver to Gold Layer (Aggregation, Business Metrics)

The Gold layer contains curated, business-ready data for reporting and analytics.

#### Flow Diagram: Silver to Gold
```mermaid
flowchart TD
    SL["Silver Layer (Delta)"] --> GL["Gold Layer (Delta)"]
```

#### PySpark Example: Aggregation and Curation
```python
silver_path = "abfss://silver@<storage_account>.dfs.core.windows.net/ehr/"
gold_path = "abfss://gold@<storage_account>.dfs.core.windows.net/patient_monitoring/"

silver_df = spark.read.format("delta").load(silver_path)

# Aggregate by patient and day
from pyspark.sql.functions import to_date

gold_df = silver_df.groupBy("patient_id", to_date("timestamp").alias("date")) \
    .agg({"reading": "avg", "event_id": "count"}) \
    .withColumnRenamed("avg(reading)", "avg_reading") \
    .withColumnRenamed("count(event_id)", "event_count")

gold_df.write.format("delta").mode("overwrite").save(gold_path)
```

**Reasoning:**
- Aggregation prepares data for efficient reporting in Synapse and Power BI.
- Gold layer is optimized for business consumption and clinical analytics.

---

### 5. Why This Approach?
- **Delta Lake**: Ensures ACID compliance, time travel, and schema enforcement, which are critical for healthcare data.
- **Layered Architecture**: Supports traceability, reprocessing, and data quality at each stage.
- **PySpark**: Enables scalable, distributed processing for large IoMT datasets.

---

### Full Workflow Diagram
```mermaid
flowchart TD
    subgraph Ingestion
        A1["On-Premise SQL Server"]
        A2["REST API"]
        A3["Azure SQL Database"]
        A4["Azure Blob Storage"]
        A5["Azure Cosmos DB"]
    end
    subgraph LandingZone
        LZ["ADLS Gen2 Landing Zone"]
    end
    subgraph BronzeLayer
        BZ["Bronze Layer (Delta)"]
    end
    subgraph SilverLayer
        SL["Silver Layer (Delta)"]
    end
    subgraph GoldLayer
        GL["Gold Layer (Delta)"]
    end
    A1 --> LZ
    A2 --> LZ
    A3 --> LZ
    A4 --> LZ
    A5 --> LZ
    LZ --> BZ
    BZ --> SL
    SL --> GL
    style LZ fill:#e0e0e0,stroke:#333,stroke-width:2px
    style BZ fill:#b3c6ff,stroke:#333,stroke-width:2px
    style SL fill:#b3ffd9,stroke:#333,stroke-width:2px
    style GL fill:#ffe0b3,stroke:#333,stroke-width:2px
    classDef source fill:#fff,stroke:#333,stroke-width:2px;
```

---

Repeat this workflow for each project, adapting the business logic, enrichment, and aggregation steps to the specific domain and reporting requirements. 

---

## Azure Data Factory (ADF) Pipeline Example: Bulk Table Movement

To efficiently move 30 tables, each approximately 1GB (total 30GB), from a source (e.g., on-premise SQL Server) to a destination (e.g., ADLS Gen2 or Azure SQL), you can use an ADF pipeline with parameterized copy activities. Below is an example of how you might structure this in ADF, along with a sample JSON pipeline definition.

### Explanation
- The pipeline uses a parameterized dataset and a ForEach activity to iterate over a list of table names.
- Each iteration triggers a Copy activity that moves one table from the source to the destination.
- This approach is scalable, maintainable, and suitable for large-scale data movement.

### Sample ADF Pipeline JSON
```json
{
  "name": "BulkTableCopyPipeline",
  "properties": {
    "activities": [
      {
        "name": "ForEachTable",
        "type": "ForEach",
        "typeProperties": {
          "items": "@pipeline().parameters.tableList",
          "activities": [
            {
              "name": "CopyTable",
              "type": "Copy",
              "inputs": [
                {
                  "referenceName": "SourceTableDataset",
                  "type": "DatasetReference",
                  "parameters": {
                    "TableName": "@item()"
                  }
                }
              ],
              "outputs": [
                {
                  "referenceName": "DestinationTableDataset",
                  "type": "DatasetReference",
                  "parameters": {
                    "TableName": "@item()"
                  }
                }
              ],
              "typeProperties": {
                "source": {
                  "type": "SqlSource"
                },
                "sink": {
                  "type": "AzureBlobSink"
                }
              }
            }
          ]
        }
      }
    ],
    "parameters": {
      "tableList": {
        "type": "Array",
        "defaultValue": [
          "Table1", "Table2", "Table3", "Table4", "Table5", "Table6", "Table7", "Table8", "Table9", "Table10",
          "Table11", "Table12", "Table13", "Table14", "Table15", "Table16", "Table17", "Table18", "Table19", "Table20",
          "Table21", "Table22", "Table23", "Table24", "Table25", "Table26", "Table27", "Table28", "Table29", "Table30"
        ]
      }
    }
  }
}
```

**How to Use:**
- Replace `SourceTableDataset` and `DestinationTableDataset` with your actual dataset names.
- The dataset definitions should be parameterized to accept a table name.
- This pipeline can be triggered manually or on a schedule, and will efficiently move all 30 tables in parallel or sequentially as configured. 