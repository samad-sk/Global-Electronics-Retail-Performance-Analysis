--=================================
-- Query 3 - Performance Analysis
--=================================

-- Analyze the 
-- 1.   Yearly performance of products 
-- 2.   By comparing each product's sales to both 
-- 2.1. its average sales performance 
-- 2.2. and the previous year's sales


-- Prepares all the year_product combination
WITH CTE_Product_Year_Combination AS (
    SELECT s.[Year] AS [Year],
    t.product_key AS [Product_Key],
    t.product_name AS [Product_Name]
    FROM (SELECT DISTINCT YEAR(order_date) AS [Year] FROM dbo.Sales) AS [s]
    CROSS JOIN (SELECT DISTINCT product_key, product_name FROM dbo.Products) AS [t]
), 
CTE_Yearly_Product_Sales AS (

    -- Calculating Yearly Sales for Each Product BY JOINING Sales & Products table.
    SELECT
        cte_pyc.[Year] AS [Sales_Year],
        cte_pyc.Product_Key AS [Product_Key],
        cte_pyc.Product_Name AS [Product_Name],
        COALESCE(SUM(s.Amount),0) AS [Yearly_Sales]
    FROM CTE_Product_Year_Combination AS [cte_pyc]

    LEFT JOIN dbo.Sales AS [s]
    ON cte_pyc.[Year] = YEAR(s.order_date) AND cte_pyc.Product_Key = s.product_key

    GROUP BY  cte_pyc.[Year],cte_pyc.Product_Key, cte_pyc.Product_Name
)
, CTE_YOY_Comparison AS (
SELECT
    [Sales_Year],
    [Product_Key],
    [Product_Name],
    [Yearly_Sales],

 -- Calculating Average Yearly Sales for each Products
    AVG([Yearly_Sales]) OVER (PARTITION BY [Product_Key]) AS [Average_Annual_Sales], 

    -- Calculating the difference between Actual Yearly Sales from Average yearly sales 
    [Yearly_Sales] - AVG([Yearly_Sales]) OVER (PARTITION BY [Product_Key]) AS [Difference_From_Average],
    CASE
        WHEN  [Yearly_Sales] - AVG([Yearly_Sales]) OVER (PARTITION BY [Product_Key]) < 0 THEN 'Below Avg'
        WHEN [Yearly_Sales] - AVG([Yearly_Sales]) OVER (PARTITION BY [Product_Key]) > 0 THEN 'Above Avg'
        ELSE 'Avg'
        END AS [Vs_Average],

     -- Gets the Previous year sales 
    LAG(Yearly_Sales) OVER (PARTITION BY [Product_Key] ORDER BY [Sales_Year] ) AS [Previous_Year_Sales],

    -- Subtract Current - Previous Year Sales to get the YOY Effect.
    [Yearly_Sales]- LAG(Yearly_Sales) OVER (PARTITION BY [Product_Key] ORDER BY [Sales_Year])  AS [YoY_Sales_Change],
   ( CAST([Yearly_Sales]- LAG(Yearly_Sales) OVER (PARTITION BY [Product_Key] ORDER BY [Sales_Year]) AS FLOAT)/ 
    NULLIF(LAG(Yearly_Sales) OVER (PARTITION BY [Product_Key] ORDER BY [Sales_Year]),0) )*100 AS [YoY_Sales_Change_Percentage]
    ,
    CASE 
        WHEN [Yearly_Sales]- LAG(Yearly_Sales) OVER (PARTITION BY [Product_Key] ORDER BY [Sales_Year] ) > 0 THEN 'Increase'
        WHEN [Yearly_Sales]- LAG(Yearly_Sales) OVER (PARTITION BY [Product_Key] ORDER BY [Sales_Year] ) <0 THEN 'Decrease'
        ELSE 'No Change'
    END AS [YoY_Sales_Trend]

FROM CTE_Yearly_Product_Sales
)
SELECT 
    * 
FROM CTE_YOY_Comparison 
WHERE [YoY_Sales_Change_Percentage] > 90;

