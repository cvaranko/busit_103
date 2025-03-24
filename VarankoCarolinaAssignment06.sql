--*  BusIT 103           Assignment   #6              DUE DATE :  Consult course calendar
							
--You are required to use INNER JOINs to solve each problem. We are not using cross joins with WHERE clauses. 
--Even if you know another method that will produce the result, this module is practice in INNER JOINs.

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment06.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


--You are to develop SQL statements for each task listed. You should type your SQL statements under each task. 


USE AdventureWorks2022;

--  You are required to use INNER JOINs to solve each problem. We are not using cross joins with WHERE clauses.
--  To make the joins in the first 4 question more understandable, create a database diagram with the following tables:
	--Production.Product
	--Production.ProductReview
	--Production.ProductModel
	--Production.ProductSubcategory
	--Production.ProductCategory

--1.a.	List any products that have product reviews.  Show product ID, product name, and comments.
--		Hint:  Use the Production.Product and Production.ProductReview tables. (3 points)
--		4 Rows
SELECT p.ProductID, p.Name AS ProductName, pr.Comments
FROM Production.Product AS p
INNER JOIN Production.ProductReview AS pr ON p.ProductID = pr.ProductID;

--1.b.	Modify 1.a. to list product reviews for Product ID 798.  Show product ID, product name,
-- and comments. (6 points)
--		1 Row
SELECT p.ProductID, p.Name AS ProductName, pr.Comments
FROM Production.Product AS p
INNER JOIN Production.ProductReview AS pr ON p.ProductID = pr.ProductID
WHERE p.ProductID = 798;


--2.a.	List products with product model numbers. Show Product ID, product name, 
--		standard cost, model ID number, and model name. Order by model ID. (3 points)
--		Hint: Look for a table that contains "model" in its name
--		295 Rows
SELECT Product.ProductID, Product.Name AS ProductName, Product.StandardCost, Product.ProductModelID, ProductModel.Name AS ModelName
FROM Production.Product
INNER JOIN Production.ProductModel ON Product.ProductModelID = ProductModel.ProductModelID
ORDER BY Product.ProductModelID;


--2. b.	Modify 2.a. to list products whose product model is 3 (Full-Finger Gloves). Show Product ID , product name, 
--		standard cost, ID number, and model name and order by model ID. (6 points)
--		3 Rows
SELECT Product.ProductID, Product.Name AS ProductName, Product.StandardCost, Product.ProductModelID, ProductModel.Name AS ModelName
FROM Production.Product
INNER JOIN Production.ProductModel ON Product.ProductModelID = ProductModel.ProductModelID
WHERE Product.ProductModelID = 3
ORDER BY Product.ProductModelID;



--3. a.	List Products, their subcategories and their categories.  Show the category name, subcategory name, 
--		product ID, and product name, in this order. Sort in alphabetical order on category name,
--		then subcategory name, and then by product name. (3 points)
--		295 Rows

--		Hint:  To understand the relationshships, refer to your database diagram and the following tables:
--		Production.Product
--		Production.ProductSubCategory
--		Production.ProductCategory
SELECT ProductCategory.Name AS CategoryName, ProductSubCategory.Name AS SubCategoryName, Product.ProductID, Product.Name AS ProductName
FROM Production.Product
INNER JOIN Production.ProductSubCategory ON Product.ProductSubCategoryID = ProductSubCategory.ProductSubCategoryID
INNER JOIN Production.ProductCategory ON ProductSubCategory.ProductCategoryID = ProductCategory.ProductCategoryID
ORDER BY CategoryName, SubCategoryName, ProductName;




--3. b.	Modify 3.a. to list Products in category 1.  Show the category name, subcategory name, 
--		product ID, and product name, in this order. Sort in alphabetical order on category name,
--		then subcategory name, and then by product name. (6 points)
--		Hint: Add the product category id field to the results set to check your results and then remove it or comment it out.
--		97 Rows
SELECT ProductCategory.Name AS CategoryName, ProductSubCategory.Name AS SubCategoryName, Product.ProductID, Product.Name AS ProductName
FROM Production.Product
INNER JOIN Production.ProductSubCategory ON Product.ProductSubCategoryID = ProductSubCategory.ProductSubCategoryID
INNER JOIN Production.ProductCategory ON ProductSubCategory.ProductCategoryID = ProductCategory.ProductCategoryID
WHERE ProductCategory.ProductCategoryID = 1
ORDER BY CategoryName, SubCategoryName, ProductName;



--4.a.	List Products, their subcategories, their categories, and their model.  Show the model name, category name, 
--		subcategory name, product ID, and product name in this order. Sort in alphabetical order by model name. (3 points)
--		295 Rows

--		Hint:  To understand the relationshships, refer to your database diagram and the following tables:
--		Production.Product
--		Production.ProductSubCategory
--		Production.ProductCategory
--		Production.ProductModel
--		Choose a path from one table to the next and follow it in a logical order
SELECT ProductModel.Name AS ModelName, ProductCategory.Name AS CategoryName, ProductSubCategory.Name AS SubCategoryName, Product.ProductID, Product.Name AS ProductName
FROM Production.Product
INNER JOIN Production.ProductSubCategory ON Product.ProductSubCategoryID = ProductSubCategory.ProductSubCategoryID
INNER JOIN Production.ProductCategory ON ProductSubCategory.ProductCategoryID = ProductCategory.ProductCategoryID
INNER JOIN Production.ProductModel ON Product.ProductModelID = ProductModel.ProductModelID
ORDER BY ModelName;





--4. b.	Modify 4.a. to list those products in model ID 5 with silver in the product name. Change
-- the sort to sort only on Product ID. Hint: Add the product model id field to the results set to
-- check your results and then remove it or comment it out. (6 points)
--	5 Rows
SELECT Product.ProductID, Product.Name AS ProductName,Product.ProductModelID, ProductModel.Name AS ModelName, ProductCategory.Name AS CategoryName, ProductSubCategory.Name AS SubCategoryName
FROM Production.Product
INNER JOIN Production.ProductSubCategory ON Product.ProductSubCategoryID = ProductSubCategory.ProductSubCategoryID
INNER JOIN Production.ProductCategory ON ProductSubCategory.ProductCategoryID = ProductCategory.ProductCategoryID
INNER JOIN Production.ProductModel ON Product.ProductModelID = ProductModel.ProductModelID
WHERE Product.ProductModelID = 5 AND Product.Name LIKE '%Silver%'
ORDER BY Product.ProductID;


--5.	List sales for customer id 18759.  Show product names, sales order id, and OrderQty. (6 points)
--		8 Rows
--		Hint:  First create a database diagram with the following tables:
--		Production.Product
--		Sales.SalesOrderHeader
--		Sales.SalesOrderDetail
-- 
SELECT Product.Name AS ProductName, SalesOrderDetail.SalesOrderID, SalesOrderDetail.OrderQty
FROM Sales.SalesOrderDetail
INNER JOIN Sales.SalesOrderHeader ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
INNER JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID
WHERE SalesOrderHeader.CustomerID = 18759;



--6.	List all sales for Bikes that were ordered during 2014.  Show product ID, product name,
-- and LineTotal for each line item sale.
--	Show the list in order alphabetically by product name. (8 points)
--	 Hint: Use the diagram you created in #5
--	8944 Rows.  
SELECT Product.ProductID, Product.Name AS ProductName, SalesOrderDetail.LineTotal
FROM Sales.SalesOrderDetail
INNER JOIN Sales.SalesOrderHeader ON SalesOrderDetail.SalesOrderID = SalesOrderHeader.SalesOrderID
INNER JOIN Production.Product ON SalesOrderDetail.ProductID = Product.ProductID
INNER JOIN Production.ProductSubCategory ON Product.ProductSubCategoryID = ProductSubCategory.ProductSubCategoryID
INNER JOIN Production.ProductCategory ON ProductSubCategory.ProductCategoryID = ProductCategory.ProductCategoryID
WHERE ProductCategory.Name = 'Bikes' AND YEAR(SalesOrderHeader.OrderDate) = 2014
ORDER BY ProductName;

	



