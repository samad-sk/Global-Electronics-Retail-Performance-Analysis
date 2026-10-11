--====================================
-- Query 4 - Part to Whole Analysis
--====================================

-- Analyze how an individual part is performing compared to the overall
-- allowing us to understand which category has the greatest impact on the business. 

-- which category contribute the most to overall sales 
SELECT 
    T.*, 
    CONCAT(ROUND((CAST([Profit] AS FLOAT) / [Total_Profit])  * 100,2),'%') AS [Part-to-whole]
FROM
(
    SELECT 
        p.category,
        ROUND(SUM(s.Amount),2)/1000000 AS [Sales],
        (SUM(SUM(s.Amount)) OVER ())/1000000 AS [Total_Sales],
        (ROUND(SUM(s.Amount - (s.quantity * p.unit_cost_usd)),0))/1000000 AS [Profit], 
        SUM(SUM(s.Amount - (s.quantity * p.unit_cost_usd))) OVER () / 1000000 AS [Total_Profit]
    FROM dbo.Sales AS [s]
    LEFT JOIN dbo.Products AS [p]
    ON s.product_key = p.product_key 
    GROUP BY p.category
) AS [T]
ORDER BY [Sales] DESC;
