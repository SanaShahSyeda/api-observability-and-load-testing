--liquibase formatted sql

--changeset sana:002-create-order-items-table
CREATE TABLE order_items (
        id BIGSERIAL PRIMARY KEY,
        order_id  BIGINT NOT NULL REFERENCES orders (id),
        product_name  VARCHAR(255) NOT NULL,
        quantity  INT NOT NULL,
        unit_price DECIMAL(10, 2) NOT NULL
);

CREATE INDEX idx_order_items_order_id ON order_items (order_id);