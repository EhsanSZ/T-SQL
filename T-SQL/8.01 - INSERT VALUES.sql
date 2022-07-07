USE Test_DB;
GO

/*
INSERT INTO <table_name> (column1, column2, column3, ...)
	VALUES (value1, value2, value3, ...);
*/

DROP TABLE IF EXISTS dbo.Insert_Val1;
GO

CREATE TABLE dbo.Insert_Val1
(
	ID INT,
	Family NVARCHAR(50),
	City NVARCHAR(20),
	DateRegister DATE
);
GO

-- .فقط امکان درج یک رکورد در هر لحظه وجود داشت SQL 2008 تا قبل از
INSERT INTO dbo.Insert_Val1 (ID, Family, City, DateRegister)
	VALUES	(1, N'احمدی', N'تهران', '2019-01-01');
GO


SELECT * FROM dbo.Insert_Val1;
GO

/*
Table Value Constructor
.به‌بعد امکان درج بیش از یک رکورد در هر لحظه فراهم شد SQL 2008 از
*/
INSERT INTO dbo.Insert_Val1(ID, Family, City, DateRegister)
	VALUES	(2, N'محمدی', N'شیراز', '20150211'),
			(3, N'اکبری', N'تبریز', GETDATE());
GO

SELECT * FROM dbo.Insert_Val1;
GO

-- .این فرایند اتمیک است
INSERT INTO dbo.Insert_Val1
	VALUES	(4, N'شادکام', N'اراک', '20150211'),
			(5, N'خسروی', N'ایلام', 'ABCD');
GO

SELECT * FROM dbo.Insert_Val1;
GO
--------------------------------------------------------------------

/*
INSERT در عملیات DEFAULT و NULL بررسی مقادیر
*/

DROP TABLE IF EXISTS dbo.Insert_Val2;
GO

CREATE TABLE dbo.Insert_Val2
(
	ID INT NOT NULL,
	Family NVARCHAR(50) NOT NULL,
	City NVARCHAR(20),
	DateRegister DATE DEFAULT GETDATE()
);
GO

INSERT INTO dbo.Insert_Val2 (ID, Family) -- !حتما در این حالت باید نام فیلدها ذکر شود
	VALUES	(1, N'پرتوی');
GO

SELECT * FROM dbo.Insert_Val2;
GO

INSERT INTO dbo.Insert_Val2
	VALUES	(2, N'سعادت', DEFAULT, DEFAULT);
GO

SELECT * FROM dbo.Insert_Val2;
GO
--------------------------------------------------------------------

/*
INSERT عملیات غیر مجاز
*/

DROP TABLE IF EXISTS dbo.Insert_Val3;
GO

CREATE TABLE dbo.Insert_Val3
(
	ID TINYINT,
	Family NVARCHAR(50),
	City NVARCHAR(10),
	DateRegister DATE
);
GO

INSERT INTO dbo.Insert_Val3
	VALUES	(256, N'سعادت', N'بندرعباس' ,'20190425');
GO

INSERT INTO dbo.Insert_Val3
	VALUES	(255, N'سعادت', N'علی آباد کتول' ,'20190913');
GO

SELECT * FROM dbo.Insert_Val3;
GO

INSERT INTO dbo.Insert_Val3
	VALUES	(1, N'سعادت', N'اصفهان', '2019');
GO

SELECT * FROM dbo.Insert_Val3;
GO
--------------------------------------------------------------------

/*
INSERT & IDENTITY
*/

DROP TABLE IF EXISTS dbo.Insert_Val4;
GO

CREATE TABLE dbo.Insert_Val4
(
	Code INT,
	ID INT IDENTITY, -- DEFAULT: IDENTITY (1,1)
	Family NVARCHAR(50),
	City NVARCHAR(10),
	DateRegister DATE
);
GO

INSERT INTO dbo.Insert_Val4
	VALUES	(1, N'بهمنی', N'اصفهان', GETDATE());
GO

SELECT * FROM dbo.Insert_Val4;
GO

-- عملیات درج غیرمجاز
INSERT INTO dbo.Insert_Val4
	VALUES	(1, 2, N'بهمنی', N'اصفهان', GETDATE());
GO

SELECT * FROM dbo.Insert_Val4;
GO

/*
روش اول:
حذف این قابلیت از فیلد

روش دوم:
IDENTITY_INSERT ON استفاده از تنظیمات
*/

SET IDENTITY_INSERT dbo.Insert_Val4 ON;
GO

-- IDENTITY درج غیرمجاز به‌دلیل عدم انتخاب نام فیلد حاوی
INSERT INTO dbo.Insert_Val4
	VALUES	(2, 2, N'محمودی', N'شیراز', '20190315');
GO

SELECT * FROM dbo.Insert_Val4;
GO

INSERT INTO dbo.Insert_Val4 (Code, ID, Family, City, DateRegisteR)
	VALUES	(2, 2, N'محمودی', N'شیراز', '20190315');
GO

SELECT * FROM dbo.Insert_Val4;
GO

INSERT INTO dbo.Insert_Val4 (Code, ID, Family, City, DateRegisteR)
	VALUES	(3, 2, N'فروهر', N'مشهد', '20191021'),
			(4, 100, N'کاویانی', N'تهران', '20191201');
GO

SELECT * FROM dbo.Insert_Val4;
GO

/*
IDENTITY_INSERT غیر‌فعال کردن قابلیت

1: جاری Session خارج شدن از
2: IDENTITY_INSERT کردن OFF
*/

SET IDENTITY_INSERT dbo.Insert_Val4 OFF;
GO

INSERT INTO dbo.Insert_Val4
	VALUES	(5, N'جدیدی', N'همدان', '20190215');
GO

SELECT * FROM dbo.Insert_Val4;
GO

