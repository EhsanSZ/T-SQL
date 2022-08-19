USE Test_DB;
GO

/*
Local Temporary Table
جاری Session قابلیت دسترسی در تمامی بخش‌های مختلف
*/

CREATE TABLE #Local_Tmp_Table
(
	Code INT
);
GO

INSERT #Local_Tmp_Table
	VALUES (1),(2),(3),(4),(5);
SELECT * FROM #Local_Tmp_Table;
GO -- .باشد Tempdb ایجاد‌شده مربوط به دیتابیس Session دیگر حتی اگر Session عدم استفاده در

-- آزادسازی منابع
DROP TABLE #Local_Tmp_Table;
GO
--------------------------------------------------------------------

/*
Global Temporary Table
جاری Session ها تا زمان باز بودنSession قابلیت دسترسی در تمامی
*/
CREATE TABLE ##Global_Tmp_Table
(
	Code INT
);
GO

INSERT ##Global_Tmp_Table
	VALUES (1),(2),(3),(4),(5);
SELECT * FROM ##Global_Tmp_Table;
GO
--------------------------------------------------------------------

/*
Table Variable
جاری Batche و Session فقط در
*/

DECLARE @TV TABLE
(
	F1 INT
);
INSERT INTO @TV
	VALUES (100),(200),(300);
SELECT * FROM @TV;
GO

-- عدم دسترسی به متغیر جدول
SELECT * FROM @TV;
GO