# Database Reliability Engineer Test

## 1. Tasks

### 1.1. Docker Compose Setup

Write a docker-compose.yml file to set up two PostgreSQL instances named pg_master and pg_replica.

```yaml
services:
  pg_master:
    image: postgres:13
    container_name: pg_master
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
      POSTGRES_DB: testDB
    ports:
      - "5432:5432"
    volumes:
      - ./pg_master_data:/var/lib/postgresql/data
      - ./start_master.sql:/docker-entrypoint-initdb.d/start_master.sql
    restart: always

  pg_replica:
    image: postgres:13
    container_name: pg_replica
    environment:
      POSTGRES_USER: admin
      POSTGRES_PASSWORD: admin
      POSTGRES_DB: testDB
    ports:
      - "5433:5432"
    volumes:
      - ./pg_replica_data:/var/lib/postgresql/data
      - ./start_replica.sql:/docker-entrypoint-initdb.d/start_replica.sql
    restart: always
 ```

### 1.2. Database Creation and Schema Setup

Create a PostgreSQL database called testDB inside the pg_master. Inside testDB, create a table called orders with the following columns:
- id: Integer, primary key, auto-increment
- product_name: Text
- quantity: Integer
- order_date: Date

**`start_master.sql`**
```sql
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
```

**`start_replica.sql`**
```sql
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
```

Create a small script which will insert some sample rows into the orders table. This will be needed for the next exercises.

**`insert_data.sql`**
```sql
INSERT INTO orders (product_name, quantity, order_date) VALUES
('Notebook', 2, '2025-03-21'),
('Headset', 5, '2025-03-20'),
('Keyboard', 3, '2025-03-19'),
('Monitor', 12, '2025-04-25'),
('Webcam', 9, '2025-09-01');
```

### 1.3. Deliverable

Configure the pg_master instance to act as a publisher.
```sql
-- Create pub
CREATE PUBLICATION pub_master_orders FOR TABLE orders;
```

Configure the pg_replica instance to act as a subscriber.
```sql
-- Create sub
CREATE SUBSCRIPTION sub_replica_orders
CONNECTION 'host=pg_master port=5432 dbname=testDB user=admin password=admin'
PUBLICATION pub_master_orders;
```

Set up logical replication from pg_master to pg_replica for the orders table.

Inserting data:
```sh
docker exec -i pg_master psql -U admin -d testDB < insert_data.sql
```

Validate that changes on pg_master are reflected on pg_replica by using the script from 1.

Check master:
```sh
docker exec -i pg_master psql -U admin -d testDB -c "select * from orders;"
```

Check replica:
```sh
docker exec -i pg_replica psql -U admin -d testDB -c "select * from orders;"
```

