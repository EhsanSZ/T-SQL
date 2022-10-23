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

--------------------------------------------------

                   --MERGE

--------------------------------------------------
USE Test_DB;
GO

DROP TABLE IF EXISTS dbo.S_Customers, dbo.T_Customers;
GO

-- Target جدول
CREATE TABLE dbo.T_Customers
(
	CustomerID INT NOT NULL PRIMARY KEY,
	CompanyName NVARCHAR(25) NOT NULL,
	City NVARCHAR(20) NOT NULL,
	Phone VARCHAR(15) NOT NULL
);
GO

-- Source جدول
CREATE TABLE dbo.S_Customers
(
	CustomerID INT NOT NULL PRIMARY KEY,
	CompanyName NVARCHAR(25) NOT NULL,
	City NVARCHAR(20) NOT NULL,
	Phone VARCHAR(15) NOT NULL
);
GO

INSERT INTO dbo.T_Customers
	VALUES	(1, N'شرکت تهران 1', N'تهران', '(021) 222-1111'),
			(2, N'شرکت تهران 2', N'تهران', '(021) 222-2222'),
			(3, N'شرکت اصفهان 1', N'اصفهان', '(031) 333-1111'),
			(4, N'شرکت شیراز 1', N'شیراز', '(071) 777-1111'),
			(5, N'شرکت مشهد 1', N'مشهد', '(051) 555-1111');
GO

INSERT INTO dbo.S_Customers
	VALUES	(2, N'شرکت پردیس', N'پردیس', '(021) 222-2222'), -- تغییر یافته
			(3, N'شرکت اصفهان 1', N'اصفهان', '(031) 333-1111'), -- بدون تغییر
			(5, N'شرکت مشهد 1', N'مشهد', '(051) 555-0000'), -- تغییر یافته
			(6, N'شرکت مشهد 2', N'مشهد', '(051) 555-1111'), -- جدید
			(7, N'شرکت اصفهان 1', N'اصفهان', '(031) 333-1111');-- جدید
GO

/*
سناریو
T_Customers می‌خواهیم اطلاعات مشتریانی را که در جدول
.به آن اضافه کنیم S_Customers وجود ندارند، از جدول 

ضمنا می‌خواهیم به‌ازای رکوردهای مشابه در این دو جدول
.نیز انجام شود T_Customers عملیات به‌روزرسانی مقادیر فیلدهای جدول
*/

/*
MERGE <Target_TableName>
USING <Source_TableName>
	ON Predicate
WHEN MATCHED THEN -- تطابق داشته باشد T با رکورد جدول S زمانی که رکورد جدول
	UPDATE | DELETE
WHEN NOT MATCHED THEN -- تطابق نداشته باشد T با رکورد جدول S زمانی که رکورد جدول
	INSERT
WHEN NOT MATCHED BY SOURCE THEN -- تطابق نداشته باشد S با رکورد جدول T زمانی که رکورد جدول
	DELETE;
*/

SELECT * FROM dbo.T_Customers;
GO

MERGE INTO dbo.T_Customers AS T -- TARGET جدول
USING dbo.S_Customers AS S -- Source جدول
	ON T.CustomerID = S.CustomerID
WHEN MATCHED THEN -- تطابق داشته باشد T با رکورد جدول S زمانی که رکورد جدول
UPDATE
	SET	T.CompanyName = S.CompaNyname,
		T.phone = S.Phone,
		T.City = S.City
WHEN NOT MATCHED THEN -- تطابق نداشته باشد T با رکورد جدول S زمانی که رکورد جدول
INSERT (CustomerID, CompanyName, Phone, City)
VALUES (S.CustomerID, S.CompanyName, S.Phone, S.City); /*خاتمه این دستور حتما باید با سمی کولن باشد*/
GO

SELECT * FROM dbo.S_Customers;
SELECT * FROM dbo.T_Customers;
GO
-------------------------------------------------------------------

/*
SQL Server قابلیت اضافی در
WHEN NOT MATCHED BY SOURCE THEN
*/

SELECT * FROM dbo.T_Customers;
GO

MERGE INTO dbo.T_Customers AS T
USING dbo.S_Customers AS S
	ON T.CustomerID = S.CustomerID
WHEN NOT MATCHED BY SOURCE THEN -- تطابق نداشته باشد S با رکورد جدول T زمانی که رکورد جدول
	DELETE;
GO

SELECT * FROM dbo.S_Customers;
SELECT * FROM dbo.T_Customers;
GO