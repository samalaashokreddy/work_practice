
## Real-Time Inventory Management System

The Real-Time Inventory Management System was developed to synchronize data seamlessly between SQL Server and Azure Data Lake Storage (ADLS Gen2) using Azure Data Engineering services. The pipeline was built using Azure Data Factory (ADF) to extract data from SQL Server and load it into ADLS Gen2. Python and PySpark scripts were employed within Azure Databricks (ADB) to preprocess and transform the data, ensuring that it was ready for real-time inventory tracking and analysis. By leveraging SQL queries and PySpark, data was transformed into a format suitable for analytics and downstream consumption.

To enhance performance, a data partitioning strategy was implemented within ADLS Gen2. This allowed for optimized query execution and faster retrieval of inventory-related data. Azure Data Factory played a crucial role in automating data flow by scheduling pipeline triggers to ensure real-time synchronization between the source SQL Server and the destination storage. Python and PySpark scripts executed within Databricks enabled efficient data manipulation and ensured that data pipelines were scalable for future enhancements.

Finally, the processed data in ADLS Gen2 was visualized using Power BI, enabling the creation of dynamic dashboards to provide actionable insights for inventory analytics. These dashboards empowered stakeholders to track inventory in real time, identify trends, and make data-driven decisions. The integration of ADF, ADB, ADLS Gen2, SQL, and Python/PySpark created a robust and scalable system capable of handling large datasets efficiently.

---

## Customer Data Integration Pipeline

The Customer Data Integration Pipeline was designed to integrate and consolidate customer data from multiple sources, including on-premises SQL Server and cloud-based APIs, into Azure Data Lake Storage (ADLS Gen2). Azure Data Factory (ADF) was used to extract data from diverse sources, leveraging its capabilities for hybrid data integration. The ingested data was transformed using Python and PySpark scripts within Azure Databricks (ADB), where advanced transformation logic and business rules were applied to ensure data consistency and accuracy.

To automate the pipeline, ADF was configured with event-based triggers that executed workflows upon detecting new data from the source systems. PySpark scripts in Databricks processed and aggregated the data, enabling seamless integration into ADLS Gen2. The pipeline also implemented error-handling and logging mechanisms to ensure the reliability and maintainability of the system. These mechanisms tracked and flagged any discrepancies, allowing for quick resolution and ensuring data quality throughout the integration process.

The transformed and integrated customer data was stored in ADLS Gen2, partitioned for efficient querying and analytics. SQL queries were used to validate the data integrity and generate reports. The pipeline enabled organizations to consolidate customer data into a single source of truth, facilitating enhanced customer insights and decision-making. The integration of ADF, ADB, ADLS Gen2, Python, PySpark, and SQL created a scalable solution capable of handling complex customer data integration requirements.
