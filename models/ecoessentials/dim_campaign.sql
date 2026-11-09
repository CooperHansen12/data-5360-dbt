{{ config(materialized = 'table', schema = 'dw_ecoessentials') }}

with pg as (
    select
        campaign_id,
        campaign_name,
        campaign_discount
    from {{ source('eco_postgres', 'promotional_campaign') }}
),

em as (
    select
        campaignid as campaign_id,
        min(campaignname) as campaign_name
    from {{ source('eco_email', 'marketing_emails') }}
    group by campaignid
)

select
    coalesce(pg.campaign_id, em.campaign_id)     as campaign_key,
    coalesce(pg.campaign_id, em.campaign_id)     as campaign_id,
    coalesce(pg.campaign_name, em.campaign_name) as campaign_name,
    pg.campaign_discount
from pg
full outer join em
    on pg.campaign_id = em.campaign_id