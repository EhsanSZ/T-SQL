
USE WF;
GO

DROP TABLE IF EXISTS Test_Framing;
GO

CREATE TABLE Test_Framing
(
	Cust_ID VARCHAR(5),
	Emp_ID VARCHAR(5),
	Val INT
);
GO

INSERT INTO Test_Framing
VALUES
		('C1','E1',100),('C1','E2',900),('C1','E3',400),
		('C2','E1',200),('C2','E2',150),('C2','E3',350),
		('C3','E1',250),('C3','E2',300),('C3','E3',550)
GO

/*
.داریم Window نیست و در حقیقت فقط یک Partitioning در این‌جا خبری از
.بر روی تمامی مقادیر موجود انجام می‌شود SUM بنابراین عملیات
*/
SELECT
	*,
	SUM(Val) OVER() AS Total
FROM Test_Framing;
GO

/*
.داریم Window و در حقیقت فقط یک Partitioning در این‌جا خبری از
OVER در بخش ORDER BY اما با توجه به استفاده از عبارت
.پیش‌فرض استفاده می‌شود Framing ناخودآگاه از
هر بار حاصل مقادیر Total در فیلد Val بنابراین پس از مرتب‌سازی بر روی فیلد
.با مجموع رکوردهای قبل از آن محاسبه می‌شود Val فیلد

!!!توجه، توجه، توجه
.اعمال شده است هیچ مقدار تکراری نداریم ORDER BY که Val در این‌جا بر روی فیلد
*/
SELECT
	*,
	SUM(Val) OVER(ORDER BY Val) AS Total
FROM Test_Framing;
GO

SELECT
	*,
	SUM(Val) OVER(PARTITION BY Cust_ID) AS Total
FROM Test_Framing;
GO

SELECT
	*,
	SUM(Val) OVER( PARTITION BY Cust_ID
				   ORDER BY Val) AS Total
FROM Test_Framing;
GO

/*
.درج می‌کنیم Test_Framing اکنون تعداد دیگری رکورد در جدول
.مجددا می‌خواهیم تمامی کوئری‌های بالا را بررسی می‌کنیم
در رکوردهای جدید Val توجه داشته باشید که برخی از مقادیر فیلد
.نسبت به مقادیر قبلی که در جدول وجود داشته، برابر است
*/
INSERT INTO Test_Framing
VALUES
		('C1','E3',200),
		('C2','E2',200),
		('C3','E2',200)
GO

SELECT
	*,
	SUM(Val) OVER() AS Total
FROM Test_Framing;
GO

SELECT
	*,
	SUM(Val) OVER(PARTITION BY Cust_ID) AS Total
FROM Test_Framing;
GO

/*
Total در کوئری زیر انتظار داریم که برای ستون
:نتایج به‌صورت زیر باشد Val به‌ازای مقادیر 200 از ستون

Cust_ID   Emp_ID    Val   Total
-------  --------  ----- -------
  ...	 		  		 
  C1       E3       200    200
  C2       E2       200    400
  C2       E1       200    600
  C3       E2       200    800
  ...

(12 rows affected)

.است OVER در بخش Framing اما چنین اتفاقی نمی‌افتد و دلیل آن هم رفتار پیش‌فرض برای
پیش‌فرض Frame در RANG در این‌جا به‌دلیل وجود مقادیر تکراری در هر پارتیشن و وجود
.با نتایج متفاوتی نسبت به قبل روبرو خواهیم شد
*/
SELECT
	*,
	SUM(Val) OVER( PARTITION BY Val
				   ORDER BY Cust_ID ) AS Total
FROM Test_Framing;
GO

SELECT
	*,
	SUM(Val) OVER(ORDER BY Val) AS Total
FROM Test_Framing;
GO

SELECT
	*,
	SUM(Val) OVER(ORDER BY Cust_ID) AS Total
FROM Test_Framing;
GO
--------------------------------------------------------------------

SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER(ORDER BY ordermonth) AS Sum_Qty
FROM Sales.EmpOrders;
GO

SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( PARTITION BY empid 
				   ORDER BY ordermonth ) AS Sum_Qty
FROM Sales.EmpOrders;
GO

-- ها Window Aggregate Function اضافی بر روی نتایج حاصل از ORDER BY تاثیر
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( PARTITION BY empid
				   ORDER BY ordermonth ) AS Sum_Qty
FROM Sales.EmpOrders
ORDER BY ordermonth;
GO

-- . نیست SQL Server 2012 اجرای کوئری زیر در یکی از نسخه‌های قبل از
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( PARTITION BY empid
				   ORDER BY ordermonth ) AS Sum_Qty
FROM Sales.EmpOrders;
GO