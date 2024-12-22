-- Use the `ref` function to select from other models

select *
from DBT_TEST.STG.my_first_dbt_model
where id = 1