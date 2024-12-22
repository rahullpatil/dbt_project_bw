{{ config(materialized='table') }}

WITH leads AS (
    SELECT
        id AS provider_id,
        first_name,
        last_name,
        company,
        street AS address1,
        city,
        state,
        postal_code AS zip,
        country,
        email,
        CASE 
            WHEN Is_converted IN ('true', '1', 'yes', 'Y') THEN TRUE
            ELSE FALSE
        END AS is_converted,
        Status, 
        TO_TIMESTAMP(created_date, 'MM/DD/YY HH24:MI') as created_date,
        TO_TIMESTAMP(last_modified_date , 'MM/DD/YY HH24:MI')as last_modified_date,
        last_activity_date,
        last_viewed_date, 
        capacity_c,
        lead_source,
        title,
        outreach_stage_c AS curriculum_type,
        lead_source_last_updated_c AS certificate_expiration_date,
        website,
        brightwheel_school_uuid_c
    FROM {{ source('stg','stg_salesforce_leads') }}
     WHERE country NOT LIKE '[0-9]%' -- Exclude invalid country values with numbers
),

source_s1 AS (
    SELECT
        Name AS company,
        ADDRESS AS address2,
         state,
         county,
         phone
    FROM {{ source('stg','stg_source_s1') }}
     WHERE Name IS NOT NULL -- Validate non-null company names
),

source_s2 AS (
    SELECT
        Company AS company,
        TYPELICENSE AS license_number,
        'Accepts Subsidy' AS accepts_financial_aid,
        'Year Round' AS schedule,
        'Star Level' AS facility_type,
        'Total Cap' AS capacity,
        'Monitoring since' AS license_issued,
        'Monitoring since' AS license_renewed,
        'Daytime Hours' AS operating_hours,
        'Star Level' AS star_rating,
        'Min Age' AS min_age,
        'Max Age' AS max_age,
        'Monitoring since' AS compliance_monitoring_date
    FROM {{ source('stg','stg_source_s2') }}
    WHERE Company IS NOT NULL -- Validate non-null operation IDs
    AND TRY_CAST(capacity AS INT) IS NOT NULL -- Exclude rows where capacity contains non-numeric values
),

source_s3 AS (
    SELECT  
        Operation AS operator,
        'Operation Name' AS company,
        Address AS address1,
        City AS city,
        State AS state,
        Zip AS zip,
        Phone AS phone,
        Capacity AS capacity,
        Status AS license_status,
        IssueDate AS license_issued_date,
        Monitoringfrequency AS compliance_frequency,
        'Audit Date' AS audit_date,
        'Audit Notes' AS audit_notes
    FROM {{ source('stg','stg_source_s3') }}
    WHERE Operation IS NOT NULL -- Validate non-null operation IDs
)

-- Final Join and Transformation
SELECT
    leads.provider_id,
    leads.first_name,
    leads.last_name,
    leads.company,
    leads.address1,
    source_s1.address2,
    leads.city,
    leads.state,
    leads.zip,
    source_s1.county,
    leads.country,
    leads.email,
    leads.is_converted,
    leads.Status, 
    leads.created_date, 
    leads.last_modified_date, 
    leads.last_activity_date,
    leads.last_viewed_date, 
    leads.capacity_c,
    leads.lead_source,
    leads.curriculum_type,
    source_s2.capacity,
    source_s2.accepts_financial_aid,
    source_s2.schedule,
    source_s3.phone,
    source_s3.operator,
    source_s3.license_status,
    source_s2.license_number,
    source_s2.license_issued,
    source_s2.license_renewed,
    source_s3.license_issued_date,
    source_s3.compliance_frequency,
    source_s2.operating_hours,
    source_s2.star_rating,
    source_s2.compliance_monitoring_date,
    source_s2.facility_type,
    source_s2.min_age,
    source_s2.max_age,
    source_s3.audit_date,
    source_s3.audit_notes,
    leads.certificate_expiration_date,
    leads.website,
    leads.brightwheel_school_uuid_c
FROM leads
LEFT JOIN source_s1
    ON leads.company = source_s1.company
LEFT JOIN source_s2
    ON leads.company = source_s2.company
LEFT JOIN source_s3
    ON leads.company = source_s3.company
WHERE leads.provider_id IS NOT NULL -- Final validation to exclude rows with null provider IDs
