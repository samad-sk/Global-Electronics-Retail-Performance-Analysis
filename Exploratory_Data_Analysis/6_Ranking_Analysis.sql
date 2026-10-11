-- Ranking Analysis

-- Order the values of dimensions by measure.
-- To find Top N performers | Bottom N performers


-- 1. Which 5 products generate the highest revenue ? 


SELECT TOP 5
    p.subcategory, 
    SUM(s.Amount) AS [Total_Revenue]
FROM dbo.Sales AS [s] 
LEFT JOIN dbo.Products AS [p]
ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY [Total_Revenue] DESC;


-- 1. Which 5 products generate the lowwest revenue ? 


SELECT TOP 5
    p.subcategory, 
    SUM(s.Amount) AS [Total_Revenue]
FROM dbo.Sales AS [s] 
LEFT JOIN dbo.Products AS [p]
ON s.product_key = p.product_key
GROUP BY p.subcategory
ORDER BY [Total_Revenue] ASC;


-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_key, 
    c.name, 
    SUM(s.Amount) AS [Total_Revenue]
FROM dbo.Sales AS [s] 
LEFT JOIN dbo.Customers AS [c]
ON s.customer_key = c.customer_key
GROUP BY c.customer_key,c.name
ORDER BY [Total_Revenue] DESC;



-- The 3 customers with the fewest orders placed 
-- Find the top 10 customers who have generated the highest revenue
SELECT TOP 10
    c.customer_key, 
    c.name, 
    COUNT(s.order_number) AS [Total_Orders]
FROM dbo.Sales AS [s] 
LEFT JOIN dbo.Customers AS [c]
ON s.customer_key = c.customer_key
GROUP BY c.customer_key,c.name
ORDER BY [Total_Orders] ASC;
