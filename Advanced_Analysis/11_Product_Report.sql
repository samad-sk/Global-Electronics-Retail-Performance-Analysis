/*
===============================
Product Report
================================
Purpose: 

Purpose: Consolidates product-level sales performance and purchasing behavior to support product analysis and reporting.

Key Metrics: Total sales, quantity sold, orders, unique customers, product lifespan, recency, average order revenue, average monthly revenue, and product performance segments.
    - This report consolidates key product metrics and behaviors. 

Highlights: 
    1. Gathers essential fields such as product name, category, subcategory, and cost. 
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers. 
    3. Aggregates product-level metrics: 
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
    4. Calculate Valuable KPIs: 
        - recency (months since last sale)
        - average order revenue (AOR)
        - average monthly revenue       
==========================================================
*/

WITH CTE_Product_Details AS (
SELECT
    p.product_key,
    p.product_name, 
    p.category, 
    p.subcategory, 
    p.unit_cost_usd,
    s.Amount,
    s.quantity,
    s.order_number,
    s.order_date,
    c.customer_key
FROM dbo.Sales AS [s]

LEFT JOIN dbo.Products AS [p]
ON s.product_key = p.product_key

LEFT JOIN dbo.Customers AS [c]
ON s.customer_key = c.customer_key
)

/*========================================
 Step 2 : Customer Level Aggregations
============================================*/
, CTE_Product_Aggregations AS (

SELECT 
    [product_key],
    [product_name], 
    [category], 
    [subcategory], 
    COUNT(DISTINCT [order_number]) AS [Total_Orders],
    SUM([Amount]) AS [Total_Sales],
    SUM([quantity]) AS [Total_Quantity],
    COUNT(DISTINCT [customer_key]) AS [Total_Customers],
    MAX(order_date) AS [Last_Order_Date],
    DATEDIFF(MONTH, MIN(order_date) , MAX(order_date)) AS [lifespan]
FROM CTE_Product_Details
GROUP BY   
    [product_key],
    [product_name], 
    [category], 
    [subcategory]
)

/*==================================================
  3. Calculating KPIs. 
==================================================*/
SELECT  
    [product_key],
    [product_name], 
    [category], 
    [subcategory], 
    [Total_Orders],
    [Total_Sales],
    [Total_Quantity],
    [Total_Customers],
    [lifespan],
    [Last_Order_Date], 
    DATEDIFF(MONTH,[Last_Order_Date],GETDATE()) AS [Recency],
    CASE 
        WHEN [Total_Sales] > 50000 THEN 'High-Performer'
        WHEN [Total_Sales] >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS [Product_Segment],
    CASE
        WHEN [Total_Orders] = 0 THEN 0
        ELSE [Total_Sales]/[Total_Orders]
    END AS [Average Order Revenue],

    CASE WHEN [lifespan] = 0 THEN [Total_Sales]
        ELSE [Total_Sales]/[lifespan]
    END AS [Average Monthly Revenue]
FROM CTE_Product_Aggregations;
