
USE Test_DB;
GO

-- Accept TRUE
SELECT 
	CustomerID, State, Region, City
FROM dbo.Customers -- 91 Record
	WHERE Region = N'جنوب';
GO 

SELECT  -- 91 Record - 1 Record  = 90 Record
	CustomerID, State, Region, City
FROM dbo.Customers
	WHERE Region <> N'جنوب';
GO


-- !درست نیست NULL = NULL عبارت
SELECT 
	CustomerID, State, Region, City
FROM dbo.Customers
	WHERE Region = NULL;
GO

-- UNKNOWN بر روی مقادیر NOT عدم تاثیر
SELECT 
	CustomerID, State, Region, City
FROM dbo.Customers
	WHERE NOT (Region) = NULL;
GO


-- .است NULL آن‌ها برابر با Region فهرست مشتریانی که مقدار فیلد
SELECT 
	CustomerID, State, Region, City
FROM dbo.Customers
	WHERE Region IS NULL;
GO

-- .نیست NULL آن‌ها برابر با Region فهرست مشتریانی که مقدار فیلد
SELECT 
	CustomerID, State, Region, City
FROM dbo.Customers
	WHERE Region IS NOT NULL;
GO



-- .آن‌ها صرفا جنوب نیست Region فهرست مشتریانی که مقدار فیلد
SELECT 
	CustomerID, State, Region, City
FROM dbo.Customers
	WHERE Region <> N'جنوب'
	OR Region IS NULL;
GO

--------------------------------------------------------------------

/*
 ISNULL تابع
-- با یک مقدار مشخص NULL جایگزین کردن مقدار
ISNULL ( Check_Expression , Replacement_Value )
*/

DECLARE @str1 VARCHAR(100) = NULL;
SELECT  ISNULL(@str1,'AAAAAAAAAAA');
GO

-- .آن‌ها صرفا جنوب نیست Region فهرست مشتریانی که مقدار فیلد
SELECT 
	CustomerID, State, Region, City
FROM dbo.Customers
	WHERE ISNULL(Region, '') <> N'جنوب';
GO
--------------------------------------------------------------------

-- Reject False
DROP TABLE IF EXISTS ChkConstraint;
GO

CREATE TABLE ChkConstraint
(
	ID        INT NOT NULL IDENTITY,
	Family    NVARCHAR(100),
	Score	  INT CONSTRAINT CHK_Positive1 CHECK(Score >= 0)
);
GO

-- TRUE پذیرش مقدار
INSERT INTO dbo.ChkConstraint(Family, Score)  
	VALUES (N'سعیدی',100);
GO

-- NULL پذیرش مقدار
INSERT INTO dbo.ChkConstraint(Family)  
	VALUES (N'پرتوی');
GO

-- FALSE عدم پذیرش مقدار
INSERT INTO dbo.ChkConstraint(Family, Score)  
	VALUES (N'احمدی',-10);
GO

SELECT * FROM dbo.ChkConstraint;
GO
--------------------------------------------------------------------

-- All-at-Once عملیات
SELECT
	OrderID,
	YEAR(OrderDate) AS OrderYear,
	OrderYear + 1 AS NextYear
FROM dbo.Orders;
GO

SELECT
	OrderID,
	YEAR(OrderDate) AS OrderYear,
	YEAR(OrderDate) + 1 AS NextYear
FROM dbo.Orders;
GO