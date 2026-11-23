{{ config(materialized = 'table', schema = 'dw_ecoessentials') }}

with pg_people as (
    select
        upper(trim(customer_first_name)) as first_name_clean,
        upper(trim(customer_last_name))  as last_name_clean,
        min(trim(customer_first_name))   as first_name,
        min(trim(customer_last_name))    as last_name,
        min(customer_email)              as email,
        min(customer_phone)              as phone,
        min(customer_address)            as address,
        min(customer_city)               as city,
        min(customer_state)              as state,
        min(customer_zip)                as zip,
        min(customer_country)            as country
    from {{ source('eco_postgres', 'customer') }}
    group by 1, 2
),

email_people as (
    select
        upper(trim(subscriberfirstname)) as first_name_clean,
        upper(trim(subscriberlastname))  as last_name_clean,
        min(trim(subscriberfirstname))   as first_name,
        min(trim(subscriberlastname))    as last_name,
        min(subscriberemail)             as email
    from {{ source('eco_email', 'marketing_emails') }}
    group by 1, 2
),

combined as (
    select
        coalesce(pg.first_name_clean, e.first_name_clean) as first_name_clean,
        coalesce(pg.last_name_clean, e.last_name_clean)   as last_name_clean,
        coalesce(pg.first_name, e.first_name)             as first_name,
        coalesce(pg.last_name, e.last_name)               as last_name,
        coalesce(pg.email, e.email)                       as email,
        pg.phone,
        pg.address,
        pg.city,
        pg.state,
        pg.zip,
        pg.country,
        (pg.first_name_clean is not null)                 as in_sales_data,
        (e.first_name_clean is not null)                  as in_email_data
    from pg_people pg
    full outer join email_people e
        on pg.first_name_clean = e.first_name_clean
        and pg.last_name_clean = e.last_name_clean
)

select
    {{ dbt_utils.generate_surrogate_key(['first_name_clean', 'last_name_clean']) }} as customer_key,
    *
from combined