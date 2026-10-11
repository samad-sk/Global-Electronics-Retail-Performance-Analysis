-- Calculate the key metric of the business (Big Numbers)


-- Highest level of Aggregation  
-- Lowest level of Details 



-- 1. Find the Total Sales
SELECT 
    SUM(Amount) AS [Total_Sales]
FROM dbo.Sales; 

-- 2. Find how many items are sold
SELECT 
    SUM(quantity) AS [Total Sold Items]
FROM dbo.Sales;
-- 3. Find the average selling price
SELECT
    AVG(unit_price_usd) AS [Average_Price]
FROM dbo.Products

-- 4. Find the total number of Orders
SELECT 
    COUNT(DISTINCT order_number) AS [Total_Orders]
FROM dbo.Sales; 


-- 5. Find the total number of products
SELECT 
    COUNT(product_key) AS [Total_Products]
FROM dbo.Products; 

-- 6. Find the total number of customers 
SELECT 
    COUNT(customer_key) AS [Total_Customers]
FROM dbo.Customers; 

-- 7. Find the total number of customers that has placed an order. 
SELECT 
    COUNT(DISTINCT customer_key) AS [Total_customers]
FROM dbo.Sales;



-- Prepare a report 
SELECT 'Total_Sales' AS [Measure_Name], SUM(Amount)  AS [Measure_Value] FROM dbo.Sales
UNION ALL 
SELECT 'Total_Quantity' , SUM(Quantity) FROM dbo.Sales
UNION ALL
SELECT 'Average_Price' , AVG(unit_price_usd) FROM dbo.Products
UNION ALL 
SELECT 'Total No. Orders', COUNT(order_number) FROM dbo.Sales
UNION ALL 
SELECT 'Total No. Products',  COUNT(product_key) FROM dbo.Products
UNION ALL 
SELECT 'Total No. Customers', COUNT(DISTINCT customer_key) FROM dbo.Sales; 