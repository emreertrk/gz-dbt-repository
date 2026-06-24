with

int_orders_margin as (
    select * from {{ ref('int_orders_margin') }}
),

ship as (
    select * from {{ ref('stg_raw__ship') }}
),

joined as (
    select
        int_orders_margin.orders_id,
        int_orders_margin.date_date,
        int_orders_margin.margin
        + ship.shipping_fee
        - ship.logcost
        - ship.ship_cost as operational_margin
    from int_orders_margin
    left join ship
        on int_orders_margin.orders_id = ship.orders_id
)

select * from joined