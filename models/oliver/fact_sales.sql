{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

select
    ol.order_line_id,
    ol.order_id,
    p.product_key,
    cu.customer_key,
    e.employee_key,
    s.store_key,
    d.date_key,
    ol.quantity,
    ol.unit_price,
    ol.quantity * ol.unit_price as line_total
from {{ source('oliver_landing', 'orderline') }} ol
inner join {{ source('oliver_landing', 'orders') }} o
    on ol.order_id = o.order_id
inner join {{ ref('oliver_dim_product') }} p
    on ol.product_id = p.product_id
inner join {{ ref('oliver_dim_customer') }} cu
    on o.customer_id = cu.customer_id
inner join {{ ref('oliver_dim_employee') }} e
    on o.employee_id = e.employee_id
inner join {{ ref('oliver_dim_store') }} s
    on o.store_id = s.store_id
inner join {{ ref('oliver_dim_date') }} d
    on cast(o.order_date as date) = d.date_day