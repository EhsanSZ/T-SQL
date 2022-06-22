
USE Test_DB;
GO

/*
INTERSECT
*/

SELECT
	 State, Region, City FROM dbo.Employees
--INTERSECT
SELECT
	 State, Region, City FROM dbo.Customers;
GO
--------------------------------------------------------------------

/*
JOIN با استفاده از INTERSECT شبیه‌سازی

نمایش مقادیر مشترک استان/منطقه/شهر  JOIN با استفاده از
  Customers و Employees میان جداول
*/

SELECT * FROM dbo.Customers 
	WHERE State  = N'تهران' 
	AND	  City   = N'تهران' 
	AND   Region = N'مرکز'; 
GO

SELECT * FROM dbo.Employees 
	WHERE State  = N'تهران' 
	AND   City   = N'تهران' 
	AND   Region = N'مرکز'; 
GO

SELECT
	DISTINCT C.State, C.Region, C.City
FROM dbo.Customers AS C
JOIN dbo.Employees AS E
	ON C.State = E.State
	AND C.City = E.City
	AND C.Region = E.Region;
GO

-- JOIN و INTERSECT مقایسه میان روش
SET STATISTICS IO ON;
GO

-- JOIN
SELECT 
	DISTINCT E.State, E.Region, E.City
FROM HR.Employees AS E
JOIN Sales.Customers AS C
	ON E.State = C.State
	AND E.Region = C.Region
	AND E.City = C.City;
GO

-- INTERSECT
SELECT
	 State, Region, City FROM HR.Employees
INTERSECT
SELECT
	 State, Region, City FROM Sales.Customers;
GO
--------------------------------------------------------------------

-- NULL بررسی رفتار
DROP TABLE IF EXISTS IntersectTbl1,IntersectTb2;
GO

CREATE TABLE IntersectTbl1
(
	State NVARCHAR(20),
	City NVARCHAR(20)
);
GO

CREATE TABLE IntersectTb2
(
	State NVARCHAR(20),
	City NVARCHAR(20)
);
GO

INSERT INTO IntersectTbl1
VALUES 
	(N'تهران',N'تهران'),
	(N'گیلان',NULL),
	(N'خوزستان',N'اهواز'),
	(NULL,N'اصفهان');
GO

INSERT INTO IntersectTb2
VALUES
	(N'تهران',N'تهران'),
	(N'گیلان',NULL),
	(N'آذربایجان شرقی',N'تبریز'),
	(NULL,N'مشهد');
GO

SELECT * FROM IntersectTbl1
INTERSECT
SELECT * FROM IntersectTb2;
GO

-- INNER JOIN پیاده‌سازی کوئری بالا با استفاده از
SELECT I1.*
FROM IntersectTbl1 AS I1
JOIN IntersectTb2 AS I2
	ON I1.State = I2.State;
GO