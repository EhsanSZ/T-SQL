
USE Test_DB;
GO

-- تمامی سفارشات درخواست‌شده از مشتری 1 یا 2 به‌تفکیک هر کارمند-مشتری
SELECT 
	EmployeeID,
	CustomerID,
	COUNT(OrderID) AS Num
FROM dbo.Orders
	WHERE CustomerID = 1 
	   OR CustomerID = 2
GROUP BY EmployeeID, CustomerID;
GO

-- نمایش تمامی سفارشات مشتری 1 یا 2 به‌تفکیک هر سال
SELECT
	CustomerID, 
	YEAR(OrderDate) AS OrderYear,
	COUNT(OrderID) AS Num
FROM dbo.Orders
	WHERE CustomerID = 1
	   OR CustomerID = 2
GROUP BY CustomerID, YEAR(OrderDate);
GO

-- نمایش تمامی سفارشات ثبت‌شده توسط کارمندان با مشتری 1 یا 2 و به تفکیک هر سال
SELECT
	EmployeeID, 
	YEAR(OrderDate) AS OrderYear,
	COUNT(OrderID) AS Num
FROM dbo.Orders
	WHERE CustomerID = 1 
	   OR CustomerID = 2
GROUP BY EmployeeID, YEAR(OrderDate);
GO
--------------------------------------------------------------------

/*
GROUPING SETS
*/ 

-- GROUPING SETS معادل تمامی کوئری‌های بالا با استفاده از
SELECT 	
	EmployeeID,
	CustomerID,
	YEAR(OrderDate) AS OrderYear,
	COUNT(OrderID) AS Num
FROM dbo.Orders
	WHERE CustomerID=1 
	   OR CustomerID=2
GROUP BY GROUPING SETs 
	(
		(EmployeeID,CustomerID),
		(EmployeeID,YEAR(OrderDate)),
		(CustomerID,YEAR(OrderDate))
	);
GO
/*
:تذکر مهم
(Aggregate Columns) آمده‌اند به‌جز SELECT تمامی فیلدهایی که جلو
شرکت داشته باشند GROUPING SETS می‌بایست به‌نوعی در ترکیب
*/
GO
--------------------------------------------------------------------

-- GROUPING SETS مرتب‌سازی سفارشی رکوردها هنگام استفاده از 
SELECT 	
	EmployeeID,
	CustomerID,
	YEAR(OrderDate) AS OrderYear,
	COUNT(OrderID) AS Num
FROM dbo.Orders
	WHERE CustomerID = 1 
	   OR CustomerID = 2
GROUP BY GROUPING SETS 
	(
		(EmployeeID,CustomerID),
		(EmployeeID,YEAR(OrderDate)),
		(CustomerID,YEAR(OrderDate))
	)
ORDER BY
	CASE
		WHEN YEAR(OrderDate) IS NULL THEN 1
		WHEN EmployeeID IS NULL THEN 2
		WHEN CustomerID IS NULL THEN 3
	END
GO
--------------------------------------------------------------------

/*
Grouping_ID
با استفاده از این تابع می توان فهمید که گروه‌بندی به‌ازای
کدامیک از ستون ها انجام شده و چه فیلدی در نتیجه‌نهایی غایب است

--ارزش بیتی

GROUPING_ID(EmployeeID, CustomerID, YEAR(OrderDate))
				2^2		   2^1			 2^0
*/

SELECT 	
	EmployeeID,
	CustomerID,
	YEAR(OrderDate) AS OrderYear,
	GROUPING_ID(EmployeeID, CustomerID, YEAR(OrderDate)) AS GROUPING_ID_Field
FROM dbo.Orders
	WHERE CustomerID = 1 
	   OR CustomerID = 2
GROUP BY GROUPING SETS 
	(
		(EmployeeID,CustomerID),
		(EmployeeID,YEAR(OrderDate)),
		(CustomerID,YEAR(OrderDate))
	)
	ORDER BY GROUPING_ID_Field;
GO

-- CASE مرتب‌سازی بهتر کوئری بالا با استفاده از
SELECT 	
	EmployeeID,
	CustomerID,
	YEAR(OrderDate) AS OrderYear,
	COUNT(OrderID) AS Num,
	CASE GROUPING_ID(EmployeeID, CustomerID, YEAR(OrderDate))
		WHEN 4 THEN N'مشتری و سال'
		WHEN 2 THEN N'کارمند و سال'
		WHEN 1 THEN N'کارمند و مشتری'
	END AS N'گروه بندی بر اساس'
FROM Orders
	WHERE CustomerID=1 
	   OR CustomerID=2
GROUP BY GROUPING SETS 
	(
		(EmployeeID,CustomerID),
		(EmployeeID,YEAR(OrderDate)),
		(CustomerID,YEAR(OrderDate))
	);
GO