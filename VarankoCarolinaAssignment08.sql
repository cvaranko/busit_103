--*  BusIT 103           Assignment   #8              DUE DATE :  Consult course calendar
							
--You are to develop SQL statements for each task listed.  
--You should type your SQL statements under each task. 
--Each task must be accomplished using some type of OUTER JOIN. 

/*	Submit your .sql file named with your last name, first name and assignment # (e.g., SuneelPratimaAssignment08.sql). 
	Submit your file to the instructor through the course site.  
	
	Class standard: All KEYWORDS such as SELECT, FROM, WHERE, INNER JOIN and so on must be in all capital letters and on separate lines. */


Use AdventureWorksDW2022;


--IMPORTANT NOTE: Only one LEFT OUTER JOIN is to be used for each task. 
--The use of more than one LEFT OUTER JOIN per task will cause points to be TAKEN OFF.

--NOTE:  When the task does not specify sort order, it is your responsibility to order the information
--    so that is easy to interpret.


--  1.  List all Sales Reasons that have not been associated with an internet sale. (5 points)
--      Hint:  Use factInternetSalesReason and dimSalesReason. 
--		3 Rows
SELECT sr.SalesReasonKey, sr.SalesReasonName
FROM dimSalesReason sr
LEFT OUTER JOIN factInternetSalesReason isr ON sr.SalesReasonKey = isr.SalesReasonKey
WHERE isr.SalesReasonKey IS NULL;

--2.    List all internet sales that do not have at least 1 sales reason associated.
--      List SalesOrderNumber, SalesOrderLineNumber and the order date. (5 points)
--      Hint:  Use factInternetSales and factInternetSalesReason. 
--		6429 rows
SELECT si.SalesOrderNumber, si.SalesOrderLineNumber, si.OrderDate
FROM factInternetSales si
LEFT OUTER JOIN factInternetSalesReason isr ON si.SalesOrderNumber = isr.SalesOrderNumber
WHERE isr.SalesOrderNumber IS NULL;


--  3.  List all promotions that have not been associated with a reseller sale. (5 points)
--		4 Rows
SELECT p.PromotionKey, p.EnglishPromotionName
FROM dimPromotion p
LEFT OUTER JOIN factResellerSales rs ON p.PromotionKey = rs.PromotionKey
WHERE rs.PromotionKey IS NULL;



--4.    Find any cities in which AdventureWorks has no customers
--      List city, state/province, and the English country/region name
--      List each city only one time. Sort by country, state, and city. (5 points)
--		303 Rows
SELECT g.City, g.StateProvinceName, g.EnglishCountryRegionName
FROM dbo.dimGeography g
LEFT OUTER JOIN dbo.dimCustomer c ON g.GeographyKey = c.GeographyKey
WHERE c.CustomerKey IS NULL
GROUP BY g.City, g.StateProvinceName, g.EnglishCountryRegionName
ORDER BY g.EnglishCountryRegionName, g.StateProvinceName, g.City;



--5.    Find any cities in which AdventureWorks has no resellers
--      List city, state/province, and the English country/region name
--      List each city only one time. Sort by country, state, and city. (5 points)
--		133 Rows
SELECT l.City, l.StateProvinceName, l.EnglishCountryRegionName
FROM dbo.dimGeography l
LEFT OUTER JOIN dbo.dimReseller r ON l.GeographyKey = r.GeographyKey
WHERE r.ResellerKey IS NULL
GROUP BY l.City, l.StateProvinceName, l.EnglishCountryRegionName
ORDER BY l.EnglishCountryRegionName, l.StateProvinceName, l.City;



--6.    Write a query to determine if there are any product categories that do not have 
--      related sub categories. (5 points)
--		0 Rows
SELECT c.ProductCategoryKey, c.EnglishProductCategoryName
FROM dimProductCategory c
LEFT OUTER JOIN dimProductSubcategory sc ON c.ProductCategoryKey = sc.ProductCategoryKey
WHERE sc.ProductSubcategoryKey IS NULL;



--7.    Find all promotions and any related internet sales. List unique instances of the 
--      english promotion name, customer first and last name, and the order date.
--      Sort by the promotion name. Be sure to list all promotions even if there is no related sale. (5 points)
--		29199 Rows
SELECT DISTINCT p.EnglishPromotionName, 
    (SELECT c.FirstName 
     FROM dimCustomer c 
     WHERE c.CustomerKey = si.CustomerKey) AS FirstName,
    (SELECT c.LastName 
     FROM dimCustomer c 
     WHERE c.CustomerKey = si.CustomerKey) AS LastName, si.OrderDate
FROM dimPromotion p
LEFT OUTER JOIN factInternetSales si ON p.PromotionKey = si.PromotionKey
ORDER BY p.EnglishPromotionName;




--8.    Find all promotions and any related reseller sales. List unique instances of the english 
--      promotion name, reseller name, and the order date.
--      Sort by the promotion name. Be sure to list all promotions even if there is no related sale. (5 points)
--		5174 Rows
SELECT DISTINCT p.EnglishPromotionName, 
    (SELECT r.ResellerName 
     FROM dimReseller r 
     WHERE r.ResellerKey = rs.ResellerKey) AS ResellerName,rs.OrderDate
FROM dimPromotion p
LEFT OUTER JOIN factResellerSales rs ON p.PromotionKey = rs.PromotionKey
ORDER BY p.EnglishPromotionName;



--9.    List reseller name for resellers who have not sold any bikes. (5 points)
--		114 Rows
SELECT r.ResellerName
FROM dbo.dimReseller r
LEFT OUTER JOIN dbo.factResellerSales rs 
    ON r.ResellerKey = rs.ResellerKey
    AND rs.ProductKey IN (
        SELECT p.ProductKey 
        FROM dbo.dimProduct p
        WHERE p.ProductSubcategoryKey IN (
            SELECT ps.ProductSubcategoryKey 
            FROM dbo.dimProductSubcategory ps
            INNER JOIN dbo.dimProductCategory pc 
                ON ps.ProductCategoryKey = pc.ProductCategoryKey
            WHERE pc.EnglishProductCategoryName = 'Bikes'
        )
    )
WHERE rs.SalesOrderNumber IS NULL;


--10.   List all male customers and any clothing they have purchased over the internet.
--      List customer alternate key, customer last name, customer first name, 
--      product alternate key, and product name.  Be sure to include male customers who have not 
--      purchased clothing. (5 points)
--		10497 Rows
SELECT c.CustomerAlternateKey, c.LastName, c.FirstName, 
    (SELECT p.ProductAlternateKey 
     FROM dimProduct p 
     WHERE p.ProductKey = si.ProductKey 
       AND p.ProductSubcategoryKey IN (
            SELECT ps.ProductSubcategoryKey 
            FROM dimProductSubcategory ps
            JOIN dimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
            WHERE pc.EnglishProductCategoryName = 'Clothing'
       )) AS ProductAlternateKey,
    (SELECT p.EnglishProductName 
     FROM dimProduct p 
     WHERE p.ProductKey = si.ProductKey 
       AND p.ProductSubcategoryKey IN (
            SELECT ps.ProductSubcategoryKey 
            FROM dimProductSubcategory ps
            JOIN dimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
            WHERE pc.EnglishProductCategoryName = 'Clothing'
       )) AS EnglishProductName
FROM dimCustomer c
LEFT OUTER JOIN factInternetSales si ON c.CustomerKey = si.CustomerKey
WHERE c.Gender = 'M'
ORDER BY c.LastName, c.FirstName;






 





	


