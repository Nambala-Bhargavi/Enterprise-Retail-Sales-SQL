-- ============================================================
-- 00_run_all.sql : builds the whole project from scratch in the correct order
-- Run from the /sql folder:   mysql -u root -p < 00_run_all.sql
-- (In MySQL Workbench, open and run each file below in this order instead.)
-- ============================================================
SOURCE 01_ddl/01_create_database.sql;
SOURCE 01_ddl/02_create_tables.sql;
SOURCE 01_ddl/03_alter_rename_truncate_drop.sql;
SOURCE 02_dml/01_insert_data.sql;
SOURCE 02_dml/02_update_delete_merge.sql;
SOURCE 06_reports/01_views_and_business_reports.sql;
