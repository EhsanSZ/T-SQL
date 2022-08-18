USE Test_DB;
GO

DROP TABLE IF EXISTS dbo.OUTPUT_Insert;
GO

CREATE TABLE dbo.OUTPUT_Insert
(
	ID INT IDENTITY,
	City NVARCHAR(20)	
);
GO

INSERT INTO dbo.OUTPUT_Insert
	VALUES (N'تهران'),(N'مشهد'),(N'تبریز'),(N'شیراز'),(N'اصفهان');
GO

SELECT @@IDENTITY, SCOPE_IDENTITY(), IDENT_CURRENT('dbo.OUTPUT_Insert');
GO

INSERT INTO dbo.OUTPUT_Insert
		OUTPUT
		inserted.ID
	VALUES (N'اهواز'),(N'کرمان'),(N'رشت');
GO

/*
OUTPUT ذخیره نتایج
جدول مورد‌نظر می‌بایست از قبل وجود داشته باشد
*/

CREATE TABLE #OUTPUT_Tbl
(
	ID INT
);
GO

INSERT INTO dbo.OUTPUT_Insert
		OUTPUT -- در جدول موردنظر OUTPUT جهت ذخیره خروجی
		inserted.ID INTO #OUTPUT_Tbl 
		OUTPUT -- در خروجی OUTPUT جهت نمایش محتویات
		inserted.ID
	VALUES (N'اهواز'),(N'کرمان'),(N'رشت');
GO

SELECT * FROM #OUTPUT_Tbl;
GO
--------------------------------------------------------------------

/*
OUTPUT & DELETE
*/

DROP TABLE IF EXISTS dbo.OUTPUT_Delete;
GO

SELECT * INTO dbo.OUTPUT_Delete
FROM dbo.Orders;
GO

DELETE FROM dbo.OUTPUT_Delete
		OUTPUT
			deleted.OrderID,
			deleted.OrderDate,
			deleted.CustomerID
	WHERE OrderDate >= '2016-02-06';
GO
--------------------------------------------------------------------

/*
OUTPUT & UPDATE
*/

DROP TABLE IF EXISTS dbo.OUTPUT_Update;
GO

SELECT * INTO dbo.OUTPUT_Update
FROM dbo.Employees;
GO

UPDATE dbo.OUTPUT_Update
	SET Region = N'مرکزی'
		OUTPUT
		inserted.Region AS NewVal,
		deleted.Region AS OldVal
	WHERE Region = N'مرکز';
GO
--------------------------------------------------------------------

/*
OUTPUT & MERGE
*/

DROP TABLE IF EXISTS dbo.S_Customers,dbo.T_Customers;
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
			(3, N'شرکت اصفهان 1', N'اصفهان', '(031) 333-33333'), -- بدون تغییر
			(5, N'شرکت مشهد 1', N'مشهد', '(051) 555-0000'), -- تغییر یافته
			(6, N'شرکت مشهد 2', N'مشهد', '(051) 555-1111'), -- جدید
			(7, N'شرکت اصفهان 1', N'اصفهان', '(031) 333-1111');-- جدید
GO

SELECT * FROM dbo.S_Customers;
SELECT * FROM dbo.T_Customers;

MERGE INTO dbo.T_Customers AS T
USING dbo.S_Customers AS S
	ON T.CustomerID = S.CustomerID
WHEN MATCHED THEN
UPDATE
	SET	T.CompanyName = S.CompaNyname,
		T.phone = S.Phone,
		T.City = S.City
WHEN NOT MATCHED THEN
INSERT (CustomerID, CompanyName, Phone, City)
VALUES
	(S.CustomerID, S.CompanyName, S.Phone, S.City)
OUTPUT
	$ACTION AS Act,
	deleted.CompanyName AS Old_Value,
	inserted.CompanyName AS New_Value,
	inserted.CustomerID;
GO