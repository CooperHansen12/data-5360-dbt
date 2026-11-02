with certs as (

    select * from {{ ref('stg_employee_certifications') }}

),

dim_employee as (

    select * from {{ ref('oliver_dim_employee') }}

),

dim_date as (

    select * from {{ ref('oliver_dim_date') }}

)

select
    dim_employee.employee_key,
    dim_date.date_key,
    certs.certification_name,
    certs.certification_cost
from certs
left join dim_employee
    on certs.employee_id = dim_employee.employee_id
left join dim_date
    on certs.certification_awarded_date = dim_date.date_day