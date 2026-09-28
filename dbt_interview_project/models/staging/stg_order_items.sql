select
    order_detail_id,
    order_id,
    line_number,
    product_id,
    quantity,
    unit_price,
    line_amount
from {{ source('raw', 'ORDER_ITEMS') }}