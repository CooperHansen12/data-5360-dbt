{{ config(materialized = 'table', schema = 'dw_ecoessentials') }}

select
    d.date_key,
    cu.customer_key,
    p.product_key,
    ca.campaign_key,
    ol.order_id,
    ol.order_line_id,
    ol.quantity,
    ol.discount,
    ol.price_after_discount
from {{ source('eco_postgres', 'order_line') }} ol
inner join {{ source('eco_postgres', 'order') }} o
    on ol.order_id = o.order_id
inner join {{ source('eco_postgres', 'customer') }} pc
    on o.customer_id = pc.customer_id
left join {{ ref('dim_customer') }} cu
    on upper(trim(pc.customer_first_name)) = cu.first_name_clean
    and upper(trim(pc.customer_last_name)) = cu.last_name_clean
left join {{ ref('dim_product') }} p
    on ol.product_id = p.product_id
left join {{ ref('dim_campaign') }} ca
    on ol.campaign_id = ca.campaign_id
left join {{ ref('dim_date') }} d
    on cast(o.order_timestamp as date) = d.date_day