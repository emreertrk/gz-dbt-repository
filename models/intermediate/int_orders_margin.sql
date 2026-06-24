with

int_sales_margin as (
    select * from {{ ref('int_sales_margin') }}
),

aggregated as (
    select
        orders_id,
        date_date,
        SUM(revenue) as revenue,
        SUM(quantity) as quantity,
        SUM(purchase_cost) as purchase_cost,
        SUM(margin) as margin
    from int_sales_margin
    group by orders_id, date_date
)

select * from aggregated