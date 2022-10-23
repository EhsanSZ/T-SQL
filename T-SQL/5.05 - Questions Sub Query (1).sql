
USE Test_DB;
GO

/*
Exersice 01
.فهرست شرکت‌هایی که بیش از 10 سفارش درخواست داشته‌اند
*/
/*
JOIN
*/
SELECT--In Class
	C.CompanyName, C.CustomerID
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
GROUP BY C.CompanyName, C.CustomerID
	HAVING COUNT(O.OrderID) > 10;
GO


/*
Subquery (WHERE)

Outer Query: Customers
Subquery: Orders
*/
SELECT--In Class
	C.CompanyName, C.CustomerID
FROM dbo.Customers AS C
	WHERE (SELECT COUNT(O.OrderID) FROM dbo.Orders AS O
			WHERE O.CustomerID = C.CustomerID) > 10;
GO


/*
Subquery (WHERE)

Outer Query: Customers
Subquery: Orders
*/
SELECT--In Class
	C.CompanyName, C.CustomerID
FROM dbo.Customers AS C
	WHERE C.CustomerID = (SELECT O.CustomerID FROM dbo.Orders AS O
							WHERE O.CustomerID = C.CustomerID
						  GROUP BY O.CustomerID
							HAVING COUNT(O.OrderID) > 10);
GO

/*
Subquery (EXISTS)

Outer Query: Customers
Subquery: Orders
*/
SELECT--In Class
	C.CompanyName, C.CustomerID
FROM dbo.Customers AS C
	WHERE EXISTS (SELECT 1 FROM dbo.Orders AS O
					WHERE O.CustomerID = C.CustomerID
					HAVING COUNT(O.OrderID) > 10);
GO


/*
Subquery (IN)

Outer Query: Customers
Subquery: Orders
*/
SELECT--In Class
	C.CompanyName, C.CustomerID
FROM dbo.Customers AS C
	WHERE C.CustomerID IN (SELECT O.CustomerID FROM dbo.Orders AS O
						   GROUP BY O.CustomerID
							HAVING COUNT(O.OrderID) > 10);
GO

/*
Subquery (SELECT)

Outer Query: Customers
Subquery: Orders
*/
SELECT--In Class
	C.CompanyName,
	(SELECT O.CustomerID FROM dbo.Orders AS O
		WHERE O.CustomerID = C.CustomerID
	 GROUP BY O.CustomerID
		HAVING COUNT(O.OrderID) > 10) AS CustomerID
FROM dbo.Customers AS C;
GO


/*
Subquery (SELECT)

Outer Query: Orders
Subquery: Customers
*/
SELECT--In Class
	(SELECT C.CompanyName FROM dbo.Customers AS C
		WHERE C.CustomerID = O.CustomerID) AS CompanyName,
	O.CustomerID
FROM dbo.Orders AS O
GROUP BY O.CustomerID
	HAVING COUNT(O.OrderID) > 10;
GO
--------------------------------------------------------------------

/*
Exersice 02
.تعداد سفارش شرکت‌هایی که در استان زنجان واقع شده‌اند
*/

/*
JOIN
*/
SELECT--In Class
	C.CompanyName,
	COUNT(O.OrderID) AS Num
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
	WHERE C.State = N'زنجان'
GROUP BY C.CompanyName;
GO

/*
Subquery (SELECT)

Outer Query: Customers
Subquery: Orders
*/
SELECT--In Class
	C.CompanyName,
	(SELECT COUNT(O.OrderID) FROM dbo.Orders AS O
		WHERE O.CustomerID = C.CustomerID) AS Num
FROM dbo.Customers AS C
	WHERE C.State = N'زنجان';
GO


/*
Subquery (SELECT)

Outer Query: Orders
Subquery: Customers
*/
SELECT--In Class
	(SELECT C.CompanyName FROM dbo.Customers AS C
		WHERE C.State = N'زنجان'
		AND C.CustomerID = O.CustomerID) AS CompanyName,
	COUNT(O.OrderID) AS Num
FROM dbo.Orders AS O
GROUP BY O.CustomerID;
GO
--------------------------------------------------------------------

/*
Exersice 03
.محصولاتی که قیمت واحد آن‌ها از میانگین قیمت واحد تمامی محصولات بیشتر و یا با آن برابر باشد
*/

-- میانگین قیمت واحد تمامی محصولات
SELECT AVG(UnitPrice) FROM dbo.Products;
GO

-- Subquery (WHERE)
SELECT--In Class
	ProductID, UnitPrice
FROM dbo.Products AS P
	WHERE P.UnitPrice >= (SELECT AVG(UnitPrice) FROM dbo.Products);
GO


-- Subquery (IN)
SELECT
	ProductID, UnitPrice
FROM dbo.Products AS P
	WHERE P.ProductID IN (SELECT ProductID FROM dbo.Products AS P
							WHERE P.UnitPrice >= (SELECT AVG(UnitPrice) FROM dbo.Products));
GO


-- Subquery (EXISTS)
SELECT
	ProductID, UnitPrice
FROM dbo.Products AS P
	WHERE EXISTS (SELECT 1 FROM dbo.Products AS P1
					WHERE P1.UnitPrice >= (SELECT AVG(UnitPrice) FROM dbo.Products)
					AND P1.ProductID = P.ProductID);
GO
--------------------------------------------------------------------

/*
Exersice 04
.مشخصات کارمندی که تا به امروز کمترین تعداد ثبتِ سفارش را داشته است
*/

-- .کارمندانی که کمترین ثبت‌سفارش داشته‌اند
SELECT
	TOP (1) WITH TIES EmployeeID,
	COUNT(OrderID) AS Num
FROM dbo.Orders
GROUP BY EmployeeID
ORDER BY Num;
GO

-- JOIN
SELECT--In Class
	TOP (1) WITH TIES E.EmployeeID,
	E.FirstName,
	E.LastName
FROM dbo.Orders AS O
JOIN dbo.Employees AS E
	ON E.EmployeeID = O.EmployeeID
GROUP BY E.EmployeeID, E.FirstName, E.LastName
ORDER BY COUNT(O.OrderID);
GO


/*
Subquery (IN)

Outer Query: Employees
Subquery: Orders
*/
SELECT--In Class
	E.EmployeeID , E.FirstName, E.LastName
FROM dbo.Employees AS E
	WHERE E.EmployeeID IN (SELECT TOP (1) WITH TIES O.EmployeeID FROM dbo.Orders AS O
						   GROUP BY O.EmployeeID
						   ORDER BY COUNT(O.OrderID));
GO

/*
Subquery (SELECT)

Outer Query: Orders
Subquery: Employees
*/
SELECT--In Class
	TOP (1) WITH TIES O.EmployeeID,
	(SELECT E.FirstName FROM dbo.Employees AS E
		WHERE E.EmployeeID = O.EmployeeID) AS FirstName,
	(SELECT E.LastName FROM dbo.Employees AS E
		WHERE E.EmployeeID = O.EmployeeID) AS LastName
FROM dbo.Orders AS O
GROUP BY O.EmployeeID
ORDER BY COUNT(O.OrderID);
GO


/*
Subquery (SELECT)

Outer Query: Employees
Subquery: Orders
*/
SELECT
	TOP (1) WITH TIES E.EmployeeID, E.FirstName, E.LastName,
	(SELECT COUNT(OrderID) FROM dbo.Orders AS O
		WHERE E.EmployeeID = O.EmployeeID) AS Num 
FROM dbo.Employees AS E
ORDER BY Num;
GO

SELECT--In Class
	TOP (1) WITH TIES E.EmployeeID, E.FirstName, E.LastName
FROM dbo.Employees AS E
ORDER BY (SELECT COUNT(OrderID) FROM dbo.Orders AS O
			WHERE E.EmployeeID = O.EmployeeID);
GO