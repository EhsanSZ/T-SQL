
USE WF;
GO

-- Query1
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER ( PARTITION BY empid 
					ORDER BY ordermonth 
					ROWS BETWEEN UNBOUNDED PRECEDING
							 AND CURRENT ROW ) AS Total
					-- تمامی سطرهای قبل از سطر جاری و خودش
FROM Sales.EmpOrders;
GO

-- Query1 معادل
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER ( PARTITION BY empid 
					ORDER BY ordermonth 
					ROWS UNBOUNDED PRECEDING ) AS Total-- .فقط نقطه شروع را مشخص می‌‌کند
					-- تمامی سطرهای قبل از سطر جاری و خودش
FROM Sales.EmpOrders;
GO

/*
Query1 معادل
.مقادیر تکراری تذکر داده شود
*/
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER ( PARTITION BY empid
					ORDER BY ordermonth ) AS Total
FROM Sales.EmpOrders; -- .پیش‌فرض استفاده کرده است Framing از
GO
--------------------------------------------------------------------

-- به‌ازای 3 سطر قبل از سطر جاری و خودش
SELECT
	custid, orderdate, qty,
	SUM(qty) OVER ( PARTITION BY custid
					ORDER BY orderdate
				    ROWS BETWEEN 3 PRECEDING
							 AND CURRENT ROW ) AS Prv3 
FROM Sales.OrderValues;
GO

-- به‌ازای سطر جاری و 3 سطر بعد از آن
SELECT
	custid, orderdate, qty,
	SUM(qty) OVER ( PARTITION BY custid
					ORDER BY orderdate
				    ROWS BETWEEN CURRENT ROW
							 AND 3 FOLLOWING ) AS Nxt3 
FROM Sales.OrderValues;
GO

-- به‌ازای 1 سطر قبل از سطر جاری، خودش و 2 سطر بعد از سطر جاری
SELECT
	custid, orderdate, qty,
	SUM(qty) OVER ( PARTITION BY custid
					ORDER BY orderdate
				    ROWS BETWEEN 1 PRECEDING
							 AND 2 FOLLOWING ) AS Prv1_Nxt2
FROM Sales.OrderValues;
GO

--------------------------------------------------------------------

/*
کوئری‌ای  که به‌ازای هر کارمند، علاوه بر تاریخ سفارش و تعداد اقلام
.مشخص کند که آخرین تعداد کل اقلام، قبل از سفارش جاری چه تعداد بوده است

VIEW: Sales.EmpOrders

empid    ordermonth   qty  Prv_Qty
------  -----------  ----- -------
  1      2016-07-01   121   NULL
  1      2016-08-01   247   121
  1      2016-09-01   255   247
  ...  			     
  9      2018-02-01   297   237
  9      2018-03-01   317   297
  9      2018-04-01   289   317

(192 rows affected)
*/

-- Window Aggregate Function با استفاده از
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER(PARTITION BY empid ORDER BY ordermonth
					ROWS BETWEEN 1 PRECEDING AND 1 PRECEDING) AS Prv_Qty
FROM Sales.EmpOrders;
GO

-- Window Aggregate Function بدون استفاده از
SELECT
	E1.empid, E1.ordermonth, E1.qty,
	(SELECT TOP (1) E2.qty FROM Sales.EmpOrders AS E2
		WHERE E2.empid = 1
		AND E2.ordermonth < E1.ordermonth
	 ORDER BY E2.ordermonth DESC) AS Prv_Qty
FROM Sales.EmpOrders AS E1
ORDER BY E1.empid;
GO
--------------------------------------------------------------------
SELECT
	empid, ordermonth, qty,
	MAX(qty) OVER( PARTITION BY empid
	               ORDER BY ordermonth
	               ROWS BETWEEN 1 PRECEDING
	                        AND 1 PRECEDING) AS Prv_Qty,-- فقط سطر قبل از سطر جاری
	MAX(qty) OVER( PARTITION BY empid
	               ORDER BY ordermonth
	               ROWS BETWEEN 1 FOLLOWING
	                        AND 1 FOLLOWING) AS Nxt_Qty,-- فقط سطر بعد از سطر جاری
	AVG(qty) OVER( PARTITION BY empid
	               ORDER BY ordermonth
	               ROWS BETWEEN 1 PRECEDING
	                        AND 1 FOLLOWING) AS Avg_Qty -- سطر قبل و بعد از سطر جاری و خودش
FROM Sales.EmpOrders;
GO
--------------------------------------------------------------------

/*
کوئری‌ای که به‌ازای مشتری 1 یا 2 علاوه بر نمایش تاریخ و تعداد اقلام سفارش
.در جلو هر سطر قدیمی‌ترین و جدیدترین سفارشی را هم که تاکنون ثبت شده، نمایش دهد

custid    orderdate    qty  Min_OrderDate   Max_OrderDate
-------  -----------  ---- -------------   -------------- 
  1       2017-08-25   38    2017-08-25      2017-08-25  
  1       2017-10-03   20    2017-08-25      2017-10-03  
  1       2017-10-13   21    2017-08-25      2017-10-13  
  1       2018-01-15   17    2017-08-25      2018-01-15  
  1       2018-03-16   18    2017-08-25      2018-03-16  
  1       2018-04-09   60    2017-08-25      2018-04-09  
  2       2016-09-18   6     2016-09-18      2016-09-18  
  2       2017-08-08   18    2016-09-18      2017-08-08  
  2       2017-11-28   10    2016-09-18      2017-11-28  
  2       2018-03-04   29    2016-09-18      2018-03-04  

(10 rows affected)
*/

SELECT
	custid, orderdate, qty,
	MIN(orderdate) OVER(PARTITION BY custid ORDER BY orderdate
							ROWS UNBOUNDED PRECEDING) AS Min_OrderDate,
	MAX(orderdate) OVER(PARTITION BY custid ORDER BY orderdate
							ROWS UNBOUNDED PRECEDING) AS Max_OrderDate
FROM Sales.OrderValues
	WHERE custid = 1 OR custid = 2;
GO

/*
. Window Aggregate Function اکنون همین کوئری را بدون استفاده از
*/
SELECT
	O1.custid, O1.orderdate, O1.qty,
	(SELECT MIN(O2.orderdate) FROM Sales.OrderValues AS O2
		WHERE O2.custid = O1.custid
		AND O2.orderdate <= O1.orderdate) AS MIN_OrderDate,
	(SELECT MAX(O2.orderdate) FROM Sales.OrderValues AS O2
		WHERE O2.custid = O1.custid
		AND O2.orderdate <= O1.orderdate) AS Max_OrderDate
FROM Sales.OrderValues AS O1
	WHERE O1.custid = 1 OR O1.custid = 2
ORDER BY O1.custid;
GO
--------------------------------------------------------------------

/*
باشد Partition فاقد OVER داشته باشیم و Framing و Ordering اگر فقط
داریم و در این وضعیت نحوه عملکرد Window انگار فقط یک
خواهد بود OVER موجود در Framing متناسب با Window Aggregate Function
*/
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( ORDER BY ordermonth
				   ROWS BETWEEN 2 PRECEDING
							AND CURRENT ROW ) AS Sum_Qty
FROM Sales.EmpOrders;
GO
/*
بیاید ORDER BY می‌بایست حتما با ROWS
!به‌همین دلیل کوئری زیر غلط است
*/
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( PARTITION BY empid
				   ROWS BETWEEN UNBOUNDED PRECEDING
							AND CURRENT ROW) AS Sum_Qty
FROM Sales.EmpOrders;
GO