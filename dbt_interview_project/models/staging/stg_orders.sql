select
    order_id,
    customer_id,
    order_ts,
    order_status,
    updated_at
from {{ source('raw', 'ORDERS') }}