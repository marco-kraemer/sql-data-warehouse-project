/*
====================================================================
DDL Script: Create Gold Views for Data Warehouse Consumption
====================================================================

Script Purpose:
    This script creates the views for the 'gold' schema based on
    the cleaned and transformed data available in the 'silver' layer.
    These views represent the dimensional model following the
    star schema, suitable for analytics and BI tools.

    The views created include:
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales

    Each view includes relevant joins and transformations to enrich
    the dataset using CRM and ERP information. They apply filters
    (e.g., active products) and derive surrogate keys using
    ROW_NUMBER() to conform to dimensional modeling standards.

====================================================================
*/

IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers;
GO

-- View: gold.dim_customers
-- Purpose: Dimension table combining CRM customer data with ERP demographic and location enrichment
CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,  -- surrogate key
	ci.cst_id as customer_id,
	ci.cst_key as customer_number,
	ci.cst_firstname as first_name,
	ci.cst_lastname as last_name,
	la.cntry as country,  -- from ERP location
	ci.cst_maritial_status as marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(ca.gen, 'n/a')  -- fallback to ERP gender
	END AS gender,
	ca.bdate as birthdate,  -- from ERP customer info
	ci.cst_create_date as create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid
GO

IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products;
GO

-- View: gold.dim_products
-- Purpose: Dimension table with product details and ERP category enrichment
CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,  -- surrogate key
	pn.prd_id as product_id,
	pn.prd_key as product_number,
	pn.prd_nm as product_name,
	pn.cat_id as category_id,
	pc.cat category,  -- category name from ERP
	pc.subcat as subcategory,
	pc.maintenance,
	pn.prd_cost as cost,
	pn.prd_line as product_line,
	pn.prd_start_dt as start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- filter out all historical data
GO

IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales;
GO

-- View: gold.fact_sales
-- Purpose: Fact table containing sales transactions, linking customers and products
CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num as order_number,
	pr.product_key,  -- FK to dim_products
	cu.customer_key, -- FK to dim_customers
	sd.sls_cust_id as order_date,
	sd.sls_order_dt as shipping_date,
	sd.sls_ship_dt as due_date,
	sd.sls_due_dt as sales_amount,
	sd.sls_quantity as quantity,
	sd.sls_price price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id
GO
