USE Test_DB;
GO

/*
INSERT INTO <table_name1> (column1, column2, ...)
SELECT Statement;
*/

DROP TABLE IF EXISTS dbo.Insert_Select;
GO

CREATE TABLE dbo.Insert_Select
(
	CustomerID INT,
	LastName NVARCHAR(50),
	City NVARCHAR(20)
);
GO

-- نمایش تمامی اطلاعات مربوط به مشتریان تهرانی و کارمندان مرتبط با ثبت‌سفارش 
SELECT
	DISTINCT C.CustomerID, C.City, E.LastName
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON O.CustomerID = C.CustomerID
JOIN Employees AS E
	ON E.EmployeeID = O.EmployeeID
	WHERE C.City = N'تهران';
GO

SELECT
	C.CustomerID, C.City, Tmp.LastName
FROM dbo.Customers AS C
CROSS APPLY
	(SELECT E.LastName FROM dbo.Employees AS E
		WHERE EXISTS (SELECT 1 FROM dbo.Orders AS O
							WHERE O.EmployeeID = E.EmployeeID
							AND O.CustomerID = C.CustomerID)) AS Tmp 
	WHERE C.City = N'تهران' 
ORDER BY C.CustomerID;
GO

INSERT INTO dbo.Insert_Select
SELECT
	C.CustomerID, Tmp.LastName, C.City
FROM dbo.Customers AS C
CROSS APPLY
	(SELECT E.LastName FROM dbo.Employees AS E
		WHERE EXISTS (SELECT 1 FROM dbo.Orders AS O
						WHERE O.EmployeeID = E.EmployeeID
						AND O.CustomerID = C.CustomerID
						AND C.City = N'تهران')) AS Tmp ORDER BY C.CustomerID;
GO

SELECT * FROM dbo.Insert_Select
ORDER BY CustomerID;
GO

--------------------------------------------------------------

                    --SELECT INTO

--------------------------------------------------------------
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