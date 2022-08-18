
USE Test_DB;
GO

/*
INNER JOIN: ANSI SQL-92

*/

-- .نمایش نام و نام‌خانوادگی هر کارمند و کد سفارشاتی که ثبت‌ کرده است 
SELECT
	E.FirstName, E.LastName,
	O.OrderID
FROM dbo.Employees AS E
JOIN dbo.Orders AS O
	ON E.EmployeeID = O.EmployeeID;
GO

-- .کوئری بالا با شرط این‌که نام‌خانوادگی با حرف الف شروع نشده باشد
SELECT
	E.FirstName, E.LastName,
	O.OrderID
FROM dbo.Employees AS E
JOIN dbo.Orders AS O
	ON E.EmployeeID = O.EmployeeID
	WHERE E.LastName LIKE N'[^ا]%';
GO
--------------------------------------------------------------------

/*
INNER JOIN: ANSI SQL-89
*/

-- .نمایش نام و نام‌خانوادگی هر کارمند و سفارشاتی که ثبت‌ کرده است 
SELECT
	E.FirstName, E.LastName,
	O.OrderID
FROM dbo.Employees AS E, dbo.Orders AS O
	WHERE E.EmployeeID = O.EmployeeID;
GO
--------------------------------------------------------------------

/*
AN SI SQL-92 دلیل استفاده از استاندارد
*/

-- Query With ANSI SQL-92
SELECT
	E.EmployeeID, E.FirstName, E.LastName, O.orderid
FROM dbo.Employees AS E
JOIN dbo.Orders AS O; -- ON فاقد بخش
GO

-- Query With ANSI SQL-89
SELECT
	E.EmployeeID, E.FirstName, E.LastName, O.orderid
FROM dbo.Employees AS E, dbo.Orders AS O
	 WHERE E.EmployeeID = O.EmployeeID; -- نوشته‌ایم CROSS JOIN کوئری اجرا خواهد شد چرا که انگار به‌صورت WHERE در صورت نادیده گرفتن بخش
GO
--------------------------------------------------------------------
/*
کوئری‌ای که شامل فهرست شهرهای مشتریانی باشد
.که بیش از 50 سفارش در سیستم ثبت کرده باشند
*/
SELECT
	C.City,
	COUNT(O.OrderID) AS Num
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
GROUP BY C.City
	HAVING COUNT(O.OrderID) > 50;
GO
--------------------------------------------------------------------
/*
از کدام شهر کمترین ثبت سفارش را داشته‌ایم؟ 
.در خروجی تعداد سفارش آن‌ هم نمایش داده شود
*/
SELECT
	TOP (1) WITH TIES C.City,
	COUNT(O.OrderID) AS Num
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
GROUP BY C.City
ORDER BY Num;
GO
--------------------------------------------------------------------
/*
کوئری‌ای بنویسید تا 3 محصولی که بیشترین فروش
.را از آن‌ها داشته‌ایم در خروجی نمایش دهد
*/
SELECT
	TOP (3) WITH TIES P.ProductName,
	SUM(OD.Qty) AS Total
FROM dbo.Products AS P
JOIN dbo.OrderDetails AS OD
	ON P.ProductID = OD.ProductID
GROUP BY P.ProductName
ORDER BY Total DESC;
GO