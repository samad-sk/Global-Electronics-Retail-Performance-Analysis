--=====================================
-- Query 1 : Change over Time Analysis
--=====================================
-- Purpose : To analyze how a measure evolves over time
-- Help track trends and identify seasonality in your data

-- Calculate Total Customers , Quantity sold and Total Sales

SELECT 
    DATETRUNC(YEAR,s.order_date) AS [Year],
    COUNT(DISTINCT s.customer_key) AS [Customers],
    SUM(s.quantity) AS [Quantity],
    SUM(s.Amount)/1000000 AS [Total_Sales]
FROM dbo.Sales AS [s]

GROUP BY DATETRUNC(YEAR,s.order_date)
ORDER BY DATETRUNC(YEAR,s.order_date)
;
