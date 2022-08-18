USE Test_DB;
GO

/*
OUTER JOIN: ANSI SQL-92

SELECT 
	<SELECT list>
FROM <table1>
LEFT | RIGHT | FULL [OUTER] JOIN <table2>
*/

/*
LEFT | RIGHT [OUTER] JOIN
*/

-- .نمایش سفارش تمامی مشتریانی که ثبت سفارش داشته‌اند
SELECT
	C.CustomerID, C.CompanyName, O.OrderID
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
ORDER BY C.CustomerID;
GO

-- .نمایش سفارش تمامی مشتریان حتی آن‌هایی که سفارش نداشته‌اند
SELECT
	C.CustomerID, C.CompanyName, O.OrderID
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
ORDER BY C.CustomerID;
GO

-- .نمایش مشتریانی که سفارش نداشته‌اند
SELECT
	C.CustomerID, C.CompanyName
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
	WHERE O.OrderID IS NULL;
GO	

--------------------------------------------------------------------

-- CROSS JOIN عدم تاثیر ترتیب و جابجایی جداول در
SELECT
	E.FirstName, E.LastName, O.CustomerID
FROM dbo.Employees AS E
CROSS JOIN dbo.Orders AS O;
GO

SELECT
	E.FirstName, E.LastName, O.CustomerID
FROM dbo.Orders AS O
CROSS JOIN dbo.Employees AS E;
GO
--------------------------------------------------------------------

-- INNER JOIN عدم تاثیر ترتیب و جابجایی جداول در
SELECT
	C.CompanyName, O.OrderID
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID;
GO

SELECT
	C.CompanyName, O.OrderID
FROM dbo.Orders AS O
JOIN dbo.Customers AS C
	ON C.CustomerID = O.CustomerID;
GO
--------------------------------------------------------------------

-- OUTER JOIN تاثیر ترتیب و جابجایی جداول در
SELECT
	C.CompanyName, O.OrderID
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID;
GO

SELECT
	C.CompanyName, O.OrderID
FROM dbo.Orders AS O
LEFT JOIN dbo.Customers AS C
	ON C.CustomerID = O.CustomerID;
GO
--------------------------------------------------------------------

/*
JOIN همواره به‌دنبال پیدا کردن ترتیب اجرای بهینه Query Optimizer
.میان جداول است تا متناسب با آن از الگوریتم مناسبی هم استفاده کند
*/

USE AdventureWorks2017;
GO

-- Query1
SELECT * FROM Person.Person AS P
JOIN Person.PersonPhone AS PP
	ON P.BusinessEntityID = PP.BusinessEntityID 
JOIN Sales.SalesPerson AS SP
	ON SP.BusinessEntityID = P.BusinessEntityID;
GO

-- Query2
SELECT * FROM Person.Person AS P
JOIN Person.PersonPhone AS PP
	ON P.BusinessEntityID = PP.BusinessEntityID 
JOIN Sales.SalesPerson AS SP
	ON SP.BusinessEntityID = P.BusinessEntityID
OPTION(FORCE ORDER);
GO
--------------------------------------------------------------------

USE Test_DB;
GO

--.نمایش سفارش به‌همراه جزئیات آن از تمامی مشتریان حتی آن‌هایی که سفارش نداشته‌اند 

SELECT
	C.CustomerID, C.CompanyName,
	O.OrderID,
	OD.ProductID,
	OD.Qty
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
LEFT JOIN dbo.OrderDetails AS OD
	ON O.OrderID = OD.OrderID;
GO
--------------------------------------------------------------------

/*
در بهینه‌سازی کوئری Query Optimizer اجرایی و رفتار Plan بررسی
*/

-- .نمایش جزئیات سفارش مشتریانی که سفارش داشته‌اند
SELECT
	C.CustomerID,
	O.OrderID,
	OD.ProductID, OD.Qty
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
JOIN dbo.OrderDetails AS OD
	ON O.OrderID = OD.OrderID
ORDER BY C.CustomerID;
GO

SELECT
	C.CustomerID,
	O.OrderID,
	OD.ProductID,
	OD.Qty
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
JOIN dbo.OrderDetails AS OD
	ON O.OrderID = OD.OrderID
ORDER BY C.CustomerID;
GO
--------------------------------------------------------------------

-- نمایش جزئیات سفارش تمامی مشتریان حتی آن‌هایی که سفارش هم نداشته‌اند به 3 روش
SELECT 
	C.CustomerID,
	O.OrderID,
	OD.ProductID,
	OD.Qty
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
LEFT JOIN dbo.OrderDetails AS OD
	ON O.OrderID = OD.OrderID;
GO

SELECT
	C.CustomerID,
	O.OrderID,
	OD.ProductID,
	OD.Qty
FROM dbo.Orders AS O
JOIN dbo.OrderDetails AS OD
	ON O.OrderID = OD.OrderID
RIGHT JOIN dbo.Customers AS C
		ON O.CustomerID = C.CustomerID;
GO

SELECT
	C.CustomerID,
	O.OrderID,
	OD.ProductID,
	OD.Qty
FROM dbo.Customers AS C
LEFT JOIN
	(dbo.Orders AS O
	 JOIN dbo.OrderDetails AS OD
		ON O.OrderID = OD.OrderID)
	ON C.CustomerID = O.CustomerID;
GO
--------------------------------------------------------------------

-- JOIN در COUNT بررسی رفتار
SELECT 
	C.CustomerID,
	COUNT(*) AS Num
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID
ORDER BY C.CustomerID;
GO

SELECT 
	C.CustomerID,
	COUNT(OrderID) AS Num
FROM dbo.Customers AS C
LEFT JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID
ORDER BY C.CustomerID;
GO
--------------------------------------------------------------------

/*
FULL [OUTER] JOIN
*/

DROP TABLE IF EXISTS dbo.Personnel, dbo.PersonnelTyp;
GO

CREATE TABLE dbo.Personnel
(
	ID INT IDENTITY,
	Family NVARCHAR(50),
	Typ NVARCHAR(20)
);
GO

CREATE TABLE dbo.PersonnelTyp
(
	ID INT IDENTITY,
	Title NVARCHAR(20)
);
GO

INSERT INTO dbo.Personnel
VALUES
	(N'احمدی',N'مدیر عامل'),
	(N'تقوی',N'سرپرست'),
	(N'سعادت',N'مدیر'),
	(N'جعفری',N'نامشخص');
GO

INSERT INTO dbo.PersonnelTyp
VALUES
	(N'مدیر عامل'),
	(N'مدیر'),
	(N'سرپرست'),
	(N'کارشناس'),
	(N'تکنسین');
GO

SELECT
	P.Family, PT.Title
FROM dbo.Personnel AS P
FULL OUTER JOIN dbo.PersonnelTyp AS PT
	ON P.Typ = PT.Title;
GO
--------------------------------------------------------------------

/*
JOIN در انواع NULL با مقادیر SQL Server رفتار
*/

DROP TABLE IF EXISTS J1,J2;
GO

CREATE TABLE J1
(
	ID INT
);
GO

CREATE TABLE J2
(
	ID INT,
	Title VARCHAR(10)
);
GO

INSERT J1
VALUES
	(1),
	(2),
	(NULL),
	(NULL);
GO

INSERT J2 
VALUES
	(1,'One'),
	(2,'Two'),
	(NULL,'Three');
GO

SELECT * FROM J1;
SELECT * FROM J2;
GO

-- زیر JOIN خروجی حاصل از
SELECT
	J1.ID, J2.Title
FROM J1
CROSS JOIN J2;
GO
/*
.شرکت می‌دهد JOIN آن‌ها را در NULL در کوئری بالا به‌ازای هر تعداد
.شرکت می‌دهد JOIN هم رفتار جداگانه داشته و هر بار آن‌ها را در NULL حتی با هر مقدار
*/

-- زیر چیست؟ JOIN خروجی حاصل از
SELECT
	J1.ID, J2.Title
FROM J1
JOIN J2
	ON J1.ID = J2.ID;
GO
/*
.می‌باشد Accept TRUE ریزش خواهند داشت چرا که در این‌جا منطق ON در بخش NULL در کوئری بالا مقادیر
*/
		
-- زیر JOIN خروجی حاصل از
SELECT
	J1.ID, J2.Title
FROM J1
LEFT JOIN J2
	ON J1.ID = J2.ID;
GO
/*
.‌می‌شوند Preserve به‌ هر تعداد NULL در کوئری بالا مقادیر
*/