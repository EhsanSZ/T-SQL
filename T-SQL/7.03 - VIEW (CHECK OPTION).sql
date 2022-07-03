USE Test_DB;
GO

/*
CHECK OPTION
*/

DROP TABLE IF EXISTS dbo.Company;
GO

CREATE TABLE dbo.Company
(
	CompanyID INT IDENTITY,
	CompanyName NVARCHAR(50),
	City NVARCHAR(30)
);
GO

INSERT INTO dbo.Company
	VALUES	(N'شرکت 1', N'تهران'),
			(N'شرکت 2', N'تهران'),
			(N'شرکت 3', N'اصفهان'),
			(N'شرکت 4', N'تبریز'),
			(N'شرکت 5', N'تهران'),
			(N'شرکت 6', N'شیراز');
GO

DROP VIEW IF EXISTS dbo.Comp_View;
GO

CREATE VIEW dbo.Comp_View
AS
	SELECT
		CompanyName, City
	FROM dbo.Company
		WHERE City = N'تهران';
GO

-- Comp_View فراخوانی
SELECT * FROM dbo.Comp_View;
GO

-- VIEW از طریق Customers درج رکورد در جدول
INSERT INTO dbo.Comp_View (CompanyName, City)
	VALUES	(N'شرکت 7', N'رشت');
GO

SELECT * FROM dbo.Company;
GO

/*
Comp_View عدم نمایش رکورد درج شده توسط
VIEW به‌دلیل وجود فیلتر موجود در Company در جدول
*/
SELECT * FROM dbo.Comp_View
	WHERE CompanyName = N'شرکت 7';
GO

/*
بر روی آن WITH CHECK OPTION و اعمال تنظیمات VIEW تغییر
*/
ALTER VIEW dbo.Comp_View 
AS
SELECT
	City, CompanyName
FROM dbo.Company
	WHERE City = N'تهران'
WITH CHECK OPTION;
GO

-- VIEW از طریق Customers عدم درج رکورد در جدول
INSERT INTO dbo.Comp_View (CompanyName, City)
	VALUES	(N'شرکت 8', N'ساری');
GO

-- VIEW از طریق Customers درج رکورد در جدول
INSERT INTO dbo.Comp_View (CompanyName, City)
	VALUES	(N'شرکت 8', N'تهران');
GO

SELECT * FROM dbo.Company;
SELECT * FROM dbo.Comp_View;
GO
--------------------------------------------------------------------

-- Updateable VIEW در GROUP BY عدم استفاده از
ALTER VIEW dbo.Comp_View
AS
	SELECT City FROM dbo.Company
		WHERE City = N'تهران'
	GROUP BY City
	WITH CHECK OPTION;
GO

SELECT * FROM dbo.Comp_View;
GO

INSERT INTO dbo.Comp_View (City)
	VALUES	(N'تهران');
GO
--------------------------------------------------------------------

-- Updateable VIEW در DISTINCT عدم استفاده از
ALTER VIEW dbo.Comp_View
AS
	SELECT DISTINCT City FROM dbo.Company
		WHERE City = N'تهران'
	WITH CHECK OPTION;
GO

INSERT INTO dbo.Comp_View (City)
	VALUES	(N'تهران');
GO
--------------------------------------------------------------------

-- Updateable VIEW در Set Operator عدم استفاده از
ALTER VIEW dbo.Comp_View
AS
	SELECT N'نام شهر' AS City, N'عنوان شرکت' AS CompanyName
	UNION
	SELECT
		CompanyName, City
	FROM dbo.Company
		WHERE City = N'تهران'
	WITH CHECK OPTION;
GO

INSERT INTO dbo.Comp_View (CompanyName,City)
	VALUES	(N'شرکت 9', N'تهران');
GO