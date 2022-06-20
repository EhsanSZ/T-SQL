
USE Test_DB;
GO
 
--------------------------------------------------------------------

/*
 گروه‌بندی تک سطحی
*/

-- تعداد سفارش هر مشتری
-- GROUP BY Columns: CustomerID
-- Aggregate Columns: OrderID
SELECT
	CustomerID,
	COUNT(OrderID) AS Num
FROM dbo.Orders
GROUP BY CustomerID;
GO

-- تعداد سفارش هر مشتری و جدیدترین سفارشش
-- GROUP BY Columns: CustomerID
-- Aggregate Columns: OrderID \ OrderDate
SELECT
	CustomerID,
	COUNT(OrderID) AS Num,
	MAX(OrderDate) AS NewOrder
FROM dbo.Orders
GROUP BY CustomerID;
GO
--------------------------------------------------------------------

/*
گروه‌بندی چند سطحی
*/
-- از هر استان-شهر چه تعداد مشتری داریم
-- GROUP BY Columns: State, City
-- Aggregate Columns: CustomerID
SELECT
	State, City,
	COUNT(CustomerID) AS Num
FROM dbo.Customers
GROUP BY State, City;
GO
--------------------------------------------------------------------

/*
سفارشات هر کارمند به تفکیک هر سال که شامل تعداد کل سفارش و مجموع کرایه‌های ثبت شده
*/

SELECT
	EmployeeID, YEAR(OrderDate) AS OrderYear,
	COUNT(OrderID) AS NUM,
	SUM(Freight) AS Rate
FROM dbo.Orders
GROUP BY EmployeeID, YEAR(OrderDate)
ORDER BY EmployeeID;
GO