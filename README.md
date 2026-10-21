# Enterprise Retail Sales Database (SQL Project)
**Sumerix Global: Data Analytics & Business Intelligence Internship, Task 3 (SQL Fundamentals, Database Design and Business Queries)**

## 1. Project overview
A retail company kept sales data in spreadsheets, which caused repeated values and errors. This project moves it into a **normalized relational database (MySQL)** and answers business questions with SQL: sales trend, regional revenue, top customers, product performance and customer growth.

## 2. What is inside
```
Enterprise-Retail-Sales-SQL/
├── sql/
│   ├── 00_run_all.sql                    (builds everything in the right order)
│   ├── 01_ddl/   create database, create tables, ALTER / RENAME / TRUNCATE / DROP
│   ├── 02_dml/   INSERT sample data, UPDATE / DELETE / MERGE (upsert)
│   ├── 03_dql/   SELECT, WHERE, ORDER BY, aggregates, GROUP BY, HAVING
│   ├── 04_joins/ INNER, LEFT, RIGHT, FULL, SELF, CROSS joins
│   ├── 05_dcl_tcl/ GRANT / REVOKE, COMMIT / ROLLBACK / SAVEPOINT
│   └── 06_reports/ views + 10 business reports
├── docs/         ERD, design and normalization, query documentation, insights
├── reports_output/ 10 report CSV files + All_Business_Reports.xlsx
├── screenshots/  (add your own screenshots here, see section 6)
└── README.md
```

## 3. Database design
7 tables in Third Normal Form: `regions`, `employees`, `customers`, `categories`, `products`, `orders`, `order_items`.
Sample data: 5 regions, 10 employees, 60 customers, 20 products, 400 orders, 986 order items.
See `docs/ERD_retail_sales_db.png` and `docs/Database_Design_and_Normalization.md`.

## 4. How to run
**Option A: MySQL Workbench (easiest on Windows)**
1. Install *MySQL Community Server* and *MySQL Workbench*, then connect to your local server.
2. Open and run these files **in this order** (lightning icon):
   `01_ddl/01_create_database.sql` → `02_create_tables.sql` → `03_alter_rename_truncate_drop.sql` → `02_dml/01_insert_data.sql` → `02_dml/02_update_delete_merge.sql`
3. Then run any file in `03_dql`, `04_joins`, `05_dcl_tcl` and `06_reports`.

**Option B: command line** (from the `sql` folder): `mysql -u root -p < 00_run_all.sql`

## 5. Business reports (06_reports)
1. Executive KPI summary
2. Monthly sales with month-over-month growth
3. Regional revenue and share
4. Top 10 customers by revenue
5. Product performance (includes never-sold products)
6. Category profitability
7. Customer growth (signups per month and running total)
8. Customer segment analysis
9. Sales-rep performance with manager
10. Cancelled / returned orders (business risk)

## 6. Key results
| KPI | Value |
|---|---|
| Total revenue | ₹1,72,21,266 |
| Total profit | ₹52,16,166 (30.3% margin) |
| Completed orders | 376 |
| Average order value | ₹45,801 |
| Best region | East (31.2% of revenue) |
| Top profit product | Laptop 15 inch |
| Highest-revenue month | November |

Full insights and recommendations: `docs/Business_Insights_and_Recommendations.md`. Charts: `docs/report_charts.png`.

## 7. Screenshots
Add screenshots of the database running on the machine used, for example: tables list in MySQL Workbench, `SELECT COUNT(*)` row counts, a JOIN result, the monthly sales report, and the ERD.

## 8. Notes and assumptions
* Sample data is simulated for learning and is not real company data.
* Scripts were tested on MariaDB 10.11 (MySQL-compatible) and use standard MySQL syntax. `CHECK` constraints need MySQL 8.0.16 or newer.
* MySQL has no `FULL JOIN` or `MERGE`; the project uses `LEFT JOIN ... UNION ... RIGHT JOIN` and `INSERT ... ON DUPLICATE KEY UPDATE` instead (documented in the scripts).
* The database user in `dcl_grant_revoke.sql` is created and dropped inside the script; its demo password is for practice only.
* Revenue counts Completed orders only: `quantity x unit_price x (1 - discount_pct/100)`.
