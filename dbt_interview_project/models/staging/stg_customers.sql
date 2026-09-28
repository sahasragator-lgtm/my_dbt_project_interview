select
    customer_id,
    first_name,
    last_name,
    email,
    state,
    created_at
from {{ source('raw', 'CUSTOMERS') }}