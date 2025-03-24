-- Logical rep params
ALTER SYSTEM SET wal_level = logical;
ALTER SYSTEM SET max_replication_slots = 10;
ALTER SYSTEM SET max_wal_senders = 10;
ALTER SYSTEM SET log_colletor = on;
SELECT pg_reload_conf();

-- Table orders
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    order_date DATE NOT NULL
);

-- Create pub
CREATE PUBLICATION pub_master_orders FOR TABLE orders;
