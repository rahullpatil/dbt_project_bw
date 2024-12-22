Welcome to your new dbt project!

### DBT project

This repository contains a DBT project for modeling Salesforce leads data integrated with licensing and compliance information from source files provided. The standardized schema is designed to support analytical and operational use cases for monitoring provider performance and compliance.

**Tradeoffs and Decisions**

Schema Standardization: Focused on creating a unified schema to accommodate data from multiple sources, prioritizing key fields for analysis.

Transformations: Incorporated data cleaning and validation steps, including date formatting, numeric validations, and boolean conversions.

Simplified Joins: Left joins were chosen over unions to preserve all lead records while enriching them with compliance data. Unioning could be considered if the sources represented similar entities.

Capacity Validations: Ensured non-numeric values are excluded from capacity columns.Additional data cleaning might be necessary for future datasets.

With additional time, a more refined folder structure and standardized database naming conventions could have been implemented to enhance organization and schema consistency.

**Areas for Improvement**

Scalability: Current pipeline processes data as a snapshot. Incremental updates could be implemented to process changes more efficiently with ETL pipelines in place from the source system.

Error Logging: Introduce logging mechanisms for data quality issues and transformation failures.

Testing: Add more rigorous testing with dbt test to validate assumptions about data integrity.

Documentation: Expand documentation to cover data lineage and relationships between source systems.

**Longer Term ETL Strategies**

Incremental Loads: Implement incremental models in DBT to process only new or updated records instead of full table scans.

Data Versioning: Track historical changes using slowly changing dimensions (SCD) strategies.

Automation: Schedule and automate pipeline runs using Airflow/Fivetran.

Monitoring: Set up dashboards for data observability to monitor pipeline performance and data quality or Data Anamoly.

Data Governance: Implement role-based access control (RBAC) and data masking for sensitive fields if needed.

**Additional Notes**

The project can be extended to integrate with BI tools such as Tableau or Power BI for visualization.

Completed Successfully the model in local. 

Feedback and contributions are welcome!
