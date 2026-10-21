# Query Documentation: what each script does and which SQL concept it teaches

| Script | Concept | What to say in an interview |
|---|---|---|
| `01_ddl/01_create_database.sql` | CREATE DATABASE | A database is the container for all tables; utf8mb4 stores any language/emoji. |
| `01_ddl/02_create_tables.sql` | CREATE TABLE, PRIMARY KEY, FOREIGN KEY, UNIQUE, CHECK, NOT NULL, DEFAULT, INDEX | Constraints protect data quality inside the database, so bad data cannot be inserted. |
| `01_ddl/03_alter_rename_truncate_drop.sql` | ALTER, RENAME, TRUNCATE, DROP | ALTER changes structure; TRUNCATE empties a table but keeps it; DROP deletes the table itself. |
| `02_dml/01_insert_data.sql` | INSERT | Parent tables (regions, categories) are loaded before child tables so foreign keys are valid. |
| `02_dml/02_update_delete_merge.sql` | UPDATE, DELETE, MERGE/UPSERT | UPDATE/DELETE always need WHERE. MySQL has no MERGE, so `INSERT ... ON DUPLICATE KEY UPDATE` does the same job. |
| `03_dql/01_select_filter_sort.sql` | SELECT, WHERE, AND/OR/NOT, IN, BETWEEN, LIKE, IS NULL, ORDER BY, DISTINCT, LIMIT, CASE | Filtering happens in WHERE; sorting in ORDER BY; CASE is SQL's if-else. |
| `03_dql/02_aggregates_group_having.sql` | COUNT, SUM, AVG, MIN, MAX, GROUP BY, HAVING | WHERE filters rows before grouping; HAVING filters groups after grouping. COUNT(column) skips NULLs, COUNT(*) does not. |
| `04_joins/joins.sql` | INNER, LEFT, RIGHT, FULL (emulated), SELF, CROSS | INNER = matches only; LEFT = all left rows; FULL = UNION of LEFT and RIGHT in MySQL; SELF JOIN links employee to manager. |
| `05_dcl_tcl/dcl_grant_revoke.sql` | CREATE USER, GRANT, REVOKE | Give each user the minimum permissions needed (least privilege). |
| `05_dcl_tcl/tcl_commit_rollback_savepoint.sql` | START TRANSACTION, COMMIT, ROLLBACK, SAVEPOINT | A transaction is all-or-nothing. SAVEPOINT lets you undo only part of it. |
| `06_reports/01_views_and_business_reports.sql` | VIEW, multi-table JOIN, subquery, business KPIs | A view stores a query so every report uses the same revenue definition. `v_sales_detail` is what Power BI will read in Task 5. |

## Business rules used in every report
* Revenue counts **Completed** orders only (Cancelled and Returned are excluded).
* Line revenue = `quantity x unit_price x (1 - discount_pct / 100)`.
* Line cost = `quantity x products.unit_cost`. Profit = revenue - cost.

## Four questions interviewers always ask
1. **DELETE vs TRUNCATE vs DROP?** DELETE removes chosen rows (can ROLLBACK); TRUNCATE removes all rows fast and keeps the table; DROP removes the table itself.
2. **WHERE vs HAVING?** WHERE filters rows before GROUP BY; HAVING filters the grouped results.
3. **INNER vs LEFT JOIN?** INNER keeps only matching rows; LEFT keeps every left-table row and shows NULL where there is no match (used to find customers who never ordered).
4. **Primary key vs Foreign key?** A primary key uniquely identifies a row in its own table; a foreign key points to a primary key in another table and enforces the relationship.
