-- ============================================================
-- 03_alter_rename_truncate_drop.sql
-- Purpose : Demonstrate DDL commands ALTER, RENAME, TRUNCATE, DROP
--           (uses a scratch table so the real tables stay safe)
-- ============================================================
USE retail_sales_db;

-- CREATE a scratch table
CREATE TABLE demo_feedback (
    feedback_id  INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT NOT NULL,
    comment_text VARCHAR(200)
);

-- ALTER : add a column, change a data type, drop a column
ALTER TABLE demo_feedback ADD COLUMN rating TINYINT NULL;
ALTER TABLE demo_feedback MODIFY COLUMN comment_text VARCHAR(500);
ALTER TABLE demo_feedback DROP COLUMN rating;

-- RENAME : rename the table
RENAME TABLE demo_feedback TO customer_feedback_demo;

-- Insert two rows, then TRUNCATE (removes all rows, keeps structure)
INSERT INTO customer_feedback_demo (customer_id, comment_text) VALUES (1, 'Great service'), (2, 'Fast delivery');
TRUNCATE TABLE customer_feedback_demo;

-- DROP : remove the table completely (structure + data)
DROP TABLE customer_feedback_demo;

-- Real-table ALTER example: add a loyalty flag to customers
ALTER TABLE customers ADD COLUMN is_active TINYINT(1) NOT NULL DEFAULT 1;
