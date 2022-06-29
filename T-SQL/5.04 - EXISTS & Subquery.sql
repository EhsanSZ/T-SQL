
USE Test_DB;
GO

/*
EXISTS in Subquery
حداقل شامل یک EXISTS در صورتی‌که خروجی
.رکورد باشد آن‌گاه کوئری بیرونی اجرا خواهد شد
*/

-- Orders نمایش لیست تمامی سفارشات موجود در جدول
SELECT * FROM dbo.Orders
	WHERE EXISTS (SELECT 1 FROM dbo.Customers
					WHERE City = N'تهران');-- شامل چندین رکورد EXISTS خروجی
GO

-- Orders نمایش لیست تمامی سفارشات موجود در جدول
SELECT * FROM dbo.Orders
	WHERE EXISTS (SELECT 1 FROM dbo.Customers
					WHERE City = N'بیرجند');-- شامل 1 رکورد EXISTS خروجی
GO

-- Orders عدم نمایش حتی 1 رکورد از جدول
SELECT * FROM dbo.Orders
	WHERE EXISTS (SELECT 1 FROM dbo.Customers
					WHERE City = N'کرج');-- فاقد رکورد EXISTS خروجی
GO

-- Orders نمایش لیست تمامی سفارشات موجود در جدول
SELECT * FROM dbo.Orders
	WHERE NOT EXISTS (SELECT 1 FROM dbo.Customers
						WHERE City = N'کرج');-- فاقد رکورد EXISTS خروجی
GO
--------------------------------------------------------------------

-- نمایش اطلاعات تمامی مشتریان دارای سفارش
SELECT * FROM dbo.Customers AS C
	WHERE EXISTS (SELECT 1 FROM dbo.Orders AS O
					WHERE C.CustomerID = O.CustomerID);
GO

-- نمایش اطلاعات تمامی مشتریان فاقد سفارش
SELECT * FROM dbo.Customers AS C
	WHERE NOT EXISTS (SELECT 1 FROM dbo.Orders AS O
					WHERE C.CustomerID = O.CustomerID);
GO
--------------------------------------------------------------------

SELECT * FROM dbo.Orders
	WHERE CustomerID = 18
ORDER BY CustomerID;
GO

/*
نمایش نام و نام‌خانوادگی کارمندانی که
.با مشتری شماره 18 ثبت سفارش داشته‌اند
*/

-- JOIN با استفاده از
SELECT
	E.FirstName, E.LastName
FROM dbo.Employees AS E
JOIN dbo.Orders AS O
	ON E.EmployeeID = O.EmployeeID
	WHERE O.CustomerID = 18;
GO

-- رفع ایراد کوئری بالا 
SELECT
	DISTINCT E.FirstName, E.LastName
FROM dbo.Employees AS E
JOIN dbo.Orders AS O
	ON E.EmployeeID = O.EmployeeID
	WHERE O.CustomerID = 18;
GO

-- IN با استفاده از
SELECT
	E.FirstName, E.LastName
FROM dbo.Employees AS E
	WHERE E.EmployeeID IN (SELECT O.EmployeeID FROM dbo.Orders AS O
								WHERE O.CustomerID = 18);
GO

-- EXISTS با استفاده از
SELECT
	E.FirstName, E.LastName
FROM dbo.Employees AS E
	WHERE EXISTS (SELECT 1 FROM dbo.Orders AS O
					WHERE O.CustomerID = 18
					AND E.EmployeeID = O.EmployeeID);
GO

-- غلط است
SELECT
	E.FirstName, E.LastName
FROM dbo.Employees AS E
	WHERE EXISTS (SELECT 1 FROM dbo.Orders AS O
					WHERE  O.CustomerID = 18);
GO
--------------------------------------------------------------------

/*
EXISTS & 2VL
*/

SELECT * FROM dbo.Customers 
	WHERE EXISTS (SELECT Region FROM dbo.Customers
					WHERE Region IS NULL);
GO

SELECT * FROM dbo.Customers 
	WHERE NOT EXISTS (SELECT Region FROM dbo.customers
						WHERE Region IS NULL);
GO
--------------------------------------------------------------------

/*
.نمایش لیست مشتریانی که از استان زنجان هستند و سفارش هم داشته‌اند
*/

-- JOIN با استفاده از


-- رفع ایراد کوئری بالا 


-- Subquery و شرط، داخل IN با استفاده از


-- Subquery و شرط، خارج IN با استفاده از


-- Subquery و شرط، داخل EXISTS با استفاده از


-- Subquery و شرط، خارج EXISTS با استفاده از


-- EXISTS در Correlated در صورت عدم استفاده از
SELECT
	C.CustomerID
FROM dbo.Customers AS C
	WHERE EXISTS (SELECT * FROM dbo.Orders AS O
					WHERE C.State = N'زنجان');
GO