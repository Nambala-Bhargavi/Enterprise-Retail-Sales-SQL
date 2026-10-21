-- ============================================================
-- 01_select_filter_sort.sql  (DQL: SELECT, WHERE, ORDER BY, DISTINCT)
-- Covers: filtering, sorting, operators, logical operators,
--         pattern matching, NULL handling, aliases, expressions
-- ============================================================
USE retail_sales_db;

-- Q1. Select specific columns (avoid SELECT * in production)
SELECT product_id, product_name, unit_price
FROM products;

-- Q2. WHERE + comparison operator: products priced above 5,000
SELECT product_name, unit_price
FROM products
WHERE unit_price > 5000;

-- Q3. Logical operators AND / OR / NOT
SELECT product_name, category_id, unit_price
FROM products
WHERE (category_id = 1 OR category_id = 2) AND unit_price < 10000;

-- Q4. IN and BETWEEN
SELECT customer_name, segment
FROM customers
WHERE segment IN ('Corporate', 'Wholesale');

SELECT order_id, order_date
FROM orders
WHERE order_date BETWEEN '2025-03-01' AND '2025-03-31';

-- Q5. Pattern matching with LIKE (names starting with 'A')
SELECT customer_name
FROM customers
WHERE customer_name LIKE 'A%';

-- Q6. NULL handling: customers with no email, then show a default
SELECT customer_id, customer_name
FROM customers
WHERE email IS NULL;

SELECT customer_name, IFNULL(email, 'no-email-on-file') AS email_display
FROM customers
LIMIT 12;

-- Q7. ORDER BY (single and multi-level) + LIMIT
SELECT product_name, unit_price
FROM products
ORDER BY unit_price DESC
LIMIT 5;

SELECT customer_name, segment, signup_date
FROM customers
ORDER BY segment ASC, signup_date DESC
LIMIT 10;

-- Q8. DISTINCT
SELECT DISTINCT segment FROM customers;

-- Q9. Aliases + expressions (profit margin per product)
SELECT product_name,
       unit_price                                        AS selling_price,
       unit_cost                                         AS cost_price,
       (unit_price - unit_cost)                          AS profit_per_unit,
       ROUND((unit_price - unit_cost) / unit_price * 100, 1) AS margin_pct
FROM products
ORDER BY margin_pct DESC;

-- Q10. CASE expression: classify products by price band
SELECT product_name, unit_price,
       CASE WHEN unit_price >= 20000 THEN 'Premium'
            WHEN unit_price >= 5000  THEN 'Mid-range'
            ELSE 'Budget' END AS price_band
FROM products
ORDER BY unit_price DESC;
