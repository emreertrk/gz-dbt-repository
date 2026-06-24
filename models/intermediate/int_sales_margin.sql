with

sales as (
    select * from {{ ref('stg_raw__sales') }}
),

product as (
    select * from {{ ref('stg_raw__product') }}
),

joined as (
    select
        sales.orders_id,
        sales.date_date,
        sales.products_id,
        sales.revenue,
        sales.quantity,
        product.purchase_price,
        CAST(sales.quantity AS INT64) * product.purchase_price as purchase_cost,
        sales.revenue - (CAST(sales.quantity AS INT64) * product.purchase_price) as margin
    from sales
    left join product
        on sales.products_id = product.products_id
)

select * from joined