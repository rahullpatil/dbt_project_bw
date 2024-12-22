select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select provider_id
from DBT_TEST.STG.fct_leads
where provider_id is null



      
    ) dbt_internal_test