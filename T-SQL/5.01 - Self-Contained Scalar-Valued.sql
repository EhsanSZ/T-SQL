
USE Test_DB;
GO

/*
WHERE مستقل در بخش Subquery
*/

-- TOP جدید‌ترین سفارش ثبت‌شده با استفاده از فیلتر
SELECT 
	TOP (1) EmployeeID,
	CustomerID,
	OrderID,
	MAX(OrderDate) AS NewOrders
FROM dbo.Orders
GROUP BY OrderID, OrderDate, EmployeeID, CustomerID
ORDER BY OrderID DESC;
GO

-- OFFSET جدید‌ترین سفارش ثبت‌شده با استفاده از فیلتر
SELECT
	EmployeeID,
	CustomerID,
	OrderID,
	MAX(OrderDate) AS NewOrders
FROM dbo.Orders
GROUP BY OrderID, OrderDate, EmployeeID, CustomerID
ORDER BY OrderID DESC
OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY;
GO

-- جدید‌ترین سفارش ثبت‌شده با استفاده از متغیر
--DECLARE @MaxID AS INT = (SELECT MAX(OrderID) FROM dbo.Orders);
--SELECT
--	EmployeeID, CustomerID, OrderID
--FROM dbo.Orders
--	WHERE OrderID = @MaxID;
--GO

-- مستقل Subquery جدید‌ترین سفارش ثبت‌شده با استفاده از
SELECT
	EmployeeID, CustomerID, OrderID, OrderDate
FROM dbo.Orders
	WHERE OrderID = (SELECT MAX(OrderID) FROM dbo.Orders);
GO
--------------------------------------------------------------------

/*
SELECT مستقل در بخش Subquery
*/

-- .تعداد سفارش مشتریانی که درخواست سفارش داشته‌اند
SELECT
	CustomerID,
	COUNT(OrderID) AS Num
FROM dbo.Orders
GROUP BY CustomerID;
GO

-- ???
-- تعداد سفارش هر مشتری به‌همراه تعداد کل سفارشات موجود
SELECT
	CustomerID,
	COUNT(OrderID) AS Num,
	SUM(COUNT(OrderID)) AS Total -- Cannot perform an aggregate function on an expression containing an aggregate or a subquery.
FROM dbo.Orders
GROUP BY CustomerID;
GO 

/*
نمایش تعداد سفارش‌های هر مشتری به‌همراه تعداد کل سفارشات تمامی مشتریان
*/

DECLARE @Num INT = (SELECT COUNT(OrderID) FROM dbo.Orders);
SELECT
	CustomerID,
	COUNT(OrderID) AS Num,
	@Num AS Total
FROM dbo.Orders
GROUP BY CustomerID;
GO

-- .مستقل Subquery تعداد سفارش هر مشتری به‌همراه تعداد کل سفارش ثبت‌شده با استفاده از
SELECT
	CustomerID,
	COUNT(OrderID) AS Num,
	(SELECT COUNT(OrderID) FROM dbo.Orders) AS Total
FROM dbo.Orders
GROUP BY CustomerID;
GO
--------------------------------------------------------------------

/*
کوئری‌ای بنویسید که علاوه بر تعداد سفارش ثبت‌شده توسط
هر کارمند، جدید‌ترین و قدیمی‌ترین سفارش ثبت‌شده در میان
.تمامی سفارشات از تمامی کارمندان را هم نمایش دهد
*/
-- مستقل Subquery با استفاده از
SELECT
	EmployeeID,
	COUNT(OrderID) AS Num,
	(SELECT MAX(OrderDate) FROM dbo.Orders) AS MaxOrders,
	(SELECT MIN(OrderDate) FROM dbo.Orders) AS MinOrders
FROM dbo.Orders
GROUP BY EmployeeID;
GO

-- بررسی تفاوت این کوئری با کوئری بالا
SELECT
	EmployeeID,
	COUNT(OrderID) AS Num,
	MAX(OrderDate) AS MaxOrders,
	MIN(OrderDate) AS MinOrders
FROM dbo.Orders
GROUP BY EmployeeID;
GO
--------------------------------------------------------------------

/*
:نکته بسیار مهم
.مستقل تک‌مقدار می‌بایست همواره فقط یک مقدار را برگرداند Subquery
*/

-- .کارمندانی که نام‌خانوادگی آن‌ها با حرف پ آغاز می‌شود
SELECT * FROM dbo.Employees
	WHERE LastName LIKE N'پ%';
GO

/*
تمامی سفارشات ثبت‌شده توسط کارمندانی که
.نام‌خانوادگی آن‌ها با کاراکتر 'پ' شروع شده باشد
JOIN با استفاده از
*/
SELECT
	O.OrderID
FROM dbo.Employees AS E
JOIN dbo.Orders AS O
	ON E.EmployeeID = O.EmployeeID
	WHERE LastName LIKE N'پ%';
GO
/*
تمامی سفارشات ثبت‌شده توسط کارمندانی که
.نام‌خانوادگی آن‌ها با کاراکتر 'پ' شروع شده باشد
مستقل تک‌مقدار Subquery با استفاده از
*/
SELECT
	OrderID
FROM dbo.Orders
	WHERE EmployeeID = (SELECT EmployeeID FROM dbo.Employees
							WHERE LastName LIKE N'پ%');
GO

-- .کارمندانی که نام‌خانوادگی آن‌ها با حرف ت آغاز می‌شود
SELECT * FROM dbo.Employees
	WHERE LastName LIKE N'ت%';
GO

/*
تمامی سفارشات ثبت‌شده توسط کارمندانی که
.نام‌خانوادگی آن‌ها با کاراکتر 'ت' شروع شده باشد
*/
SELECT
	OrderID
FROM dbo.Orders
	WHERE EmployeeID = (SELECT EmployeeID FROM dbo.Employees
							WHERE LastName LIKE N'ت%');
GO