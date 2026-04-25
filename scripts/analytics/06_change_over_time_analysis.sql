/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT(), AVG()
===============================================================================
*/

-- Change-Over-Time "Trends" Analysis:
/*
    Change Over Time "Trend"
    By Year:
*/
SELECT YEAR([order_date]) as order_year
      ,SUM([sales_amount]) as total_sales
      ,COUNT(DISTINCT(customer_key)) as total_customers
      ,SUM(quantity) as total_quantity
  FROM [DataWarehouse].[gold].[fact_sales]
  WHERE order_date IS NOT NULL
  GROUP BY YEAR([order_date])
  ORDER BY YEAR([order_date])

/*
    Change Over Time "Trend"
    By Month:
*/
SELECT MONTH([order_date]) as order_month
      ,SUM([sales_amount]) as total_sales
      ,COUNT(DISTINCT(customer_key)) as total_customers
      ,SUM(quantity) as total_quantity
  FROM [DataWarehouse].[gold].[fact_sales]
  WHERE order_date IS NOT NULL
  GROUP BY MONTH([order_date])
  ORDER BY MONTH([order_date])

/*
    Change Over Time "Trend"
    By Year & Month:
*/
SELECT DATETRUNC(MONTH, [order_date]) as order_date
      ,SUM([sales_amount]) as total_sales
      ,COUNT(DISTINCT(customer_key)) as total_customers
      ,SUM(quantity) as total_quantity
  FROM [DataWarehouse].[gold].[fact_sales]
  WHERE order_date IS NOT NULL
  GROUP BY DATETRUNC(MONTH, [order_date])
  ORDER BY DATETRUNC(MONTH, [order_date])

-- FORMAT()
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
