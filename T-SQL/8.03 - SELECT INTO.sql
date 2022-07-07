USE Test_DB;
GO

/*
SELECT INTO یا Make Table Query

.جدول مقصد نباید از قبل وجود داشته باشد

:آن‌چه منتقل می‌شود
 ساختار جدول و رکوردهای آن

:آن‌چه منتقل نمی‌شود
Permission ،محدودیت‌ها، ایندکس ، تریگر‌
*/

DROP TABLE IF EXISTS dbo.Orders1,dbo.Orders2,dbo.Orders3;
GO

-- کپی از جدول بر اساس تمامی فیلدهای آن
SELECT * INTO dbo.Orders1
FROM dbo.Orders;
GO

SELECT * FROM dbo.Orders1;
GO

-- کپی از جدول بر اساس برخی از فیلدهای آن
SELECT
	OrderID,CustomerID AS C_ID
INTO dbo.Orders2
FROM dbo.Orders
	WHERE OrderID > 11076;
GO

SELECT * FROM dbo.Orders2;
GO

SELECT
	OrderID,CustomerID
INTO dbo.Orders3
FROM dbo.Orders
	WHERE OrderID > 1000000;
GO

SELECT * FROM dbo.Orders3;
GO
--------------------------------------------------------------------

/*
مشتریان دارای سفارش شامل کد مشتری، شهر و کد سفارش
*/

DROP TABLE IF EXISTS dbo.Cust_Ord;
GO


-- عملیات غیرمجاز
SELECT *
INTO dbo.Cust_Ord
FROM
SELECT
	C.CustomerID, C.City, O.OrderID
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID;
GO

DROP TABLE IF EXISTS dbo.Cust_Ord;
GO
-- عملیات مجاز
SELECT
*
INTO dbo.Cust_Ord
FROM (SELECT
		C.CustomerID, C.City, O.OrderID
	  FROM dbo.Customers AS C
	  JOIN dbo.Orders AS O
		ON C.CustomerID = O.CustomerID) AS Tmp;
GO

SELECT * FROM dbo.Cust_Ord;
GO																												


DROP TABLE IF EXISTS dbo.Cust_Ord;
GO
-- Subquery با استفاده از
SELECT
	O.CustomerID,
	O.OrderID,
	(SELECT C.City FROM dbo.Customers AS C
		WHERE C.CustomerID = O.CustomerID)
FROM dbo.Orders AS O

SELECT Tmp.* INTO dbo.Cust_Ord
FROM
(
SELECT
	O.CustomerID,
	O.OrderID,
	(SELECT C.City FROM dbo.Customers AS C
		WHERE C.CustomerID = O.CustomerID) AS City
FROM dbo.Orders AS O
) AS Tmp;
GO

SELECT * FROM dbo.Cust_Ord;
GO