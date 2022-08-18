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