
USE WF;
GO

-- تعداد سفارشات هر مشتری-کارمند
SELECT
	custid, empid,
	COUNT(orderid) AS Num
FROM Sales.OrderValues
	WHERE custid = 1
GROUP BY custid, empid
ORDER BY Num;
GO

/*
،اکنون می‌خواهیم بدانیم که مشتری 1 در هر لحظه با چه تعداد کارمند در ارتباط بوده است
:یعنی خروجی به‌صورت زیر باشد

custid   empid   orderdate    Num_Cust
------- ------- ------------ -----------
  1       6      2017-08-25      1
  1       4      2017-10-03      2
  1       4      2017-10-13      2
  1       1      2018-01-15      3
  1       1      2018-03-16      3
  1       3      2018-04-09      4


اما کوئری زیر به‌ازای هر ثبت‌سفارش، عملیات شمارش را انجام داده
،و اگر مشتری‌ای در تاریخ دیگر هم با کارمندی که قبلا شمارش شده
.ثبت‌سفارش داشته باشد آن را مجددا شمارش می‌کند
*/
SELECT
	custid, empid, orderdate,
	COUNT(orderid) OVER( PARTITION BY custid
						 ORDER BY orderdate ) AS Num_Cust
FROM Sales.OrderValues
	WHERE custid = 1;
GO

/*
،استفاده می‌کردیم DISTINCT برای رفع مشکل قبلا از
.نیستیم OVER در کنار بخش DISTINCT مجاز به استفاده از SQL Server اما در
*/
SELECT
	custid, empid, orderdate,
	COUNT(DISTINCT empid) OVER( PARTITION BY custid
								ORDER BY orderdate ) AS Distinct_Emp
FROM Sales.OrderValues
	WHERE custid = 1;
GO

-- راه‌حل پیشنهادی شما برای رفع مشکل بالا چیست؟
-- .استفاده می‌کنیم ROW_NUMBER ابتدا به‌ازای ترکیب هر مشتری-کارمند از
SELECT
	custid, empid, orderdate,
	ROW_NUMBER() OVER( PARTITION BY custid, empid
					   ORDER BY orderdate ) AS Distinct_Emp
FROM Sales.OrderValues
	WHERE custid = 1;
GO

-- .می‌شود NULL با استفاده از ترفند زیر مقادیر تکراری مشتری-کارمند
SELECT
	custid, empid, orderdate,
	CASE
		WHEN ROW_NUMBER() OVER( PARTITION BY custid, empid
								ORDER BY orderdate ) = 1
		THEN empid/*توضیح*/ END AS Distinct_Emp
FROM Sales.OrderValues
	WHERE custid = 1;
GO

/*
هدایت کرده و در بخش CTE اکنون کوئری بالا را به درون
.را با خیال راحت انجام می‌دهیم COUNT عملیات Outer Query
*/
WITH CTE
AS
(
	SELECT
	custid, empid, orderdate,
	CASE
		WHEN ROW_NUMBER() OVER( PARTITION BY custid, empid
								ORDER BY orderdate ) = 1
		THEN empid
	END AS Distinct_Emp
	FROM Sales.OrderValues
		WHERE custid = 1
)
SELECT
	custid, empid, orderdate,
	COUNT(Distinct_Emp) OVER( PARTITION BY custid
							  ORDER BY orderdate ) AS Num_Cust
FROM CTE;
GO

/*
ذخیره کرده SP شما می‌توانید کوئری زیر را در قالب یک
و با ایجاد پارامترهای موردنظر، در هر لحظه تشخیص دهید
.که مشتری موردنظرتان با چه تعداد کارمند در ارتباط بوده است 
*/
WITH CTE
AS
(
	SELECT
	custid, empid, orderdate,
	CASE
		WHEN ROW_NUMBER() OVER( PARTITION BY custid, empid
								ORDER BY orderdate ) = 1
		THEN empid END AS Distinct_Emp
	FROM Sales.OrderValues
)
SELECT
	custid, empid, orderdate,
	COUNT(Distinct_Emp) OVER( PARTITION BY custid
							  ORDER BY orderdate ) AS Num_Cust
FROM CTE;
GO

------------------------------------------------

USE WF;
GO

/*
!!!وجود ندارد SQL Server ای درSyntax برای پیاده‌سازی فیلترینگ چنین
*/
SELECT
	empid, ordermonth, qty,
	qty - AVG(qty) FILTER (WHERE ordermonth >= '2017-07-01')
				   OVER(PARTITION BY empid) AS diff
FROM Sales.EmpOrders;
GO

SELECT * FROM Sales.EmpOrders
	WHERE empid = 9
	AND ordermonth BETWEEN '2017-07-01' AND '2017-12-31';
GO

/*
:می‌خواهیم به‌ازای کارمند شماره 9 و در سال 2017 کوئری زیر را بنویسیم
نیم‌سال دوم همان سال qty هرماه نسبت به میانگین qty محاسبه اختلاف

empid   ordermonth   qty     Diff
-----   ----------  -----   ------
  9     2017-01-01   74      -13 
  9     2017-03-01   137      50	 
  9     2017-04-01   52      -35 
  9     2017-05-01   8       -79 
  9     2017-06-01   161      74	 
  9     2017-07-01   4       -83 
  9     2017-08-01   98       11	 
  9     2017-09-01   93       6	 
  9     2017-10-01   24      -63 
  9     2017-11-01   222     135 
  9     2017-12-01   82      -5	 

*/

-- در نیم‌سال دوم 2017 برای کارمند شماره 9 qty میانگین
SELECT
	AVG(qty)
FROM  Sales.EmpOrders
	WHERE empid = 9 
	AND ordermonth BETWEEN '2017-07-01' AND '2017-12-31';
GO -- AVG(qty): 87

-- Window Aggregate Function بدون استفاده از
WITH CTE
AS
(
	SELECT
		AVG(qty) AS Avg_Val
	FROM  Sales.EmpOrders
		WHERE empid = 9 
	AND ordermonth BETWEEN '2017-07-01' AND '2017-12-31'
)
SELECT
	empid, ordermonth, qty,
	qty - (SELECT Avg_Val FROM CTE) AS Diff
FROM Sales.EmpOrders
	WHERE empid = 9
	AND ordermonth BETWEEN '2017-01-01' AND '2017-12-31';
GO

-- Window Aggregate Function با استفاده از
SELECT
	empid, ordermonth, qty,
	qty - AVG(CASE
				WHEN ordermonth BETWEEN '2017-07-01' AND '2017-12-31'
				THEN qty
				ELSE NULL
			   END) OVER() AS Diff
FROM Sales.EmpOrders
	WHERE empid = 9
	AND ordermonth BETWEEN '2017-01-01' AND '2017-12-31';
GO
--------------------------------------------------------------------

/*
کوئری بالا را به‌گونه‌ای بازنویسی کنید که محاسبات
.به‌ازای کارمند 9 و متناسب با هر سال انجام شود

 empid   ordermonth   qty   Diff
-------  ----------   ---  ------
  9      2016-07-01   294   103
  9      2016-10-01   256   65
  9      2016-12-01   25    -166
  9      2017-01-01   74    -13
  9      2017-03-01   137   50
  9      2017-04-01   52    -35
  9      2017-05-01   8     -79
  9      2017-06-01   161   74
  9      2017-07-01   4     -83
  9      2017-08-01   98    11
  9      2017-09-01   93    6
  9      2017-10-01   24    -63
  9      2017-11-01   222   135
  9      2017-12-01   82    -5
  9      2018-01-01   237   NULL
  9      2018-02-01   297   NULL
  9      2018-03-01   317   NULL
  9      2018-04-01   289   NULL

*/

-- Window Aggregate Function با استفاده از
SELECT
	empid, ordermonth, qty,
	qty - AVG(CASE
				WHEN MONTH(ordermonth) > 6
				THEN qty
				ELSE NULL
			   END) OVER(PARTITION BY YEAR(ordermonth)) AS Diff
FROM Sales.EmpOrders
	WHERE empid = 9;
GO

-- Window Aggregate Function بدون استفاده از
WITH CTE
AS
(
	SELECT
		AVG(CASE
				WHEN MONTH(ordermonth) <= 6 
				THEN NULL ELSE qty END) AS Avg_Value,
		YEAR(ordermonth) AS Year_Ordermonth
	FROM Sales.EmpOrders
		WHERE empid = 9
	GROUP BY YEAR(ordermonth)
)
SELECT
	E.empid, E.ordermonth, E.qty,
	E.qty - (SELECT Avg_Value FROM CTE 
				WHERE CTE.Year_Ordermonth = YEAR(E.ordermonth)) AS Diff
FROM Sales.EmpOrders AS E
	WHERE E.empid = 9;
GO

--------------------------------------------


USE WF;
GO

/*
Query1
فهرست مجموع مبلغ کل سفارشات هر کارمند به‌همراه مجموع کل مبلغ همه سفارشات
*/

SELECT
	empid,
	SUM(val) AS Sum_Emp,
	(SELECT SUM(val) FROM Sales.OrderValues) AS Sum_All
FROM Sales.OrderValues
GROUP BY empid;
GO
--------------------------------------------------------------------

/*
فهرست مجموع مبلغ کل سفارشات هر کارمند
به‌همراه مجموع کل مبلغ همه سفارشات
همچنین محاسبه اختلاف و درصد مبلغ هر کارمند نسبت به مبلغ کل سفارشات
*/
SELECT
	empid,
	SUM(val) AS Sum_Emp, -- مجموع مبالغ هر کارمند
	(SELECT SUM(val) FROM Sales.OrderValues) AS Sum_All, -- مجموع مبالغ تمامی کارمندان
	SUM(val) - (SELECT SUM(val) FROM Sales.OrderValues) AS Diff, -- میزان اختلاف نسبت به مجموع کل
	SUM(val) / (SELECT SUM(val) FROM Sales.OrderValues) * 100 AS Prcnt -- میزان درصد نسبت به مجموع کل
FROM Sales.OrderValues
GROUP BY empid;
GO

/*
و به‌شکل درست Window Aggregate Function با استفاده از Query2 بازنویسی
*/
SELECT
	empid,
	SUM(val) AS Sum_Emp,
	SUM(SUM(val)) OVER() AS Sum_All,
	SUM(val) - SUM(SUM(val)) OVER() AS Diff,
	SUM(val) / SUM(SUM(val)) OVER() * 100 AS Prcnt
FROM Sales.OrderValues
GROUP BY empid;
GO

--------------------------------------------------------------------

/*
.را به ساده‌ترین شکل ممکن بازنویسی کنید Query2
*/
WITH CTE
AS
(
	-- محاسبه مجموع مبالغ هر کارمند
	SELECT
		empid,
		SUM(val) AS Sum_Emp
	FROM Sales.OrderValues
	GROUP BY empid
)
SELECT
	empid,
	Sum_Emp AS Sum_Emp,
	SUM(Sum_Emp) OVER() AS Sum_All,
	Sum_Emp - SUM(Sum_Emp) OVER() AS Diff,
	Sum_Emp / SUM(Sum_Emp) OVER() * 100 AS Prcnt
FROM CTE;
GO