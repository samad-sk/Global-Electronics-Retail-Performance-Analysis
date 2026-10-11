-- Identify the earliest and latest dates (boundaries)
-- Understand the scop of data and the timespan


-- Find the date of the first and the last order 
-- How many years of sales are available

SELECT 
    MIN(order_date) AS [First_Order], 
    MAX(order_date) AS [Last_Order],
    DATEDIFF(YEAR, MIN(order_date) , MAX(order_date)) AS [Year-lifespan],
    DATEDIFF(MONTH, MIN(order_date) , MAX(order_date)) AS [Month-lifespan],
    DATEDIFF(DAY, MIN(order_date) , MAX(order_date)) AS [Days-lifespan]
FROM dbo.Sales;


--- Find the youngest and oldest customer 
SELECT 
    MIN(customer_dob) AS [Oldest_dob],
    DATEDIFF(YEAR,MIN(customer_dob) , GETDATE()) AS [Oldest_customer], 
    MAX(customer_dob) AS [Highest_dob],
    DATEDIFF(YEAR, MAX(customer_dob) , GETDATE()) AS [Youngest_customer]
FROM dbo.Customers ;


-- Find the top performing stores. 
SELECT  
    *
FROM dbo.Stores as s;

SELECT 
    [country],
    [store_key], 
    [Total_Sales],
    [Total_Quantity]
FROM 
 (
    SELECT 
        st.country, 
        st.store_key,
        SUM(s.Amount) AS [Total_Sales], 
        SUM(s.quantity) AS [Total_Quantity], 
        ROW_NUMBER() OVER(PARTITION BY st.country ORDER BY SUM(s.Amount) DESC)  AS  [Rank]
    FROM dbo.Sales AS [s]
    LEFT JOIN dbo.Stores AS [st] 
    ON s.store_key = st.store_key
    GROUP BY st.country , st.store_key
) AS [T]
WHERE [Rank] = 1 