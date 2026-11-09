{{ config(materialized = 'table', schema = 'dw_ecoessentials') }}

select
    emailid as email_key,
    emailid,
    min(emailname) as emailname
from {{ source('eco_email', 'marketing_emails') }}
group by emailid