select
    order_detail_id,
    order_id,
    line_amount,

    {{ cents_to_dollars('line_amount * 100') }} as calculated_amount

from {{ ref('stg_order_items') }}