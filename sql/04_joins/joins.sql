-- ============================================================
-- joins.sql
-- Covers: INNER, LEFT, RIGHT, FULL (emulated), SELF, CROSS JOIN
-- ============================================================
USE retail_sales_db;

-- J1. INNER JOIN : only rows that match in BOTH tables
-- Each order with its customer name and region
SELECT o.order_id, o.order_date, c.customer_name, r.region_name
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
INNER JOIN regions   r ON r.region_id   = c.region_id
ORDER BY o.order_date
LIMIT 10;

-- J2. LEFT JOIN : all rows from the LEFT table, even with no match
-- All customers and their order count (customers with 0 orders still appear)
SELECT c.customer_id, c.customer_name, COUNT(o.order_id) AS orders_placed
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY orders_placed ASC, c.customer_id
LIMIT 10;

-- J2b. LEFT JOIN + IS NULL : find customers who NEVER ordered
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;

-- J3. RIGHT JOIN : all rows from the RIGHT table, even with no match
-- All products with units sold (never-sold products show NULL -> 0)
SELECT p.product_id, p.product_name, IFNULL(SUM(oi.quantity), 0) AS units_sold
FROM order_items oi
RIGHT JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY units_sold ASC
LIMIT 5;

-- J4. FULL (OUTER) JOIN : all rows from both tables.
-- MySQL has no FULL JOIN keyword, so combine LEFT JOIN + RIGHT JOIN with UNION.
SELECT c.category_name, p.product_name
FROM categories c
LEFT JOIN products p ON p.category_id = c.category_id
UNION
SELECT c.category_name, p.product_name
FROM categories c
RIGHT JOIN products p ON p.category_id = c.category_id
ORDER BY category_name, product_name
LIMIT 10;

-- J5. SELF JOIN : a table joined to itself (employee -> manager)
SELECT e.full_name AS employee, e.job_title, m.full_name AS manager
FROM employees e
LEFT JOIN employees m ON m.employee_id = e.manager_id
ORDER BY m.full_name, e.full_name;

-- J6. CROSS JOIN : every combination (regions x categories = reporting skeleton)
SELECT r.region_name, c.category_name
FROM regions r
CROSS JOIN categories c
ORDER BY r.region_name, c.category_name
LIMIT 10;

-- J7. Multi-table join: order lines with product and category
SELECT o.order_id, o.order_date, p.product_name, cat.category_name,
       oi.quantity, oi.unit_price
FROM orders o
JOIN order_items oi ON oi.order_id   = o.order_id
JOIN products p     ON p.product_id  = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
WHERE o.order_date >= '2025-12-01'
ORDER BY o.order_date, o.order_id
LIMIT 10;
