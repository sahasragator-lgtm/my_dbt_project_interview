select
    product_id,
    product_name,
    category,
    unit_price,
    active_flag
from {{ source('raw', 'PRODUCTS') }}