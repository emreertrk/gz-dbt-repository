with

int_orders_margin as (
    select * from {{ ref('int_orders_margin') }}
),

int_orders_operational as (
    select * from {{ ref('int_orders_operational') }}
),

ship as (
    select * from {{ ref('stg_raw__ship') }}
),

joined as (
    select
        int_orders_margin.date_date,
        int_orders_margin.orders_id,
        int_orders_margin.revenue,
        int_orders_margin.quantity,
        int_orders_margin.purchase_cost,
        int_orders_operational.operational_margin,
        ship.shipping_fee,
        ship.logcost
    from int_orders_margin
    left join int_orders_operational
        on int_orders_margin.orders_id = int_orders_operational.orders_id
    left join ship
        on int_orders_margin.orders_id = ship.orders_id
),

aggregated as (
    select
        date_date,
        COUNT(orders_id) as nb_transactions,
        ROUND(SUM(revenue), 2) as revenue,
        ROUND(SUM(revenue) / COUNT(orders_id), 2) as average_basket,
        ROUND(SUM(operational_margin), 2) as operational_margin,
        ROUND(SUM(purchase_cost), 2) as purchase_cost,
        ROUND(SUM(shipping_fee), 2) as shipping_fee,
        ROUND(SUM(logcost), 2) as logcost,
        SUM(quantity) as quantity
    from joined
    group by date_date
)

select * from aggregated