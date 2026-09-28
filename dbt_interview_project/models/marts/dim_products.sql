with product_history as (

    select
        dbt_scd_id as product_key,
        product_id,
        product_name,
        category,
        unit_price,
        active_flag,
        dbt_valid_from,
        dbt_valid_to,

        row_number() over (
            partition by product_id
            order by dbt_valid_from
        ) as version_number

    from {{ ref('products_snapshot') }}

)

select
    product_key,
    product_id,
    product_name,
    category,
    unit_price,
    active_flag,

    case
        when version_number = 1
            then cast('1900-01-01' as timestamp)
        else dbt_valid_from
    end as effective_from,

    dbt_valid_to as effective_to,

    case
        when dbt_valid_to is null then true
        else false
    end as is_current

from product_history