--liquibase formatted sql

--changeset sana:001-create-orders-table
CREATE TABLE orders (
            id   BIGSERIAL PRIMARY KEY,
            customer_name VARCHAR(255) NOT NULL,
            status  VARCHAR(50)  NOT NULL,
            created_at  TIMESTAMP    NOT NULL
);