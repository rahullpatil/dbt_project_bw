
  
    

        create or replace transient table DBT_TEST.STG.fct_leads
         as
        (

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
        email_bounced_reason AS email,
        outreach_stage_c AS curriculum_type,
        lead_source_last_updated_c AS certificate_expiration_date,
        brightwheel_school_uuid_c AS website_address
    FROM "DBT_TEST".stg.stg_sf_leads
),

source_s1 AS (
    SELECT
        Name AS company,
        ADDRESS AS address2,
         state,
         county,
         phone
    FROM "DBT_TEST".stg.stg_source_s1
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
        'Monitoring since' AS compliance_monitoring_date
    FROM "DBT_TEST".stg.stg_source_s2
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
    FROM "DBT_TEST".stg.stg_source_s3
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
    leads.email,
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
    source_s3.audit_date,
    source_s3.audit_notes,
    leads.certificate_expiration_date,
    leads.website_address
FROM leads
LEFT JOIN source_s1
    ON leads.company = source_s1.company
LEFT JOIN source_s2
    ON leads.company = source_s2.company
LEFT JOIN source_s3
    ON leads.company = source_s3.company
        );
      
  