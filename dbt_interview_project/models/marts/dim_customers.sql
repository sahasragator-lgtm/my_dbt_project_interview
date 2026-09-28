with customer_history as (

    select
        dbt_scd_id as customer_key,
        customer_id,
        first_name,
        last_name,
        email,
        state,
        created_at,
        dbt_valid_from,
        dbt_valid_to,

        row_number() over (
            partition by customer_id
            order by dbt_valid_from
        ) as version_number

    from {{ ref('customers_snapshot') }}

)

select
    customer_key,
    customer_id,
    first_name,
    last_name,
    email,
    state,
    created_at,

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

from customer_history