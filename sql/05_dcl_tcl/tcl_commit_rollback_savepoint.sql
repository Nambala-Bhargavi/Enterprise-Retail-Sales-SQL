-- ============================================================
-- tcl_commit_rollback_savepoint.sql  (TCL: COMMIT, ROLLBACK, SAVEPOINT)
-- Safe to re-run: real data ends exactly as it started.
-- ============================================================
USE retail_sales_db;

-- ---- Example 1: ROLLBACK undoes everything since START TRANSACTION ----
START TRANSACTION;
UPDATE products SET unit_price = unit_price * 2 WHERE product_id = 1;
SELECT product_id, unit_price AS price_inside_transaction FROM products WHERE product_id = 1;
ROLLBACK;
SELECT product_id, unit_price AS price_after_rollback FROM products WHERE product_id = 1;

-- ---- Example 2: SAVEPOINT = partial rollback ----
START TRANSACTION;
INSERT INTO regions (region_name) VALUES ('Region-A');
SAVEPOINT after_region_a;
INSERT INTO regions (region_name) VALUES ('Region-B');
SELECT region_name FROM regions WHERE region_name LIKE 'Region-%';   -- A and B visible
ROLLBACK TO SAVEPOINT after_region_a;                                -- undo only Region-B
SELECT region_name FROM regions WHERE region_name LIKE 'Region-%';   -- only A remains
ROLLBACK;                                                            -- undo the rest
SELECT COUNT(*) AS region_rows_left FROM regions WHERE region_name LIKE 'Region-%';  -- 0

-- ---- Example 3: COMMIT makes changes permanent (scratch table) ----
CREATE TABLE tcl_demo (id INT PRIMARY KEY, note VARCHAR(50));
START TRANSACTION;
INSERT INTO tcl_demo VALUES (1, 'saved permanently');
COMMIT;
SELECT * FROM tcl_demo;
DROP TABLE tcl_demo;
