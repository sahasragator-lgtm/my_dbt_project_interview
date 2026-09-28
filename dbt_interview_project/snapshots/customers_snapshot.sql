{% snapshot customers_snapshot %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='customer_id',
        strategy='check',
        check_cols=[
            'first_name',
            'last_name',
            'email',
            'state'
        ]
    )
}}

select
    customer_id,
    first_name,
    last_name,
    email,
    state,
    created_at
from {{ ref('stg_customers') }}

{% endsnapshot %}