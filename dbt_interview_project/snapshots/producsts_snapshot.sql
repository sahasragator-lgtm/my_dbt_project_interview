{% snapshot products_snapshot %}

{{
    config(
        target_schema='SNAPSHOTS',
        unique_key='product_id',
        strategy='check',
        check_cols=[
            'product_name',
            'category',
            'unit_price',
            'active_flag'
        ]
    )
}}

select
    product_id,
    product_name,
    category,
    unit_price,
    active_flag
from {{ ref('stg_products') }}

{% endsnapshot %}