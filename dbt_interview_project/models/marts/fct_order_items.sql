{{ 
    config(
        materialized='incremental',
        unique_key='order_detail_id',
        incremental_strategy='merge'
    ) 
}}

-- with orders as (

    -- select *
    {# from {{ ref('stg_orders') }} #}

    -- {% if is_incremental() %}
        -- where updated_at >
            -- (
                {# select coalesce(max(order_updated_at), '1900-01-01') #}
                {# from {{ this }} #}
            -- )
    -- {% endif %}
-- ),
--variable version
-- with orders as (
    -- select *
    {# from {{ ref('stg_orders') }} #}

    -- {% if is_incremental() %}
        -- where updated_at >=
        -- (
            -- select dateadd(day,
            -- ---2
            {# -{{ var('lookback_days', 2) }} #}
            {# ,coalesce(max(order_updated_at), '1900-01-01')) #}
            {# from {{ this }} #}
        -- )
    -- {% endif %}
-- ),
--batch control version
with orders as (
    select *
    from {{ ref('stg_orders') }}

    {% if is_incremental() %}

        where updated_at > '{{ var("batch_start") }}'
         and updated_at <= '{{ var("batch_end") }}'

    {% endif %}
),
order_items as (
    select *
    from {{ ref('stg_order_items') }}
)

select
    oi.order_detail_id,
    oi.order_id,

    dc.customer_key,
    dp.product_key,

    o.order_ts,
    o.order_status,
    o.updated_at as order_updated_at,

    oi.line_number,
    oi.quantity,
    oi.unit_price,
    oi.line_amount

from order_items oi

join orders o
    on oi.order_id = o.order_id

join {{ ref('dim_customers') }} dc
    on o.customer_id = dc.customer_id
   and o.order_ts >= dc.effective_from
   and (o.order_ts < dc.effective_to or dc.effective_to is null )

join {{ ref('dim_products') }} dp
    on oi.product_id = dp.product_id
   and o.order_ts >= dp.effective_from
   and (o.order_ts < dp.effective_to or dp.effective_to is null  )