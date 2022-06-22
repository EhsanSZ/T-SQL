
USE Test_DB;
GO

/*
UNION ALL
*/

SELECT 
	State, Region, City FROM dbo.Employees
UNION ALL
SELECT 
	State, Region, City FROM dbo.Customers;
GO
--------------------------------------------------------------------

/*
UNION
*/

SELECT 
	State, Region, City FROM dbo.Employees
UNION
SELECT 
	State, Region, City FROM dbo.Customers;
GO
--------------------------------------------------------------------

-- Set Operator نام ستون‌ها در عملیات
SELECT
	State AS N'استان', Region, City FROM dbo.Employees
UNION ALL
SELECT
	State, Region, City FROM dbo.Customers;
GO
--------------------------------------------------------------------

-- Set Operator مرتب‌سازی در عملیات
SELECT 
	State, Region, City FROM dbo.Employees
ORDER BY Region
UNION ALL
SELECT 
	State, Region, City FROM dbo.Customers;
GO

SELECT 
	State, Region, City FROM dbo.Employees
UNION ALL
SELECT 
	State, Region, City FROM dbo.Customers
ORDER BY Region;
GO
--------------------------------------------------------------------

-- تعداد فیلدهای تمامی مجموعه‌ها می‌بایست با هم برابر باشند
SELECT 
	State , Region, City FROM dbo.Employees
UNION
SELECT 
	State, Region FROM dbo.Customers;
GO
--------------------------------------------------------------------

-- عدم تطابق میان نوع‌داده فیلدهای هر یک از مجموعه‌ها
SELECT
	O.OrderDate FROM dbo.Orders AS O
UNION
SELECT
	C.City FROM dbo.Customers AS C;
GO

-- نوع‌داده فیلدهای تمامی مجموعه‌ها می‌بایست قابل تبدیل باشند 
-- ها توجه کن Data Type به نحوه تبدیل
DROP TABLE IF EXISTS SO1,SO2;
GO

CREATE TABLE SO1 
(
	ID TINYINT,
	Family NVARCHAR(50)
);
GO

CREATE TABLE SO2
(
	Code INT,
	Title NVARCHAR(10)
);
GO

INSERT INTO SO1
	VALUES	(1,N'احمدی'),(2,N'مشفق'),(3,N'جلالی'),(4,N'سلیمانی');
GO

INSERT INTO SO2
	VALUES	(10000,N'رئیس'),(20000,N'کارمند'),(30000,N'سرپرست');
GO

SELECT
	Tmp.Family,
	Tmp.ID,
	DATALENGTH(Tmp.Family) AS Family_Space,
	DATALENGTH(Tmp.ID) AS ID_Space
FROM (SELECT ID,Family  FROM SO1 
		UNION
	  SELECT Code, Title FROM SO2)Tmp ;
GO
--------------------------------------------------------------------

-- Set Operator در NULL مقادیر

INSERT INTO SO1
	VALUES(1,NULL);
GO

INSERT INTO SO2
	VALUES(1,NULL);
GO

SELECT
	ID, Family FROM SO1 
UNION ALL
SELECT
	Code, Title FROM SO2;
GO

SELECT
	ID,Family  FROM SO1 
UNION
SELECT
	Code, Title FROM SO2;
GO
--------------------------------------------------------------------

-- UNION یا UNION ALL

-- را از اینترنت دانلود کنید AdventureWorks2017 برای تست اسکریپت‌های زیر می‌بایست حتما دیتابیس
USE AdventureWorks2017;
GO

SELECT
	SalesOrderID,
	COUNT(SalesOrderID) AS Num 
FROM Sales.SalesOrderHeader
GROUP BY SalesOrderID
ORDER BY SalesOrderID, Num DESC; -- 31465
GO

SELECT
	BusinessEntityID,
	COUNT(BusinessEntityID) AS Num 
FROM Person.Person
GROUP BY BusinessEntityID
ORDER BY BusinessEntityID, Num DESC; -- 19972
GO

SET STATISTICS IO ON;
GO

SELECT
	SalesOrderID FROM Sales.SalesOrderHeader
UNION ALL
SELECT
	BusinessEntityID FROM Person.Person; -- 51437
GO

SELECT
	SalesOrderID FROM Sales.SalesOrderHeader
UNION
SELECT
	BusinessEntityID FROM Person.Person; -- 51437
GO