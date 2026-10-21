-- ============================================================
-- 02_create_tables.sql
-- Purpose : Normalized (3NF) schema for the retail database
-- Tables  : regions, employees, customers, categories,
--           products, orders, order_items
-- ============================================================
USE retail_sales_db;

-- 1) REGIONS : lookup table (one row per sales region)
CREATE TABLE regions (
    region_id    INT          NOT NULL AUTO_INCREMENT,
    region_name  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_regions PRIMARY KEY (region_id),
    CONSTRAINT uq_regions_name UNIQUE (region_name)
);

-- 2) EMPLOYEES : sales staff; manager_id points to another employee (self relationship)
CREATE TABLE employees (
    employee_id  INT          NOT NULL AUTO_INCREMENT,
    full_name    VARCHAR(100) NOT NULL,
    job_title    VARCHAR(50)  NOT NULL,
    manager_id   INT          NULL,
    region_id    INT          NOT NULL,
    hire_date    DATE         NOT NULL,
    CONSTRAINT pk_employees PRIMARY KEY (employee_id),
    CONSTRAINT fk_employees_manager FOREIGN KEY (manager_id) REFERENCES employees (employee_id),
    CONSTRAINT fk_employees_region  FOREIGN KEY (region_id)  REFERENCES regions (region_id)
);

-- 3) CUSTOMERS
CREATE TABLE customers (
    customer_id    INT          NOT NULL AUTO_INCREMENT,
    customer_name  VARCHAR(100) NOT NULL,
    email          VARCHAR(120) NULL,          -- NULL allowed: some customers have no email
    phone          VARCHAR(20)  NULL,
    segment        VARCHAR(20)  NOT NULL,      -- Retail / Corporate / Wholesale
    region_id      INT          NOT NULL,
    signup_date    DATE         NOT NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT fk_customers_region FOREIGN KEY (region_id) REFERENCES regions (region_id),
    CONSTRAINT ck_customers_segment CHECK (segment IN ('Retail', 'Corporate', 'Wholesale'))
);

-- 4) CATEGORIES : lookup table
CREATE TABLE categories (
    category_id    INT          NOT NULL AUTO_INCREMENT,
    category_name  VARCHAR(50)  NOT NULL,
    CONSTRAINT pk_categories PRIMARY KEY (category_id),
    CONSTRAINT uq_categories_name UNIQUE (category_name)
);

-- 5) PRODUCTS
CREATE TABLE products (
    product_id    INT            NOT NULL AUTO_INCREMENT,
    product_name  VARCHAR(100)   NOT NULL,
    category_id   INT            NOT NULL,
    unit_cost     DECIMAL(10,2)  NOT NULL,
    unit_price    DECIMAL(10,2)  NOT NULL,
    CONSTRAINT pk_products PRIMARY KEY (product_id),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories (category_id),
    CONSTRAINT ck_products_price CHECK (unit_price > 0 AND unit_cost >= 0)
);

-- 6) ORDERS : one row per customer order (header)
CREATE TABLE orders (
    order_id     INT          NOT NULL AUTO_INCREMENT,
    customer_id  INT          NOT NULL,
    employee_id  INT          NOT NULL,
    order_date   DATE         NOT NULL,
    status       VARCHAR(15)  NOT NULL DEFAULT 'Completed',
    CONSTRAINT pk_orders PRIMARY KEY (order_id),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers (customer_id),
    CONSTRAINT fk_orders_employee FOREIGN KEY (employee_id) REFERENCES employees (employee_id),
    CONSTRAINT ck_orders_status CHECK (status IN ('Completed', 'Cancelled', 'Returned'))
);

-- 7) ORDER_ITEMS : one row per product on an order (detail)
CREATE TABLE order_items (
    order_item_id  INT            NOT NULL AUTO_INCREMENT,
    order_id       INT            NOT NULL,
    product_id     INT            NOT NULL,
    quantity       INT            NOT NULL,
    unit_price     DECIMAL(10,2)  NOT NULL,   -- price at time of sale (can differ from products.unit_price later)
    discount_pct   DECIMAL(5,2)   NOT NULL DEFAULT 0,
    CONSTRAINT pk_order_items PRIMARY KEY (order_item_id),
    CONSTRAINT fk_items_order   FOREIGN KEY (order_id)   REFERENCES orders (order_id),
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products (product_id),
    CONSTRAINT ck_items_qty CHECK (quantity > 0),
    CONSTRAINT ck_items_discount CHECK (discount_pct BETWEEN 0 AND 50)
);

-- Indexes on foreign keys / frequently filtered columns (query performance)
CREATE INDEX idx_orders_date      ON orders (order_date);
CREATE INDEX idx_orders_customer  ON orders (customer_id);
CREATE INDEX idx_items_order      ON order_items (order_id);
CREATE INDEX idx_items_product    ON order_items (product_id);
