-- 1. Overall Table Size
SELECT 
    COUNT(order_number) AS [Total_Rows]
FROM dbo.Sales;

-- 2. Find First and the Last orders 
SELECT 
    MIN(order_date) AS [First_Order], 
    MAX(order_date) AS [Last_Order]
FROM dbo.Sales ; 


-- 3. Count unique  Orders  , customers , product , stores
SELECT DISTINCT
    COUNT(order_number) AS [Orders]
FROM dbo.Sales;

SELECT DISTINCT
    COUNT(customer_key) AS [Customers]
FROM dbo.Customers;

SELECT DISTINCT
    COUNT(product_key) AS [Products]
FROM dbo.Products;

SELECT DISTINCT
    COUNT(store_key) AS [Stores]
FROM dbo.Stores;

-- 4. Distribution of records by major dimensions  , Orders by country, products by category, etc.
SELECT 
    c.country , 
    COUNT( DISTINCT order_number) AS [Orders]
FROM dbo.Sales AS [s] 
LEFT JOIN dbo.Customers AS [c] 
ON s.customer_key = c.customer_key

GROUP BY c.country
ORDER BY COUNT(DISTINCT order_number) DESC; 


-- products by category
SELECT  
    category,
    COUNT(product_key) AS [Products]
FROM dbo.Products
GROUP BY category; 


SELECT TOP 5
    brand,
    COUNT(product_key) AS [Products]
FROM dbo.Products
GROUP BY brand
ORDER BY COUNT(product_key) DESC;


-- Average order size 
SELECT 
    ROUND(SUM(Quantity)/CAST(COUNT(order_number) AS FLOAT),0) AS [Average Order Size] 
FROM
(
SELECT 
    order_number, 
    SUM(quantity) AS [Quantity]
FROM dbo.Sales
GROUP BY order_number
) AS [T]



-- Customer order frequency 
SELECT 
    c.customer_key,
    COUNT(s.order_number) AS [Total_orders]
FROM dbo.Sales AS [s]
LEFT JOIN dbo.Customers AS [c]
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
ORDER BY COUNT(s.order_number) DESC;
