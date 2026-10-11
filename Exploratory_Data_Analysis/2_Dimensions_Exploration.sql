-- 1. Identify unique values for each dimension (categorical columns)
-- Recognizing how data might be grouped or segmented, which is useful for later analysis

-- 1. Explore all countries our customers come from. 
SELECT 
    DISTINCT country
FROM dbo.Customers AS [d];


-- 2. Explore all Product categories (Major Divisions)
-- Categories 8
-- Subcategories - 32 
-- Products - 2517

-- IN each category which subcategory products are there 
SELECT DISTINCT
     category, 
    subcategory
FROM dbo.Products;


-- For every category showing count of all available subcategory , color  , total products.
SELECT 
    category,
    COUNT(DISTINCT subcategory) AS [Subcategory_COUNT],
    COUNT(DISTINCT color) AS [Total_Color_Available],
    COUNT(DISTINCT product_name) AS [Product_COUNT]
FROM dbo.Products
GROUP BY category
ORDER BY  COUNT(DISTINCT subcategory) DESC ;


SELECT 
    category,
    color,
    COUNT(DISTINCT subcategory) AS [Subcategory_COUNT],
    COUNT(DISTINCT product_name) AS [Total_Products]
   
FROM dbo.Products
GROUP BY category, color
ORDER BY category , color



