/*===============================================================
  DATABASE EXPLORATION
===============================================================*/

-- List all available tables in the current database
SELECT * 
FROM INFORMATION_SCHEMA.TABLES;

-- List all columns for the 'dim_customers' table
SELECT * 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'dim_customers';


/*===============================================================
  DIMENSION EXPLORATION
===============================================================*/

-- Get all distinct countries from the customer dimension
SELECT DISTINCT country 
FROM gold.dim_customers;

-- Get all unique combinations of category, subcategory, and product name
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM gold.dim_products 
ORDER BY category, subcategory, product_name;

-- Retrieve the first and last order dates and calculate the total range in years
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years
FROM gold.fact_sales;

-- Find the oldest and youngest customer birthdates
SELECT
    MIN(birthdate) AS oldest_birthdate,
    MAX(birthdate) AS youngest_birthdate
FROM gold.dim_customers;


/*===============================================================
  SUMMARY METRICS (SEPARATE QUERIES)
===============================================================*/

-- Find the total sales
SELECT SUM(sales_amount) AS total_sales 
FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS total_items_sold 
FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS average_selling_price 
FROM gold.fact_sales;

-- Find the total number of orders
SELECT COUNT(DISTINCT order_number) AS total_orders 
FROM gold.fact_sales;

-- Find the total number of products
SELECT COUNT(DISTINCT product_key) AS total_products 
FROM gold.dim_products;

-- Find the total number of customers
SELECT COUNT(*) AS total_customers 
FROM gold.dim_customers;

-- Find the total number of customers that have placed an order
SELECT COUNT(DISTINCT customer_key) AS customers_with_orders 
FROM gold.fact_sales;


/*===============================================================
  SUMMARY REPORT (UNIFIED METRICS)
===============================================================*/

SELECT 'Total Sales' AS measure_name, CAST(SUM(sales_amount) AS VARCHAR) AS measure_value
FROM gold.fact_sales

UNION ALL

SELECT 'Total Items Sold', CAST(SUM(quantity) AS VARCHAR)
FROM gold.fact_sales

UNION ALL

SELECT 'Average Selling Price', CAST(AVG(price) AS VARCHAR)
FROM gold.fact_sales

UNION ALL

SELECT 'Total Orders', CAST(COUNT(DISTINCT order_number) AS VARCHAR)
FROM gold.fact_sales

UNION ALL

SELECT 'Total Products', CAST(COUNT(DISTINCT product_key) AS VARCHAR)
FROM gold.dim_products

UNION ALL

SELECT 'Total Customers', CAST(COUNT(*) AS VARCHAR)
FROM gold.dim_customers

UNION ALL

SELECT 'Customers with Orders', CAST(COUNT(DISTINCT customer_key) AS VARCHAR)
FROM gold.fact_sales;


/*===============================================================
  GROUPED ANALYSIS
===============================================================*/

-- Total customers by country
SELECT country, COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Total customers by gender
SELECT gender, COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Total products by category
SELECT category, COUNT(*) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Average product cost by category
SELECT category, AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;

-- Total revenue by category
SELECT 
    dp.category,
    SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
JOIN gold.dim_products dp
    ON fs.product_key = dp.product_key
GROUP BY dp.category
ORDER BY total_revenue DESC;

-- Total revenue by customer
SELECT 
    dc.customer_key,
    dc.first_name,
    dc.last_name,
    SUM(fs.sales_amount) AS total_revenue
FROM gold.fact_sales fs
JOIN gold.dim_customers dc
    ON fs.customer_key = dc.customer_key
GROUP BY dc.customer_key, dc.first_name, dc.last_name
ORDER BY total_revenue DESC;

-- Distribution of sold items across countries
SELECT 
    dc.country,
    SUM(fs.quantity) AS total_items_sold
FROM gold.fact_sales fs
JOIN gold.dim_customers dc
    ON fs.customer_key = dc.customer_key
GROUP BY dc.country
ORDER BY total_items_sold DESC;


/*===============================================================
  PRODUCT PERFORMANCE ANALYSIS
===============================================================*/

-- Top 5 products by total revenue
WITH ranked_products AS (
    SELECT
        dp.product_name,
        dp.category,
        SUM(fs.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(fs.sales_amount) DESC) AS rank_products
    FROM gold.fact_sales fs
    JOIN gold.dim_products dp
        ON fs.product_key = dp.product_key
    GROUP BY dp.product_name, dp.category
)
SELECT *
FROM ranked_products
WHERE rank_products <= 5;

-- Bottom 5 products by total revenue
WITH ranked_products AS (
    SELECT
        dp.product_name,
        dp.category,
        SUM(fs.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(fs.sales_amount) ASC) AS rank_products
    FROM gold.fact_sales fs
    JOIN gold.dim_products dp
        ON fs.product_key = dp.product_key
    GROUP BY dp.product_name, dp.category
)
SELECT *
FROM ranked_products
WHERE rank_products <= 5;
