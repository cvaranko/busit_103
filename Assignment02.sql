--*  BusIT 103           Assignment   #2              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment02.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */



USE AdventureWorksLT2022



--1.  List the last name, first name and email address of each customer in alphabetical order by company. (7 points)
--    407 rows
SELECT CompanyName, LastName, FirstName, EmailAddress
FROM SalesLT.Customer
GROUP BY CompanyName, LastName, FirstName, EmailAddress
ORDER BY CompanyName ASC;



--2.  List all products by product name.  Include all data about each product. (7 points)
--    295 rows
SELECT *
FROM SalesLT.Product;



--3.  List all products showing product ID, product name, standard cost and list price in order 
--    by highest to lowest list price. (7 points)
--    295 rows
SELECT Product.ProductID, Product.Name, Product.ListPrice
FROM SalesLT.Product
ORDER BY Product.ListPrice ASC;


  
--4.  List the unique city, state/province and country/region and order alphabetically 
--    by country/region, state/province and city. (7 points)
--    272 rows
SELECT City, StateProvince, CountryRegion
FROM SalesLT.Address
GROUP BY City, StateProvince, CountryRegion
ORDER BY CountryRegion, StateProvince, City ASC;


--5.  List all orders from the SalesLT.SalesOrderHeader table from 
--    most recent to oldest based on OrderDate.  Include all data related to each order. (7 points)
--    32 rows  
SELECT *
FROM SalesLT.SalesOrderHeader
ORDER BY OrderDate ASC;



--6.  List the colors of AdventureWorks products.  List each color only once and
--    list the colors in alphabetical order. (7 points)
--    10 rows
SELECT Product.Color
FROM SalesLT.Product
GROUP BY Product.Color
ORDER BY Product.Color ASC;



--7.  List customer IDs for all customers that have placed orders with AdventureWorks.
--    Use the SalesLT.SalesOrderHeader table and show each customer ID only once even if the customer
--    has placed multiple orders. (8 points)
--    32 rows
SELECT CustomerID
FROM SalesLT.SalesOrderHeader
GROUP BY CustomerID
ORDER BY CustomerID ASC;
