USE Test_DB;
GO


/* Data Type Precedence + Implicit & Explicit Conversion
https://technet.microsoft.com/en-us/library/ms190309(v=sql.110).aspx

https://docs.microsoft.com/en-us/sql/t-sql/data-types/data-type-conversion-database-engine?view=sql-server-2017
*/

DECLARE @X INT = 2.7;
SELECT @X;
GO

SELECT * FROM dbo.Orders
	WHERE OrderDate = '20160506'; -- Implicit Conversion
GO

DECLARE @d DATE = '20160506';
SELECT * FROM dbO.Orders
	WHERE OrderDate = @d;
GO
--------------------------------------------------------------------
/*
دسترسی به تاریخ جاری
*/
SELECT GETDATE();
GO
--------------------------------------------------------------------
/*
YEAR/MONTH/DAY/TIME
تفکیک بخش‌های مختلف یک نوع‌داده از جنس تاریخ
*/

SELECT 
	OrderID,
	YEAR(OrderDate) AS N'سال',
	MONTH(OrderDate) AS N'ماه',
	DAY(OrderDate) AS N'روز'
FROM dbo.Orders;
GO
--------------------------------------------------------------------

/*
DATENAME
دسترسی به عناوین بخش‌های مختلف تاریخ

DATENAME (datepart , date)

 datepart	  Abbreviations
 --------     -------------
  year	       yy, yyyy
  quarter	    qq, q
  month	        mm, m
  dayofyear	    dy, y
  day	        dd, d
  week	        wk, ww
  weekday	    dw, w
  hour	        hh
  minute	    mi, n
  second	    ss, s
  millisecond	ms
  microsecond	mcs
  nanosecond	ns
  TZoffset	    tz
  ISO_WEEK	    ISOWK, ISOWW

date: date\datetime\datetimeoffsetdatetime2\smalldatetime\time
*/

SELECT 
	 DATENAME(year, '20170915') AS N' سال میلادی'  
    ,DATENAME(month, '20170915') AS N'ماه میلادی'
    ,DATENAME(day, '20170915') AS N'چندمین روز از ماه'
    ,DATENAME(dayofyear, '20170915') AS N'چندمین روز از سال' 
    ,DATENAME(weekday, '20170915') AS N'عنوان روز هفته';
GO
--------------------------------------------------------------------

/*
DATEPART
دسترسی به بخش‌های مختلف تاریخ

DATEPART (datepart , date)

 datepart	  Abbreviations
 --------     -------------
  year	        yy, yyyy
  quarter	     qq, q
  month	         mm, m
  dayofyear	     dy, y
  day	dd,      d
  week	         wk, ww
  weekday	     dw
  hour	         hh
  minute	     mi, n
  second	     ss, s
  millisecond	 ms
  microsecond	 mcs
  nanosecond	 ns
  TZoffset	     tz
  ISO_WEEK	     isowk, isoww

date: date\datetime\datetimeoffset\datetime2\smalldatetime\time
*/

SELECT 
	 DATEPART(year, '20170915') AS N' سال میلادی'  
    ,DATEPART(month, '20170915') AS N'ماه میلادی'
    ,DATEPART(day, '20170915') AS N'چندمین روز از ماه'
    ,DATEPART(dayofyear, '20170915') AS N'چندمین روز از سال' 
    ,DATEPART(weekday, '20170915') AS N'چندمین روز هفته';
GO

DECLARE @X DATE = '2019'
SELECT 
	 DATEPART(year, @X) AS N' سال میلادی'  
    ,DATEPART(month,@X) AS N'ماه میلادی'
    ,DATEPART(day, @X) AS N'چندمین روز از ماه'
    ,DATEPART(dayofyear, @X) AS N'چندمین روز از سال' 
    ,DATEPART(weekday, @X) AS N'چندمین روز هفته';
GO
--------------------------------------------------------------------

/*
DATEADD()
اضافه و کم کردن به تاریخ موردنظر

DATEADD (datepart , number , date)

 datepart	  Abbreviations
 --------     -------------
  year	       yy, yyyy
  quarter	    qq, q
  month	        mm, m
  dayofyear	    dy, y
  day	        dd, d
  week	        wk, ww
  weekday	    dw, w
  hour	        hh
  minute	    mi, n
  second	    ss, s
  millisecond	ms
  microsecond	mcs
  nanosecond	ns

date: date\datetime\datetimeoffset\datetime2\smalldatetime\time
*/

SELECT
	DATEADD(year, 1, '2017-09-15') AS N'افزایش سال',
	DATEADD(year, -1, '2017-09-15') AS N'کاهش سال',
	DATEADD(month, 1, '2017-09-15') AS N'افزایش ماه',
	DATEADD(month, -1, '2017-09-15') AS N'کاهش ماه',
	DATEADD(day, 1, '2017-09-15') AS N'افزایش روز',
	DATEADD(day, -1, '2017-09-15') AS N'کاهش روز';
GO
--------------------------------------------------------------------

/*
DATEDIFF()
محاسبه اختلاف میان دو تاریخ

DATEDIFF ( datepart , startdate , enddate )  

 datepart	  Abbreviations
 --------     -------------
  year	        yy, yyyy
  quarter	     qq, q
  month	         mm, m
  dayofyear	     dy, y
  day	         dd, d
  week	         wk, ww
  hour	         hh
  minute	     mi, n
  second	     ss, s
  millisecond	 ms
  microsecond	 mcs
  nanosecond	 ns

date: date\datetime\datetimeoffset\datetime2\smalldatetime\time
*/

SELECT DATEDIFF(day, '20130512', GETDATE());
GO

SELECT DATEDIFF(day, GETDATE(), '20130512');
GO

-- از شروع جنگ جهانی اول تا به امروز چند ثانیه گذشته است؟
SELECT DATEDIFF(second, '19140628', GETDATE());
GO

-- SQL Server 2016 تابع جدید در
SELECT DATEDIFF_BIG(second, '19140628', GETDATE());
GO
--------------------------------------------------------------------

/*
ISDATE()
تشخیص معتبر بودن تاریخ
DATE/TIME/DATETIME : صرفا برای انواع داده
*/

SELECT ISDATE('20140212');
SELECT ISDATE('2000212');
SELECT ISDATE('20140231');
GO



