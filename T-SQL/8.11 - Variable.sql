USE Test_DB;
GO

-- تعریف متغیر
DECLARE @Var INT;
-- مقداردهی متغیر
SET @Var = 100;
GO

-- معادل دستورات بالا
DECLARE @Var INT = 100;
SELECT @Var;
--PRINT @Var;
GO
--------------------------------------------------------------------

-- DECLARE تعریف چند متغیر با یک دستور
DECLARE @Var1 INT, @Var2 INT, @Var3 DATE;
-- مقداردهی
SELECT @Var1 = 1000, @Var2 = 2000, @Var3 = GETDATE(); 
SELECT @Var1, @Var2, @Var3;
GO

-- DECLARE تعریف چند متغیر با یک دستور
DECLARE @Var1 INT, @Var2 INT, @Var3 DATE;
--.مقداردهی کرد SET هر متغیر را می‌توان با یک دستور
SET @Var1 = 1000;
SET @Var2 = 1000;
SET @Var3 = GETDATE();
SELECT @Var1, @Var2, @Var3;
GO

-- DECLARE تعریف چند متغیر با یک دستور
DECLARE @Var1 INT, @Var2 INT, @Var3 DATE;
-- مقداردهی
SELECT @Var1 = 1000, @Var2 = 2000, @Var3 = GETDATE(); 
--.می‌توان مشاهده کرد PRINT مقدار متغیر را با دستور
PRINT @Var1;
PRINT @Var2;
PRINT @Var3;
GO
--------------------------------------------------------------------

SELECT * FROM dbo.Employees;
GO

-- ؟؟؟
DECLARE @Family NVARCHAR(50);
SET @Family = (SELECT LastName FROM dbo.Employees
					WHERE mgrid = 2);
PRINT @Family;
GO

DECLARE @Family NVARCHAR(50);
SELECT @Family = LastName FROM dbo.Employees
	WHERE mgrid = 2;
PRINT @Family;
GO
/*
آن mgrid کوئری بالا آخرین رکوردی را که مقدار فیلد
.برابر با 2 می‌باشد، نمایش می‌دهد
*/