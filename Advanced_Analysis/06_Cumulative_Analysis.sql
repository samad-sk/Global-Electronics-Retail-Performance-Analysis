--==============================
-- Query 2 : Cumulative Analysis
--==============================
-- Purpose : Aggregate the data progressively over time
-- Helps to understand whether our business is growing or declining

-- Calculate the total sales per month and the running total of sales over time.
SELECT 
    [Year-Month],
    [Sales],
    ROUND(SUM([Sales]) OVER (ORDER BY [Year-Month] ASC),2) AS [Running-Total],
    (ROUND(SUM([Sales]) OVER (ORDER BY [Year-Month] ASC),2) - [Sales])/1000000 AS [Difference]
    
FROM 
(
    SELECT 
        DATETRUNC(YEAR,s.order_date) AS [Year-Month],
        SUM(s.Amount) AS [Sales]
    FROM dbo.Sales AS [s]
    GROUP BY  DATETRUNC(YEAR,s.order_date)
) AS [T]
