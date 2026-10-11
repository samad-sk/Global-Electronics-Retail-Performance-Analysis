--====================================
-- Query 5 - Data Segmentation
--====================================

-- Group the data based on a specific range
-- Helps understand the correlation between two measures.


-- Group customers into three segments based on their spending behaviour 
-- VIP : Customers with atleast 12 months of history and spending more than $5,000.
-- Regular : Customers with atleast 12 months of history but spending $5,000 or less. 
-- New : Customers with a lifespan less than 12 months
-- and find the total number of customers by each group

WITH CTE_Order_Details AS (

    SELECT 
        s.order_date AS [Order_Date],
        c.customer_key,
        ROUND(SUM(s.Amount),2) AS [Amount]

    FROM dbo.Sales AS [s]

    LEFT JOIN dbo.Customers AS [c]
    ON s.customer_key = c.customer_key

    GROUP BY s.order_date , c.customer_key  
)
, CTE_Customer_LifeSpan AS (

SELECT 
    customer_key,
    MIN([Order_Date]) AS [First_Order],
    MAX([Order_Date]) AS [Last_Order],
    DATEDIFF(MONTH,MIN([Order_Date]),MAX([Order_Date])) AS [lifespan],
    SUM(Amount) AS [Amount]
FROM CTE_Order_Details 
GROUP BY customer_key
)
, CTE_Customer_Segmentation AS (
    SELECT
        cte_ls.customer_key, 
        ROUND(cte_ls.[Amount],2) AS [Total_Spending],
        cte_ls.[lifespan] AS [Lifespan],

        CASE
            WHEN cte_ls.[lifespan] > 12  AND cte_ls.[Amount] > 5000 THEN 'VIP'
            WHEN cte_ls.[lifespan] >= 12 AND cte_ls.[Amount] <= 5000 THEN 'Regular'
            ELSE 'New'
        END AS [Segment]
    FROM CTE_Customer_LifeSpan AS cte_ls
)
SELECT 
    cte_cs.[Segment], 
    COUNT(cte_cs.[Segment]) AS [Total_Customers]
FROM CTE_Customer_Segmentation AS [cte_cs]
GROUP BY cte_cs.[Segment];
