USE Test_DB;
GO

/*
SCHEMABINDING
*/
DROP VIEW IF EXISTS dbo.ViewBinding;
GO

DROP TABLE IF EXISTS dbo.SchemaBindingTbl;
GO

CREATE TABLE dbo.SchemaBindingTbl
(
	ID INT,
	Family NVARCHAR(50)
);
GO

INSERT INTO dbo.SchemaBindingTbl
	VALUES	(100,N'سعیدی'),
			(200,N'کاردان'),
			(300,N'شاکری');
GO

DROP VIEW IF EXISTS dbo.ViewBinding;
GO

CREATE VIEW ViewBinding
AS
	SELECT
		ID, Family
	FROM SchemaBindingTbl;
GO

SELECT * FROM dbo.ViewBinding;
GO

-- یکی از فیلدهای جدول Data Type تغییر 
ALTER TABLE SchemaBindingTbl
	ALTER COLUMN Family NVARCHAR(100);
GO

-- VIEW بر روی WITH SCHEMABINDING اضافه کردن تنظیمات
ALTER VIEW ViewBinding WITH SCHEMABINDING
AS
	SELECT 
		ID, Family
	FROM dbo.SchemaBindingTbl;
GO

/*
WITH SCHEMABINDING به‌دلیل وجود تنظیمات
.داده نخواهد شد Family فیلد Data Type اجازه تغییر
*/
ALTER TABLE SchemaBindingTbl
	ALTER COLUMN Family NVARCHAR(100);
GO

/*
را تغییر داده و فیلد VIEW
.را از آن حذف می‌کنیم Family
*/
ALTER VIEW ViewBinding WITH SCHEMABINDING
AS
	SELECT ID FROM dbo.SchemaBindingTbl;
GO

SELECT * FROM ViewBinding;
GO

/*
VIEW در Family با توجه به عدم وجود فیلد
.تغییرات بدون هیچ‌گونه مشکلی در سمت جدول انجام خواهد شد
*/
ALTER TABLE SchemaBindingTbl
	ALTER COLUMN Family NVARCHAR(100);
GO

/*
کردن جدول داده نمی‌شود چرا که DROP اجازه
.با جدول در ارتباط است WITH SCHEMABINDING از طریق VIEW
*/
DROP TABLE IF EXISTS SchemaBindingTbl;
GO
--------------------------------------------------------------------

/*
در حالت استفاده Object عدم نوشتن نام اسکیمای
.موجب بروز خطا خواهد شد WITH SCHEMABINDING از تنظیمات 
*/
ALTER VIEW ViewBinding WITH SCHEMABINDING
AS
	SELECT ID FROM SchemaBindingTbl; -- dbo.SchemaBindingTbl
GO

/*
در حالت استفاده  SELECT * استفاده از
.موجب بروز خطا خواهد شد WITH SCHEMABINDING از تنظیمات 
*/
ALTER VIEW ViewBinding WITH SCHEMABINDING
AS
	SELECT * FROM dbo.SchemaBindingTbl;
GO