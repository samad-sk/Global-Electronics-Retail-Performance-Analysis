/*
==========================================================
Customer Report
==========================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights: 
    1. Gather essential fields such as names, ages, and transaction details. 
    2. Segments customers into categories (VIP, Regular, New) and age groups. 
    3. Aggregates customer-level metrics: 
        - total orders
        - total sales 
        - total quantity purchased 
        - total products
        - lifespan (in months)
    4. Calculate valuable KPIs: 
        - recency (months since last order) 
        - average order value
        - average monthly spend
===============================================
*/


/*---------------------------------------------
1) Base Query : Retrive core columns from tables.
----------------------------------------------*/


CREATE VIEW VW_Report_Customer AS 

    WITH CTE_Base_Query AS (
        SELECT 
            s.order_number,
            s.line_item, 
            s.order_date, 
            s.quantity, 
            s.Amount,
            c.customer_key,
            c.name,
            p.product_key,
            DATEDIFF(YEAR,c.customer_dob,GETDATE()) AS [Customer_Age]
        FROM dbo.Sales AS [s]

        LEFT JOIN dbo.Customers AS [c]
        ON s.customer_key = c.customer_key

        LEFT JOIN dbo.Products AS [p] 
        ON s.product_key = p.product_key  
    )

    /*=========================================================
    2) Calculated Customer level metrics 
    *=========================================================*/
    , CTE_Customer_Aggregations AS (
        SELECT 
            [customer_key] ,
            [name],
            [Customer_Age],
            COUNT(DISTINCT order_number) AS [Total_Orders],
            SUM([Amount]) AS [Amount],
            SUM([quantity]) AS [Quantity], 
            COUNT(DISTINCT product_key)  AS [Products], 
            MAX(order_date) AS [Last_order_date], 
            DATEDIFF(MONTH,MIN([Order_Date]),MAX([Order_Date])) AS [lifespan]
        FROM CTE_Base_Query
        GROUP BY 
            [customer_key] ,
            [name],
            [Customer_Age]
    )
    /*=========================================================
    3) Calculating other metrics
    =========================================================*/
    SELECT
        [customer_key] ,
        [name],
        [Customer_Age],
        CASE 
            WHEN [Customer_Age] <20 THEN 'Under 20'
            WHEN [Customer_Age] BETWEEN 20 AND 29 THEN '20 - 29'
            WHEN [Customer_Age] BETWEEN 30 AND 39 THEN '30 - 39'
            WHEN [Customer_Age] BETWEEN 40 AND 49 THEN '40 - 49'
            ELSE '50 and Above'
        END AS [Age Group],
        CASE
            WHEN [lifespan] > 12  AND [Amount] > 5000 THEN 'VIP'
            WHEN [lifespan] >= 12 AND [Amount] <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS [Segment], 
        [Last_order_date],
        DATEDIFF(MONTH,[Last_order_date],GETDATE()) AS [Recency],
        [Total_Orders],
        [Amount],
        [Quantity],
        [lifespan],
        CASE 
            WHEN [Total_Orders] = 0 THEN 0 
            ELSE [Amount]/[Total_Orders]
        END AS [Avg_Order_Value],
        CASE 
            WHEN [lifespan] = 0 THEN [Amount]
            ELSE [Amount]/[lifespan] 
        END AS [Avg_Month_Spending] 
    FROM CTE_Customer_Aggregations

        select  * FROM VW_Report_Customer

            
-- SELECT 
--     [Age Group], 
--     COUNT([Total_Orders]) AS [Total_Orders],
--     SUM([Amount]) AS [Total Sales]

-- FROM VW_Report_Customer
-- GROUP BY [Age Group]