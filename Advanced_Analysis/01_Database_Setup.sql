create database [electronic_retail_analysis]
use [electronic_retail_analysis]

select * from Customers
select * from Exchange_Rates
select * from Products
select * from Stores
select * from Sales



-- Adding foreign keys in fact table 
alter table Sales
add constraint FK_Sales_Products 
foreign key (product_key)
references Products(product_key);

-- adding foreign keys
alter table Sales
add constraint FK_Sales_Customers 
foreign key (customer_key)
references Customers(customer_key);

-- Adding foreign keys
alter table Sales 
add constraint FK_Sales_ExchangeRates
foreign key (order_date , currency_code)
references Exchange_Rates(date , currency_code);

-- Adding foreign keys
alter table Sales
add constraint FK_Sales_Stores
foreign key (store_key)
references Stores(store_key);


select * from vw_Sales_Product_Customer_Store
order by order_number desc;


ALTER TABLE dbo.Sales
ADD Amount DECIMAL(18,2)

select top 5 * from dbo.Sales

UPDATE s SET
    s.Amount = s.quantity * p.unit_price_usd
FROM dbo.Sales AS [s]
LEFT JOIN dbo.Products AS [p]
ON s.product_key = p.product_key

