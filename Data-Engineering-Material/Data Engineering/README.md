# Banking Customer Data Onboarding Pipeline

## Project Overview

This project implements a comprehensive data pipeline for banking customer data onboarding, validation, and enrichment using Azure Data Factory (ADF), Azure Databricks (ADB), Azure Data Lake Storage Gen2 (ADLS Gen2), and Delta tables, with Power BI as the final reporting destination.

## 🏗️ Architecture

The solution follows a modern data architecture pattern with the following components:

- **Data Sources**: CRM, Core Banking, KYC Documents, External APIs
- **Azure Data Factory**: Pipeline orchestration and data movement
- **Azure Databricks**: Data validation, enrichment, and processing
- **Azure Data Lake Storage Gen2**: Multi-zone data storage (Raw, Validated, Enriched, Curated)
- **Delta Tables**: Optimized data storage with ACID transactions
- **Power BI**: Business intelligence and reporting

## 📋 Prerequisites

### Azure Services Required
- Azure Data Factory
- Azure Databricks
- Azure Data Lake Storage Gen2
- Azure Key Vault
- Azure Monitor
- Power BI Premium

### Permissions Required
- Contributor access to Azure resources
- Databricks workspace access
- ADLS Gen2 storage account access
- Power BI workspace access

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd banking-customer-data-pipeline
```

### 2. Set Up Azure Resources
```bash
# Deploy Azure resources using Bicep
az deployment group create \
  --resource-group "banking-data-rg" \
  --template-file "infrastructure/main.bicep" \
  --parameters "infrastructure/main.parameters.json"
```

### 3. Configure Data Factory Pipelines
1. Import the ADF pipeline templates from `adf-pipelines/`
2. Update connection strings and parameters
3. Deploy pipelines to your ADF instance

### 4. Set Up Databricks Workspace
1. Import notebooks from `databricks-notebooks/`
2. Configure cluster settings
3. Set up job schedules

### 5. Configure Power BI
1. Import the Power BI template from `powerbi/`
2. Configure data source connections
3. Set up refresh schedules

## 📁 Project Structure

```
banking-customer-data-pipeline/
├── README.md                           # This file
├── banking_customer_data_pipeline_flow.md  # Detailed project flow
├── infrastructure/                     # Azure infrastructure as code
│   ├── main.bicep                     # Main Bicep template
│   ├── main.parameters.json           # Parameters file
│   └── modules/                       # Bicep modules
├── adf-pipelines/                     # Azure Data Factory pipelines
│   ├── customer-data-pipeline.json    # Main pipeline
│   ├── data-validation-pipeline.json  # Validation pipeline
│   └── data-enrichment-pipeline.json  # Enrichment pipeline
├── databricks-notebooks/              # Databricks notebooks
│   ├── DataValidation/                # Data validation notebooks
│   ├── DataEnrichment/                # Data enrichment notebooks
│   └── DeltaLoad/                     # Delta table loading notebooks
├── powerbi/                           # Power BI files
│   ├── BankingCustomerDashboard.pbix  # Main dashboard
│   └── reports/                       # Additional reports
├── monitoring/                        # Monitoring and alerting
│   ├── alerts.json                    # Alert configurations
│   └── dashboards/                    # Monitoring dashboards
└── docs/                              # Documentation
    ├── setup-guide.md                 # Detailed setup guide
    ├── user-guide.md                  # User documentation
    └── troubleshooting.md             # Troubleshooting guide
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file with the following variables:

```env
# Azure Configuration
AZURE_SUBSCRIPTION_ID=your-subscription-id
AZURE_RESOURCE_GROUP=banking-data-rg
AZURE_LOCATION=eastus

# Data Factory
ADF_FACTORY_NAME=banking-data-factory
ADF_PIPELINE_NAME=Banking_Customer_Data_Pipeline

# Databricks
DATABRICKS_WORKSPACE_URL=https://your-workspace.azuredatabricks.net
DATABRICKS_TOKEN=your-databricks-token

# Storage
STORAGE_ACCOUNT_NAME=bankingdatalake
CONTAINER_NAME=customer-data

# External APIs
ADDRESS_API_KEY=your-address-api-key
CREDIT_API_KEY=your-credit-api-key
RISK_API_KEY=your-risk-api-key
```

### Data Quality Rules
Configure data quality rules in `config/data-quality-rules.json`:

```json
{
  "customer_profile": {
    "required_fields": ["customer_id", "first_name", "last_name", "email"],
    "format_rules": {
      "email": "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$",
      "phone": "^[0-9]{10}$"
    },
    "business_rules": {
      "min_age": 18,
      "max_age": 120
    }
  }
}
```

## 📊 Monitoring and Alerting

### Key Metrics
- Pipeline execution time
- Data quality scores
- Error rates
- API response times
- Delta table optimization status

### Alerts
- Pipeline failures
- Data quality below thresholds
- API failures
- Storage capacity warnings

## 🔒 Security and Compliance

### Data Protection
- Encryption at rest and in transit
- Azure AD authentication
- Role-based access control (RBAC)
- Data masking for sensitive fields

### Compliance
- GDPR compliance
- SOX compliance
- PCI DSS compliance
- Audit trail maintenance

## 🧪 Testing

### Unit Tests
```bash
# Run unit tests
python -m pytest tests/unit/
```

### Integration Tests
```bash
# Run integration tests
python -m pytest tests/integration/
```

### Performance Tests
```bash
# Run performance tests
python -m pytest tests/performance/
```

## 📈 Performance Optimization

### Delta Table Optimization
- Automatic optimization enabled
- Z-ORDER by frequently queried columns
- Partitioning strategy for large tables

### Spark Configuration
- Adaptive query execution
- Dynamic partition pruning
- Broadcast joins for small tables

## 🚨 Troubleshooting

### Common Issues

1. **Pipeline Failures**
   - Check ADF activity logs
   - Verify connection strings
   - Review error messages in Databricks notebooks

2. **Data Quality Issues**
   - Review validation rules
   - Check source data format
   - Verify business rule configurations

3. **Performance Issues**
   - Monitor cluster utilization
   - Check Delta table optimization
   - Review partitioning strategy

### Support
For additional support, please refer to:
- [Troubleshooting Guide](docs/troubleshooting.md)
- [Azure Documentation](https://docs.microsoft.com/azure/)
- [Databricks Documentation](https://docs.databricks.com/)

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Acknowledgments

- Azure Data Factory team
- Databricks community
- Power BI team
- Banking industry experts

---

For detailed implementation steps, refer to [banking_customer_data_pipeline_flow.md](banking_customer_data_pipeline_flow.md). 