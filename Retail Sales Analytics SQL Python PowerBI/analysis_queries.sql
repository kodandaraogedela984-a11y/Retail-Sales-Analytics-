-- Retail Sales Analytics Project (MySQL 8+)
CREATE DATABASE IF NOT EXISTS retail_analytics;
USE retail_analytics;

CREATE TABLE customers (
  customer_id VARCHAR(10) PRIMARY KEY,
  customer_name VARCHAR(80),
  city VARCHAR(40),
  segment VARCHAR(40)
);
CREATE TABLE products (
  product_id VARCHAR(10) PRIMARY KEY,
  product_name VARCHAR(80),
  category VARCHAR(40),
  base_price DECIMAL(12,2)
);
CREATE TABLE orders (
  order_id VARCHAR(10) PRIMARY KEY,
  order_date DATE,
  customer_id VARCHAR(10),
  order_status VARCHAR(20),
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
CREATE TABLE order_items (
  order_item_id VARCHAR(12) PRIMARY KEY,
  order_id VARCHAR(10),
  product_id VARCHAR(10),
  quantity INT,
  unit_price DECIMAL(12,2),
  discount_pct DECIMAL(5,2),
  FOREIGN KEY (order_id) REFERENCES orders(order_id),
  FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Import the four CSV files into their matching tables using MySQL Workbench Table Data Import Wizard.

-- 1. Overall KPIs: completed-order gross sales after discount
SELECT
  ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),2) AS net_sales,
  COUNT(DISTINCT o.order_id) AS completed_orders,
  SUM(oi.quantity) AS units_sold,
  ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct))
        / COUNT(DISTINCT o.order_id),2) AS average_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'Completed';

-- 2. Monthly sales trend
SELECT DATE_FORMAT(o.order_date,'%Y-%m') AS sales_month,
       ROUND(SUM(oi.quantity * oi.unit_price * (1 - oi.discount_pct)),2) AS net_sales
FROM orders o
JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='Completed'
GROUP BY DATE_FORMAT(o.order_date,'%Y-%m')
ORDER BY sales_month;

-- 3. Category and product performance
SELECT p.category, p.product_name,
       SUM(oi.quantity) AS units_sold,
       ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_pct)),2) AS net_sales
FROM orders o
JOIN order_items oi ON o.order_id=oi.order_id
JOIN products p ON oi.product_id=p.product_id
WHERE o.order_status='Completed'
GROUP BY p.category,p.product_name
ORDER BY net_sales DESC;

-- 4. City-wise sales
SELECT c.city,
       ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_pct)),2) AS net_sales
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='Completed'
GROUP BY c.city
ORDER BY net_sales DESC;

-- 5. Top 10 customers
SELECT c.customer_id,c.customer_name,
       ROUND(SUM(oi.quantity*oi.unit_price*(1-oi.discount_pct)),2) AS customer_sales
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
WHERE o.order_status='Completed'
GROUP BY c.customer_id,c.customer_name
ORDER BY customer_sales DESC
LIMIT 10;

-- 6. Return and cancellation rates
SELECT order_status, COUNT(*) AS order_count,
       ROUND(100.0*COUNT(*)/(SELECT COUNT(*) FROM orders),2) AS pct_of_all_orders
FROM orders
GROUP BY order_status;