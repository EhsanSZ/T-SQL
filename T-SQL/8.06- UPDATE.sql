USE Test_DB;
GO

/*
UPDATE <table_name>
	SET column1 = value1,
		column2 = value2, ...
	WHERE condition;
*/

DROP TABLE IF EXISTS dbo.Customers1;
GO

SELECT * INTO dbo.Customers1
FROM dbo.Customers;
GO

SELECT * FROM dbo.Customers1;
GO

UPDATE dbo.Customers1
	SET CompanyName = CompanyName + '*';
GO

SELECT * FROM dbo.Customers1;
GO

UPDATE dbo.Customers1
	SET CompanyName = REPLACE(CompanyName,'*','');
GO

SELECT * FROM dbo.Customers1;
GO

UPDATE dbo.Customers1
	SET Region = N'مرکزی'
		WHERE Region = N'مرکز';
GO

SELECT * FROM dbo.Customers1;
GO

-- .فاقد شرط، تمامی رکوردها را به‌روزرسانی می‌کند UPDATE عملیات
UPDATE dbo.Customers1
	SET City = N'فاقد شهر',
		Region = N'فاقد شهر';
GO

SELECT * FROM dbo.Customers1;
GO
--------------------------------------------------------------------

/*
UPDATE & JOIN
*/

SELECT * FROM dbo.Customers1 AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID;
GO

UPDATE C
	SET CompanyName = CompanyName + '+'
FROM dbo.Customers1 AS C -- اشاره به نام مستعار
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID;
GO

SELECT * FROM dbo.Customers1;
GO

/*
Subquery بازنویسی کوئری بالا با استفاده از
*/
UPDATE C
	SET CompanyName = CompanyName + '+'
FROM dbo.Customers1 AS C
	WHERE EXISTS (SELECT 1 FROM Orders AS O
					WHERE C.CustomerID = O. CustomerID);
GO
--------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.UPDATE_Test;
GO

CREATE TABLE dbo.UPDATE_Test
(
	Col1 INT,
	Col2 INT
)
GO

INSERT INTO dbo.UPDATE_Test
	VALUES (1,100);
GO

SELECT * FROM dbo.UPDATE_Test;
GO

UPDATE dbo.UPDATE_Test
	SET Col1 = Col1 + 10,
		Col2 = Col1 + 10;
GO

SELECT * FROM dbo.UPDATE_Test;
GO

DELETE FROM dbo.UPDATE_Test;
GO

INSERT INTO dbo.UPDATE_Test
	VALUES (1,100);
GO

SELECT * FROM dbo.UPDATE_Test;
GO

-- جابه‌جایی مقادیر ستون‌ها
UPDATE dbo.UPDATE_Test
	SET Col1 = Col2,
		Col2 = Col1;
GO

SELECT * FROM dbo.UPDATE_Test;
GO

-------------------------------------------------------------------------------
/*
نکات تکمیلی در خصوص انواع عملیات دست‌کاری داده‌ها
*/


/*
DML روش‌های تشخیص داده‌های تاثیر پذیر قبل از عملیات

روش اول
جهت شناسایی رکوردها SELECT استفاده از دستور

روش دوم
Table Expression
*/

DROP TABLE IF EXISTS dbo.Odetails;
GO

SELECT * INTO dbo.Odetails FROM dbo.OrderDetails;
GO

UPDATE OD
	SET Discount += 0.05
FROM dbo.Odetails AS OD
	JOIN dbo.Orders AS O
		ON OD.OrderID = O.OrderID
		WHERE O.CustomerID = 1;
GO

-- CTE
WITH C AS
(
	SELECT
		O.CustomerID, OD.OrderID, Productid, Discount, Discount + 0.05 AS NewDiscount
	FROM dbo.Odetails AS OD
		JOIN dbo.Orders AS O
			ON OD.OrderID = O.OrderID
			WHERE O.CustomerID = 1
)
UPDATE C
	SET Discount = NewDiscount;
GO

-- Derived Table
UPDATE Tmp
	SET Discount = NewDiscount
FROM (SELECT
		CustomerID, OD.OrderID, Productid, Discount, Discount + 0.05 AS NewDiscount
	  FROM dbo.Odetails AS OD
		JOIN dbo.Orders AS O
			ON OD.OrderID = O.OrderID
			WHERE O.CustomerID = 1) AS Tmp;
GO
--------------------------------------------------------------------

/*
دست‌کاری داده‌های زیاد بر اساس دسته‌بندی

OFFSET و TOP عدم استفاده از قابلیت‌های
چرا که در عملیات دست‌کاری داده‌ها
.استفاده کرد ORDER BY نمی‌توان از
صرفا این عملیات براساس تعداد رکوردهایی که در 
.فرایند دست‌‌کاری تاثیر می‌پذیرند، انجام خواهد شد

Table Expression راه‌کار: استفاده از 
*/

DROP TABLE IF EXISTS dbo.Orders1;
GO

SELECT * INTO dbo.Orders1 FROM dbo.Orders;
GO

-- عملیات غیرمجاز
DELETE TOP(50) FROM dbo.Orders1
ORDER BY OrderID DESC;
GO

-- صرفا 50 رکورد حذف می‌شود
DELETE TOP(50) FROM dbo.Orders1;
GO

WITH CTE AS
(
	SELECT TOP(50) * FROM dbo.Orders1
	ORDER BY OrderID
)
DELETE FROM CTE;
GO

WITH CTE AS
(
	SELECT * FROM dbo.Orders1
	ORDER BY OrderID
	OFFSET 0 ROWS FETCH FIRST 50 ROWS ONLY
)
DELETE FROM CTE;
GO