--*  BusIT 103           Assignment   #9              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task.  

/*	Submit your .sql file named with your last name, first name and assignment #
    (e.g., SuneelPratimaAssignment09.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be
	in all capital letters and on separate lines. */


Use AdventureWorksDW2022


--Note 1:  When the task does not specify sort order, it is your responsibility to order the information 
--         so that is easy to interpret.
--Note 2:  The questions are numbered. 1.a., 1.b., 2.a., 2.b., etc to remind you of the steps in developing and 
--         testing your queries/subqueries. The first steps will not require subqueries unless specified. The last step in every sequence 
--         will require a subquery, regardless of whether the result can be created using another method. 

-- 1.a. List the average sales amount quota for employees at AdventureWorks. Use AVG. (2 points)
--      587202.4539
SELECT AVG(SalesQuotaKey) AS AvgSalesQuota
FROM FactSalesQuota;




-- 1.b. List the average sales amount quota for employees at AdventureWorks for 2011. (2 points)
--       604232.5581 
SELECT AVG(SalesQuotaKey) AS AvgSalesQuota2011
FROM FactSalesQuota
WHERE YEAR(Date) = 2011;




--1.c. List the name, title, and hire date for AdventureWorks employees 
--     whose sales quota for 2011 is higher than the average for all employees for 2011.
--     Be sure to use an appropriate sort. (4 points)
--     16 Rows
--     Hint - Might want to use WHERE clause Twice!!! Once for inner query and once for outer query.
--     USE UNCorrelated Subquery
SELECT e.FirstName + ' ' + e.LastName AS EmployeeName, e.Title, e.HireDate
FROM DimEmployee e
JOIN FactSalesQuota q ON e.EmployeeKey = q.EmployeeKey
WHERE YEAR(q.Date) = 2011
  AND q.SalesAmountQuota > (
      SELECT AVG(SalesAmountQuota)
      FROM FactSalesQuota
      WHERE YEAR(Date) = 2011
  )
ORDER BY e.HireDate;


-- 2.a.  List the average LIST PRICE of a bike sold by AdventureWorks. (2 point)
--       1 row   
SELECT AVG(ListPrice) AS AvgBikeListPrice
FROM DimProduct
WHERE ProductSubcategoryKey = 'Bikes';




-- 2.b. List all products in the Bikes category that have a list price higher than
--      the average list price of a bike.  Show product alternate key, product name,
--      and list price in the results set. Order the information so it is easy to understand. (4 points)
--      50 rows
--      UnCorrelated subquery
SELECT ProductAlternateKey, EnglishProductName, ListPrice
FROM DimProduct
WHERE EnglishProductName = 'Bikes'
  AND ListPrice > (
		SELECT AVG(ListPrice)
		FROM DimProduct 
		WHERE EnglishProductName = 'Bikes'
	)
ORDER BY ListPrice DESC;



-- 3.a. Find the average yearly income all customers in the customer table. (3 points)
--      57,305.7779
SELECT AVG(YearlyIncome) AS AvgYearlyIncome
FROM DimCustomer;




-- 3.b. Find all males in the customers table with an income less than or the same as the average
--      income of all customers. List last name, a comma and space, and first name in one column and yearly income. (4 points)
--      4404 rows
--      UnCorrelated subquery
SELECT LastName + ', ' + FirstName AS FullName, YearlyIncome
FROM DimCustomer
WHERE Gender = 'M'
  AND YearlyIncome <= (SELECT AVG(YearlyIncome)
        FROM DimCustomer
    )
ORDER BY YearlyIncome DESC;



-- 4.a. List the product name and list price for the bike named Road-150 Red, 48 (3 points)
--      3,578.27
SELECT EnglishProductName, ListPrice
FROM DimProduct
WHERE EnglishProductName = 'Road-150 Red, 48';




-- 4.b. List the product name and price for each product that has a price greater than or 
--	    equal to that of the Road-150 Red, 48. Be sure you are using the subquery not an actual value. (5 points)
--      5 rows
--      USE UnCorrelated Subquery
SELECT EnglishProductName, ListPrice
FROM DimProduct
WHERE ListPrice >= (
        SELECT ListPrice
        FROM DimProduct
        WHERE EnglishProductName = 'Road-150 Red, 48'
    )
ORDER BY ListPrice DESC;



-- 5.a.	List the names of resellers and the product names of products they sold. 
--      Elimate duplicate rows. Use an appropriate sort.  (3 points)
 --     20463 rows
SELECT DISTINCT r.ResellerName, p.EnglishProductName
FROM FactResellerSales rs
JOIN DimReseller r ON rs.ResellerKey = r.ResellerKey
JOIN DimProduct p ON rs.ProductKey = p.ProductKey
ORDER BY r.ResellerName, p.EnglishProductName;





-- 5.b.	List only one time the names of all resellers who sold a cable lock.  
--      Use the IN predicate and a subquery to accomplish the task. Use an appropriate sort. (5 points)
--      93 rows	
--      USE UnCorrelated Subquery
SELECT DISTINCT ResellerName
FROM DimReseller
WHERE ResellerKey IN (
        SELECT ResellerKey
        FROM FactResellerSales
        JOIN DimProduct ON FactResellerSales.ProductKey = DimProduct.ProductKey
        WHERE EnglishProductName = 'Cable Lock'
    )
ORDER BY ResellerName;



-- 6.a. Find the unique customers from the Survey Response fact table. (3 points)
--      1656 ROWS
SELECT DISTINCT CustomerKey
FROM FactSurveyResponse;


-- 7.a. Find the number of times the CustomerKey appears in the Internet Sales Fact table. (3 points)
--      Use COUNT()
--      60,398
SELECT COUNT(CustomerKey) AS CustomerKeyCount
FROM FactInternetSales;


-- 8.  List all resellers whose annual sales exceed the average annual sales for 
--     resellers whose Business Type is "Specialty Bike Shop". Show Business type, Reseller Name,
--     and annual sales.  Use appropriate subqueries. (7 points)
--     396 Rows
--     Use Uncorrelated sub query
SELECT BusinessType, ResellerName, AnnualSales
FROM DimReseller
WHERE AnnualSales > (
        SELECT AVG(AnnualSales)
        FROM DimReseller
        WHERE BusinessType = 'Specialty Bike Shop'
    )
ORDER BY AnnualSales DESC;


