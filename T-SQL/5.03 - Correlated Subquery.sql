USE  Test_DB;
GO

/*
Correlated Subquery
*/

-- نمایش جدیدترین سفارش هر مشتری
-- Query1
SELECT
	CustomerID,-- عدم دخالت سایر فیلدها
	MAX(OrderID) AS NewOrder
FROM dbo.Orders
GROUP BY CustomerID;
GO

-- Self Contained Scalar Valued با استفاده از Query1 عدم نوشتن
SELECT
	CustomerID,
	(SELECT MAX(OrderID) FROM dbo.Orders) AS NewOrder
FROM dbo.Orders
GROUP BY CustomerID;
GO

-- Self Contained Scalar Valued با استفاده از Query1 عدم نوشتن
SELECT
	CustomerID, OrderID
FROM dbo.Orders
	WHERE OrderID = (SELECT MAX(OrderID) FROM dbo.Orders);
GO
--------------------------------------------------------------------

-- SELECT در بخش Correlated Subquery نمایش جدیدترین کدسفارش هر مشتری با استفاده از
-- DISTINCT
SELECT
	DISTINCT O1.CustomerID,
	(SELECT MAX(O2.OrderID) FROM dbo.Orders AS O2
		WHERE O1.CustomerID = O2.CustomerID) AS NewOrder
FROM dbo.Orders AS O1;
GO

-- SELECT در بخش Correlated Subquery نمایش جدیدترین کدسفارش هر مشتری با استفاده از
-- GROUP BY
SELECT
	O1.CustomerID,
	(SELECT MAX(O2.OrderID) FROM dbo.Orders AS O2
		WHERE O1.CustomerID = O2.CustomerID) AS NewOrder
FROM dbo.Orders AS O1
GROUP BY O1.CustomerID;
GO

SELECT
	C.CustomerID,
	(SELECT MAX(O.OrderID) FROM dbo.Orders AS O
		WHERE C.CustomerID = O.CustomerID) AS NewOrder
FROM dbo.Customers AS C;
GO
--------------------------------------------------------------------

/*
Query1
WHERE در بخش Correlated Subquery نمایش جدیدترین کدسفارش هر مشتری با استفاده از
*/
SELECT
	O1.CustomerID,
	O1.OrderID
FROM dbo.Orders AS O1
	WHERE O1.OrderID = (SELECT MAX(O2.OrderID) FROM dbo.Orders AS O2
							WHERE O1.CustomerID = O2.CustomerID);
GO

/*
Query2
Correlated Subquery روشی ساده‌تر برای نمایش جدیدترین سفارش هر مشتری بدون استفاده از
*/
SELECT
	CustomerID, 
	MAX(OrderID) AS NewOrder
FROM dbo.Orders
GROUP BY CustomerID;
GO

/*
بدون درنظر گرفتن ایندکس جداول Query2 و Query1 مقایسه میان کوئری‌های
*/
--Query1
SELECT
	O1.CustomerID, O1.OrderID
FROM dbo.Orders AS O1
	WHERE O1.OrderID = (SELECT MAX(O2.OrderID) FROM dbo.Orders AS O2
							WHERE O1.CustomerID = O2.CustomerID);
GO

--Query2
SELECT
	CustomerID, 
	MAX(OrderID) AS NewOrder
FROM dbo.Orders
GROUP BY CustomerID;
GO

/*
با درنظر گرفتن ایندکس جداول Query2 و Query1 مقایسه میان کوئری‌های
*/
-- Query1
SELECT
	O1.CustomerID,
	O1.OrderID
FROM Sales.Orders AS O1
	WHERE O1.OrderID = (SELECT MAX(O2.OrderID) FROM Sales.Orders AS O2
							WHERE O2.CustomerID = O1.CustomerID);
GO

-- Query2
SELECT
	CustomerID, 
	MAX(OrderID) AS NewOrder
FROM Sales.Orders
GROUP BY CustomerID;
GO
--------------------------------------------------------------------

/*
Performance 
*/

USE AdventureWorks2017;
GO

SELECT * FROM Sales.SalesOrderHeader;
GO

SELECT
	SalesPersonID,
	MAX(OrderDate) AS NewOrder
FROM Sales.SalesOrderHeader
	WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID;
GO

SELECT
	SalesPersonID,
	OrderDate
FROM Sales.SalesOrderHeader AS SOH1
	WHERE SOH1.SalesOrderID = (SELECT MAX(SOH2.SalesOrderID) FROM Sales.SalesOrderHeader AS SOH2 
									WHERE SOH1.SalesPersonID = SOH2.SalesPersonID);
GO
--------------------------------------------------------------------

USE Test_DB;
GO

/*
.نمایش تعداد سفارش همه شرکت‌ها حتی آن‌هایی که سفارش نداشته‌اند 
*/

-- JOIN
SELECT
	C.CustomerID,
	C.CompanyName,
	COUNT(O.OrderID) AS Num
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID,C.CompanyName;
GO

-- Correlated Subquery
SELECT
	C.CustomerID,
	C.CompanyName,
	(SELECT COUNT(O.OrderID) FROM dbo.Orders AS O
		WHERE C.CustomerID = O.CustomerID) AS Num
FROM dbo.Customers AS C;
GO

-- !!!مطابق با نتیجه تمرین نیست
SELECT
	O.CustomerID,
	(SELECT C.CompanyName FROM dbo.Customers AS C
		WHERE C.CustomerID = O.CustomerID) AS CompanyName,
	COUNT(O.OrderID) AS Num
FROM dbo.Orders AS O
GROUP BY O.CustomerID;
GO
--------------------------------------------------------------------

/*
.نمایش تاریخ جدیدترین سفارش هر شرکت حتی فاقد سفارش‌ها‌
*/

--  JOIN
SELECT
	C.CustomerID, C.CompanyName,
	MAX(OrderDate) AS NewOrder
FROM dbo.Orders AS O
RIGHT JOIN dbo.Customers AS C
	ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID, C.CompanyName;
GO

-- SELECT در بخش Correlated Subquery با استفاده از
SELECT
	C.CustomerID,
	C.CompanyName,
	(SELECT MAX(OrderDate) FROM dbo.Orders AS O
		WHERE C.CustomerID = O.CustomerID) AS Num
FROM dbo.Customers AS C;
GO

-- WHERE در بخش Correlated Subquery با استفاده از
SELECT
	C.CustomerID,
	C.CompanyName,
	O1.OrderDate
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O1
	ON C.CustomerID = O1.CustomerID
	WHERE O1.OrderDate = (SELECT MAX(O2.OrderDate) FROM dbo.Orders AS O2
							WHERE O2.CustomerID = O1.CustomerID)
	OR O1.OrderDate IS NULL
GROUP BY C.CustomerID, C.CompanyName, O1.OrderDate;
GO
