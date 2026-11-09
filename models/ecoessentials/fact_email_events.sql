{{ config(materialized = 'table', schema = 'dw_ecoessentials') }}

select
    d.date_key,
    cu.customer_key,
    ca.campaign_key,
    em.email_key,
    et.event_type_key,
    e.emaileventid,
    e.sendtimestamp  as send_timestamp,
    e.eventtimestamp as event_timestamp,
    1 as event_count
from {{ source('eco_email', 'marketing_emails') }} e
left join {{ ref('dim_customer') }} cu
    on upper(trim(e.subscriberfirstname)) = cu.first_name_clean
    and upper(trim(e.subscriberlastname)) = cu.last_name_clean
left join {{ ref('dim_campaign') }} ca
    on e.campaignid = ca.campaign_id
left join {{ ref('dim_email') }} em
       on e.emailid = em.emailid
left join {{ ref('dim_event_type') }} et
    on upper(trim(e.eventtype)) = et.event_type
left join {{ ref('dim_date') }} d
    on cast(e.eventtimestamp as date) = d.date_day