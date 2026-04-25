/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

/*

    Calculate the total sales per month
    and the running total of sales over time:
*/
SELECT order_date
      ,total_sales
      ,SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
FROM
(
SELECT DATETRUNC(month, order_date) as order_date
      ,SUM(sales_amount) as total_sales
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATETRUNC(month, order_date)
) t

/*
    Cumulative Analysis
    Calculate the total sales per year
    , the running total of sales over time
    , the moving average sales over time
    ,and the moving average price over time:
*/
SELECT order_date
      ,total_sales
      ,SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales
      ,AVG(avg_sales) OVER (ORDER BY order_date) AS moving_average_sales
      ,AVG(avg_price) OVER (ORDER BY order_date) AS moving_average_price
FROM
(
SELECT DATETRUNC(year, order_date) as order_date
      ,SUM(sales_amount) as total_sales
      ,SUM(sales_amount) as avg_sales
      ,AVG(price) as avg_price
  FROM gold.fact_sales
  WHERE order_date IS NOT NULL
  GROUP BY DATETRUNC(year, order_date)
) t 
