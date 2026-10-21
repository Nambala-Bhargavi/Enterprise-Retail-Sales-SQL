# Project Notes
* Database: retail_sales_db (MySQL / MariaDB), 7 tables, 3NF.
* Build order: DDL -> INSERT -> UPDATE/DELETE demos -> views and reports.
* Verification done: revenue is identical when calculated from base tables, from the view, by region and by month (₹17,221,266.30); no orphan foreign keys; no orders dated before the customer signed up.
* DML and TCL demo scripts undo their own changes, so report numbers stay constant when scripts are re-run.
* Next tasks: Task 4 (advanced SQL, stored procedures, views); `v_sales_detail` will feed Power BI / Tableau in Task 5.
