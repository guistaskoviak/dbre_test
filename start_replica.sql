-- Log params
ALTER SYSTEM SET log_colletor = on;

-- Table orders
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    product_name TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    order_date DATE NOT NULL
);

-- Create sub
CREATE SUBSCRIPTION sub_replica_orders
CONNECTION 'host=pg_master port=5432 dbname=testDB user=admin password=admin'
PUBLICATION pub_master_orders;
