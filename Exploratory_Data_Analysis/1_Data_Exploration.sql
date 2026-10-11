-- Explore all the objects in the database.
SELECT 
    * 
FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns in the database.
SELECT 
    COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Exchange_Rates';

-- Check columns of a specific table. 
SELECT 
    * 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Sales';