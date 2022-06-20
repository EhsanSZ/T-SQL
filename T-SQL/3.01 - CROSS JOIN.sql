
USE Test_DB;
GO


-- Customers\Employees تمامی ترکیبات دو تایی میان مشتریان و کارمندان
-- !کوئری توجه کن Plan به
SELECT
	CustomerID, EmployeeID
FROM dbo.Customers
CROSS JOIN dbo.Employees;
GO


-- Customers\Orders تمامی ترکیبات دو تایی میان کدهای مشتریان و کارمندان
/*
.ابهام در انتخاب فیلد مورد‌نظر چرا که در هر دو جدول وجود دارد
.استفاده کنید TableObject.FieldName برای جلوگیری از ابهام در تشابه نام ستون‌ها از الگوی
*/
SELECT
	CustomerID, EmployeeID
FROM dbo.Customers
CROSS JOIN dbo.Orders;
GO

-- Alias رفع مشکل کوئری بالا با استفاده از
SELECT
	C.CustomerID, O.EmployeeID
FROM dbo.Customers AS C
CROSS JOIN dbo.Orders AS O;
GO

SELECT
	C.CustomerID , Orders.EmployeeID -- O.EmployeeID
FROM dbo.Customers AS C
CROSS JOIN dbo.Orders AS O; -- توجه به نام دوبخشی
GO
--------------------------------------------------------------------

/*
CROSS JOIN: ANSI SQL-89

*/
-- تمامی ترکیبات دو تایی میان مشتریان و کارمندان
SELECT
	CustomerID, EmployeeID
FROM dbo.Customers,dbo.Employees;
GO
--------------------------------------------------------------------

-- CROSS JOIN استفاده از فیلترینگ در

-- ANSI SQL-92
SELECT
	CustomerID, EmployeeID
FROM dbo.Customers
CROSS JOIN dbo.Employees
	WHERE CustomerID > 90;
GO

-- ANSI SQL-89
SELECT
	CustomerID, EmployeeID
FROM dbo.Customers, dbo.Employees
	WHERE CustomerID > 90;
GO