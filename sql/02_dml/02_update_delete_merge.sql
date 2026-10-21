-- ============================================================
-- 02_update_delete_merge.sql  (DML: UPDATE, DELETE, MERGE/UPSERT)
-- Safe to re-run: every change below is undone by the end of the
-- script, so report numbers never change.
-- ============================================================
USE retail_sales_db;

-- INSERT a test customer (CRUD: Create)
INSERT INTO customers (customer_name, email, phone, segment, region_id, signup_date)
VALUES ('Test Customer', 'test.customer@example.com', '9000000000', 'Retail', 1, '2025-06-01');

-- READ it back (CRUD: Read)
SELECT customer_id, customer_name, email, phone
FROM customers
WHERE customer_name = 'Test Customer';

-- UPDATE (CRUD: Update) -- always use WHERE, otherwise ALL rows change!
UPDATE customers
SET phone = '9111111111', segment = 'Corporate'
WHERE customer_name = 'Test Customer';

SELECT customer_id, customer_name, phone, segment
FROM customers
WHERE customer_name = 'Test Customer';

-- DELETE (CRUD: Delete) -- always use WHERE
DELETE FROM customers
WHERE customer_name = 'Test Customer';

-- MERGE / UPSERT
-- MySQL has no MERGE keyword. The equivalent is INSERT ... ON DUPLICATE KEY UPDATE:
-- insert the row if the key is new, otherwise update the existing row.
CREATE TABLE price_staging (
    product_name VARCHAR(100) NOT NULL PRIMARY KEY,
    new_price    DECIMAL(10,2) NOT NULL
);
INSERT INTO price_staging VALUES ('Cotton T-Shirt', 699.00);

-- (SQL Server equivalent for reference:
--  MERGE INTO target USING source ON ... WHEN MATCHED THEN UPDATE ... WHEN NOT MATCHED THEN INSERT ...;)
INSERT INTO price_staging (product_name, new_price) VALUES ('Cotton T-Shirt', 749.00)
ON DUPLICATE KEY UPDATE new_price = VALUES(new_price);

SELECT * FROM price_staging;   -- shows 749.00 (updated, not duplicated)
DROP TABLE price_staging;
