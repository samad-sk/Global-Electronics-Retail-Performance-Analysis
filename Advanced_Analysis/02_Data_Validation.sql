

-- Checking for duplicate primary key records in Sales Table. 
SELECT 
    order_number,
    line_item,
    COUNT(order_number) AS [Count]
FROM dbo.Sales
GROUP BY
    order_number, 
    line_item
HAVING COUNT(order_number)> 1



-- Checking anomalies 
SELECT 
    s.order_number,
    p.product_key

FROM Sales AS [s]

LEFT JOIN Products AS [p]
ON s.product_key = p.product_key

WHERE quantity <= 0 
    OR s.delivery_date < s.order_date
    OR p.unit_cost_usd <= 0 
    OR p.unit_price_usd <=0;


-- Comparing Date Formats
SELECT 
    s.order_date,
    s.delivery_date, 
    c.customer_dob , 
    st.open_date
FROM dbo.Sales AS [s] 

LEFT JOIN dbo.Customers AS [c] 
ON s.customer_key = c.customer_key 

LEFT JOIN dbo.Stores AS [st] 
ON s.store_key = st.store_key



-- Foreign key integrity 
SELECT 
    s.order_number, 
    s.line_item, 
    c.customer_key, 
    p.product_key , 
    st.store_key

FROM dbo.Sales AS [s]
LEFT JOIN Customers AS [c] 
ON s.customer_key = c.customer_key 

LEFT JOIN Products AS [p] 
ON s.product_key = p.product_key 

LEFT JOIN Stores AS [st] 
ON s.store_key = st.store_key

WHERE s.product_key IS NULL 
OR    c.customer_key IS NULL 
OR   st.store_key IS NULL
