-- ============================================================
-- 01_views_and_business_reports.sql
-- Purpose : Reusable views + executive business reports
-- Rules   : Revenue counts COMPLETED orders only.
--           Line revenue = quantity * unit_price * (1 - discount_pct/100)
--           Line cost    = quantity * products.unit_cost
-- ============================================================
USE retail_sales_db;

-- ---------- VIEW 1: one row per sold item (feeds Power BI / Tableau later) ----------
CREATE OR REPLACE VIEW v_sales_detail AS
SELECT o.order_id,
       o.order_date,
       DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
       MONTH(o.order_date)                AS month_num,
       c.customer_id, c.customer_name, c.segment,
       r.region_name,
       e.full_name                        AS sales_rep,
       p.product_id, p.product_name,
       cat.category_name,
       oi.quantity, oi.unit_price, oi.discount_pct,
       ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100), 2) AS revenue,
       ROUND(oi.quantity * p.unit_cost, 2)                                  AS cost,
       ROUND(oi.quantity * oi.unit_price * (1 - oi.discount_pct / 100)
             - oi.quantity * p.unit_cost, 2)                                AS profit
FROM orders o
JOIN order_items oi ON oi.order_id    = o.order_id
JOIN products p     ON p.product_id   = oi.product_id
JOIN categories cat ON cat.category_id = p.category_id
JOIN customers c    ON c.customer_id  = o.customer_id
JOIN regions r      ON r.region_id    = c.region_id
JOIN employees e    ON e.employee_id  = o.employee_id
WHERE o.status = 'Completed';

-- ---------- VIEW 2: monthly totals ----------
CREATE OR REPLACE VIEW v_monthly_sales AS
SELECT order_month, month_num,
       COUNT(DISTINCT order_id) AS orders,
       SUM(quantity)            AS units_sold,
       ROUND(SUM(revenue), 2)   AS revenue,
       ROUND(SUM(profit), 2)    AS profit
FROM v_sales_detail
GROUP BY order_month, month_num;

-- ================= REPORT 1: Executive KPI summary =================
SELECT COUNT(DISTINCT order_id)                          AS total_orders,
       COUNT(DISTINCT customer_id)                       AS active_customers,
       SUM(quantity)                                     AS units_sold,
       ROUND(SUM(revenue), 2)                            AS total_revenue,
       ROUND(SUM(profit), 2)                             AS total_profit,
       ROUND(SUM(profit) / SUM(revenue) * 100, 1)        AS profit_margin_pct,
       ROUND(SUM(revenue) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM v_sales_detail;

-- ================= REPORT 2: Monthly sales with month-over-month growth =================
SELECT m.order_month, m.orders, m.units_sold, m.revenue, m.profit,
       ROUND((m.revenue - p.revenue) / p.revenue * 100, 1) AS revenue_growth_pct
FROM v_monthly_sales m
LEFT JOIN v_monthly_sales p ON p.month_num = m.month_num - 1
ORDER BY m.month_num;

-- ================= REPORT 3: Regional revenue and share =================
SELECT region_name,
       COUNT(DISTINCT order_id)                                   AS orders,
       ROUND(SUM(revenue), 2)                                     AS revenue,
       ROUND(SUM(profit), 2)                                      AS profit,
       ROUND(SUM(revenue) * 100 / (SELECT SUM(revenue) FROM v_sales_detail), 1) AS revenue_share_pct
FROM v_sales_detail
GROUP BY region_name
ORDER BY revenue DESC;

-- ================= REPORT 4: Top 10 customers by revenue =================
SELECT customer_name, segment, region_name,
       COUNT(DISTINCT order_id) AS orders,
       ROUND(SUM(revenue), 2)   AS total_spent
FROM v_sales_detail
GROUP BY customer_id, customer_name, segment, region_name
ORDER BY total_spent DESC
LIMIT 10;

-- ================= REPORT 5: Product performance (includes never-sold products) =================
SELECT p.product_name, cat.category_name,
       IFNULL(SUM(v.quantity), 0)                  AS units_sold,
       IFNULL(ROUND(SUM(v.revenue), 2), 0)         AS revenue,
       IFNULL(ROUND(SUM(v.profit), 2), 0)          AS profit,
       IFNULL(ROUND(SUM(v.profit) / SUM(v.revenue) * 100, 1), 0) AS margin_pct
FROM products p
JOIN categories cat       ON cat.category_id = p.category_id
LEFT JOIN v_sales_detail v ON v.product_id   = p.product_id
GROUP BY p.product_id, p.product_name, cat.category_name
ORDER BY profit DESC;

-- ================= REPORT 6: Category profitability =================
SELECT category_name,
       ROUND(SUM(revenue), 2) AS revenue,
       ROUND(SUM(profit), 2)  AS profit,
       ROUND(SUM(profit) / SUM(revenue) * 100, 1) AS margin_pct
FROM v_sales_detail
GROUP BY category_name
ORDER BY profit DESC;

-- ================= REPORT 7: Customer growth (new signups per month + running total) =================
SELECT g.signup_month, g.new_customers,
       (SELECT SUM(g2.new_customers) FROM
            (SELECT DATE_FORMAT(signup_date, '%Y-%m') AS signup_month, COUNT(*) AS new_customers
             FROM customers GROUP BY DATE_FORMAT(signup_date, '%Y-%m')) g2
        WHERE g2.signup_month <= g.signup_month) AS total_customers
FROM (SELECT DATE_FORMAT(signup_date, '%Y-%m') AS signup_month, COUNT(*) AS new_customers
      FROM customers GROUP BY DATE_FORMAT(signup_date, '%Y-%m')) g
ORDER BY g.signup_month;

-- ================= REPORT 8: Customer segment analysis =================
SELECT segment,
       COUNT(DISTINCT customer_id) AS customers_who_bought,
       COUNT(DISTINCT order_id)    AS orders,
       ROUND(SUM(revenue), 2)      AS revenue,
       ROUND(SUM(revenue) / COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM v_sales_detail
GROUP BY segment
ORDER BY revenue DESC;

-- ================= REPORT 9: Sales-rep performance with manager =================
SELECT v.sales_rep, IFNULL(m.full_name, '-') AS manager,
       COUNT(DISTINCT v.order_id) AS orders,
       ROUND(SUM(v.revenue), 2)   AS revenue
FROM v_sales_detail v
JOIN employees e       ON e.full_name   = v.sales_rep
LEFT JOIN employees m  ON m.employee_id = e.manager_id
GROUP BY v.sales_rep, m.full_name
ORDER BY revenue DESC;

-- ================= REPORT 10: Cancelled / returned orders (business risk) =================
SELECT status, COUNT(*) AS orders,
       ROUND(COUNT(*) * 100 / (SELECT COUNT(*) FROM orders), 1) AS pct_of_all_orders
FROM orders
WHERE status <> 'Completed'
GROUP BY status;
