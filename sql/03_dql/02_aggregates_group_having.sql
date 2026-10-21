-- ============================================================
-- 02_aggregates_group_having.sql
-- Covers: COUNT, SUM, AVG, MAX, MIN, GROUP BY, HAVING
-- ============================================================
USE retail_sales_db;

-- Q1. COUNT / MIN / MAX / AVG over a whole table
SELECT COUNT(*)        AS total_products,
       MIN(unit_price) AS cheapest,
       MAX(unit_price) AS costliest,
       ROUND(AVG(unit_price), 2) AS average_price
FROM products;

-- Q2. COUNT(*) vs COUNT(column): COUNT(column) ignores NULLs
SELECT COUNT(*) AS all_customers,
       COUNT(email) AS customers_with_email,
       COUNT(*) - COUNT(email) AS customers_without_email
FROM customers;

-- Q3. GROUP BY: customers per segment
SELECT segment, COUNT(*) AS customer_count
FROM customers
GROUP BY segment
ORDER BY customer_count DESC;

-- Q4. SUM + GROUP BY: units sold per product (top 5)
SELECT product_id, SUM(quantity) AS units_sold
FROM order_items
GROUP BY product_id
ORDER BY units_sold DESC
LIMIT 5;

-- Q5. Revenue per order line = quantity * unit_price * (1 - discount%)
SELECT ROUND(SUM(quantity * unit_price * (1 - discount_pct / 100)), 2) AS total_line_revenue
FROM order_items;

-- Q6. HAVING filters AFTER grouping (WHERE filters BEFORE grouping)
-- Products that sold more than 150 units
SELECT product_id, SUM(quantity) AS units_sold
FROM order_items
GROUP BY product_id
HAVING SUM(quantity) > 150
ORDER BY units_sold DESC;

-- Q7. WHERE + GROUP BY + HAVING together:
-- Months (completed orders only) with more than 30 orders
SELECT DATE_FORMAT(order_date, '%Y-%m') AS order_month,
       COUNT(*) AS orders_count
FROM orders
WHERE status = 'Completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
HAVING COUNT(*) > 30
ORDER BY order_month;

-- Q8. Order status distribution
SELECT status, COUNT(*) AS orders_count,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM orders), 1) AS pct_of_orders
FROM orders
GROUP BY status;
