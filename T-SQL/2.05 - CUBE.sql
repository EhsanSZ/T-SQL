/*
CUBE

CUBE (A,B,C):
(A,B,C)
(A,B)
(A,C)
(B,C)
(A)
(B)
(C)
()

*/

USE Test_DB;
GO

-- نمایش مشتریان و تعداد سفارشات آن‌ها و سرجمع نهایی به‌ازای گروه‌های مختلف
SELECT
	CustomerID,
	COUNT(OrderID) AS Num
FROM dbo.Orders
GROUP BY CustomerID WITH CUBE;
GO

-- روش دیگر نوشتن کوئری بالا
SELECT
	CustomerID,
	COUNT(OrderID) AS Num
FROM dbo.Orders
GROUP BY CUBE (CustomerID);
GO

-- نمایش تعداد سفارشات هر کارمند به‌تفکیک سال و ماه و سرجمع نهایی به‌ازای گروه‌های مختلف
SELECT
	EmployeeID,
	YEAR(OrderDate) AS OrderYear,
	MONTH(OrderDate) AS OrderMonth,
	COUNT(OrderID) AS Num
FROM dbo.Orders
GROUP BY CUBE (EmployeeID, YEAR(OrderDate), MONTH(OrderDate)) 
ORDER BY EmployeeID;
GO
--------------------------------------------------------------------

/*
GROUPING کاربرد
CUBE تشخیص سطرهای حاصل از
تشخیص فیلدهای غایب در گروه‌بندی
*/

-- گروه‌بندی تک سطحی
SELECT
	CustomerID,
	COUNT(OrderID) AS Num,
	GROUPING (CustomerID) AS GROUPING_CustomerID
FROM dbo.Orders
GROUP BY CustomerID WITH CUBE;
GO

-- گروه‌بندی چند سطحی
SELECT
	EmployeeID,
	YEAR(OrderDate) AS OrderYear,
	MONTH(OrderDate) AS OrderMonth,
	COUNT(OrderID) AS Num,
	GROUPING (EmployeeID) AS GROUPING_EmployeeID,
	GROUPING (YEAR(OrderDate)) AS GROUPING_Year,
	GROUPING (MONTH(OrderDate)) AS GROUPING_Month
FROM dbo.Orders
GROUP BY CUBE(EmployeeID, YEAR(OrderDate), MONTH(OrderDate));
GO