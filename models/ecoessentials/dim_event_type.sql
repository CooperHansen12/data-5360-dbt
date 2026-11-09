{{ config(materialized = 'table', schema = 'dw_ecoessentials') }}

select distinct
    {{ dbt_utils.generate_surrogate_key(["upper(trim(eventtype))"]) }} as event_type_key,
    upper(trim(eventtype)) as event_type
from {{ source('eco_email', 'marketing_emails') }}
where eventtype is not null