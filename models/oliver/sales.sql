{{ config(
    materialized = 'table',
    schema = 'dw_oliver'
) }}

select
    f.order_id,
    f.order_line_id,
    d.date_day as order_date,
    c.first_name as customer_first_name,
    c.last_name as customer_last_name,
    e.first_name as employee_first_name,
    e.last_name as employee_last_name,
    s.store_name,
    s.city as store_city,
    s.state as store_state,
    p.product_name,
    f.quantity,
    f.unit_price,
    f.line_total
from {{ ref('fact_sales') }} f
left join {{ ref('oliver_dim_customer') }} c on f.customer_key = c.customer_key
left join {{ ref('oliver_dim_employee') }} e on f.employee_key = e.employee_key
left join {{ ref('oliver_dim_store') }} s on f.store_key = s.store_key
left join {{ ref('oliver_dim_product') }} p on f.product_key = p.product_key
left join {{ ref('oliver_dim_date') }} d on f.date_key = d.date_key