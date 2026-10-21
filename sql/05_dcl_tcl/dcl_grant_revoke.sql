-- ============================================================
-- dcl_grant_revoke.sql  (DCL: GRANT, REVOKE)
-- Purpose : Role-based access: analysts read-only, data-entry can add customers
-- Note    : Needs an admin account (e.g. root). Safe to re-run.
-- ============================================================
DROP USER IF EXISTS 'report_analyst'@'localhost';
CREATE USER 'report_analyst'@'localhost' IDENTIFIED BY 'Analyst@123';

-- GRANT: read-only access to every table in the database
GRANT SELECT ON retail_sales_db.* TO 'report_analyst'@'localhost';

-- GRANT: also allow INSERT and UPDATE on customers only
GRANT INSERT, UPDATE ON retail_sales_db.customers TO 'report_analyst'@'localhost';

SHOW GRANTS FOR 'report_analyst'@'localhost';

-- REVOKE: take back the UPDATE permission
REVOKE UPDATE ON retail_sales_db.customers FROM 'report_analyst'@'localhost';

SHOW GRANTS FOR 'report_analyst'@'localhost';

-- Clean up
DROP USER 'report_analyst'@'localhost';
