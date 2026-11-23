{{ config(materialized = 'table', schema = 'dw_ecoessentials') }}

with cte_date as (
    {{ dbt_date.get_date_dimension("2015-01-01", "2035-12-31") }}
)

select
    date_day as date_key,
    date_day,
    day_of_week,
    month_of_year,
    month_name,
    quarter_of_year,
    year_number
from cte_date