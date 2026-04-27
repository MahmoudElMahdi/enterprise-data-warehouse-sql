/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows.
    - AVG() OVER(): Computes average values within partitions.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

/* Analyze the yearly performance of products by comparing their sales 
to both the average sales performance of the product and the previous year's sales */

-- Year-over-year Analysis
WITH yearly_product_sales AS (
SELECT YEAR(f.order_date) AS order_year
      ,p.product_name
      ,SUM(f.sales_amount) AS current_sales
  FROM gold.fact_sales f
  LEFT JOIN gold.dim_products p
  ON f.product_key = p.product_key
  WHERE order_date IS NOT NULL
  GROUP BY YEAR(f.order_date), p.product_name
)
SELECT order_year
      ,product_name
      ,current_sales
      ,AVG(current_sales) OVER (PARTITION BY product_name) AS average_sales
      ,(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) AS diff_avg
      ,CASE WHEN (current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) < 0 THEN 'Below Avg'
            WHEN (current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) = 0 THEN 'Avg'
            ELSE 'Above Avg'
       END avg_change
      ,LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS previous_year_sales
      ,(current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)) AS diff_previous_year
      ,CASE WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)) < 0 THEN 'Decrease'
            WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)) > 0 THEN 'Increase'
            ELSE 'No Change'
       END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year

-- Month-over-Month Analysis
WITH monthly_product_sales AS (
SELECT YEAR(f.order_date) AS order_year
      ,MONTH(f.order_date) AS order_month
      ,p.product_name
      ,SUM(f.sales_amount) AS current_sales
  FROM gold.fact_sales f
  LEFT JOIN gold.dim_products p
  ON f.product_key = p.product_key
  WHERE order_date IS NOT NULL
  GROUP BY YEAR(f.order_date), MONTH(f.order_date), p.product_name
)
SELECT order_year
      ,order_month
      ,product_name
      ,current_sales
      ,AVG(current_sales) OVER (PARTITION BY product_name) AS average_sales
      ,(current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) AS diff_avg
      ,CASE WHEN (current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) < 0 THEN 'Below Avg'
            WHEN (current_sales - AVG(current_sales) OVER (PARTITION BY product_name)) = 0 THEN 'Avg'
            ELSE 'Above Avg'
       END avg_change
      ,LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month) AS previous_month_sales
      ,(current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month)) AS diff_previous_month
      ,CASE WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month)) < 0 THEN 'Decrease'
            WHEN (current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_month)) > 0 THEN 'Increase'
            ELSE 'No Change'
       END py_change
FROM monthly_product_sales
ORDER BY product_name, order_month
