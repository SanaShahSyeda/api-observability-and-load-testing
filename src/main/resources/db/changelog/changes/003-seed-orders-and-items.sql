--liquibase formatted sql

--changeset sana:003-seed-orders-and-items context:dev
-- Demo/dev seed data: enough volume for N+1 and missing-index bottlenecks
-- to actually show up under load testing (a handful of rows won't reveal them).

INSERT INTO orders (customer_name, status, created_at)
SELECT
    'Customer ' || i,
    (ARRAY['PENDING', 'SHIPPED', 'DELIVERED', 'CANCELLED'])[1 + floor(random() * 4)::int],
    now() - (random() * interval '365 days')
FROM generate_series(1, 2000) AS s(i);

INSERT INTO order_items (order_id, product_name, quantity, unit_price)
SELECT
    o.id,
    'Product ' || (1 + floor(random() * 50)::int),
    1 + floor(random() * 5)::int,
    round((random() * 100 + 5)::numeric, 2)
FROM orders o
         CROSS JOIN LATERAL generate_series(1, 3 + floor(random() * 3)::int) AS gs(n);