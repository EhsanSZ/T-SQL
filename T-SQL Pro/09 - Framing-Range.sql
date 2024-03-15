
USE WF;
GO

/*
OVER در بخش ORDER BY در کوئری زیر به‌دلیل استفاده از عبارت
به‌صورت اتوماتیک ،Aggregate Function و در کنار آن استفاده از
:نیز پوشش داده می‌شود که مقدار پیش‌فرض آن عبارت است از Framing

RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROWS

*/
SELECT
	*,
	SUM(Val) OVER( PARTITION BY Val
				   ORDER BY Cust_ID ) AS Total
FROM Test_Framing;
GO

--Query1
SELECT
	*,
	SUM(Val) OVER( PARTITION BY Cust_ID
				   ORDER BY Cust_ID ) AS Total
FROM Test_Framing;
GO

/*
. و با هر روش دلخواه  Framing را بدون استفاده از Query1
*/
SELECT
	*,
	SUM(Val) OVER( PARTITION BY Cust_ID ) AS Total
FROM Test_Framing;
GO
--------------------------------------------------------------------

/*
خروجی هر یک از کوئری‌های زیر 
*/

SELECT
	*,
	SUM(Val) OVER(ORDER BY Cust_ID) AS Total
FROM Test_Framing;
GO

SELECT
	*,
	SUM(Val) OVER(ORDER BY Val) AS Total
FROM Test_Framing;
GO
--------------------------------------------------------------------

SELECT
	SUM(qty) AS Sum_Qty
FROM Sales.EmpOrders
	WHERE ordermonth = '2016-07-01'
GO

SELECT
	SUM(qty) AS Sum_Qty
FROM Sales.EmpOrders
	WHERE ordermonth = '2016-08-01'
GO

/*
:را مشخص نکرده‌ایم پس به‌طور پیش‌فرض داریم Framing داریم اما ORDER BY چون
RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROWS

و طبیعی است که همه اولین تاریخ‌های یکسان با هم جمع می‌شود و سپس در مرحله بعد
... حاصل‌جمع قبلی با همه مقادیر تکراریِ تاریخ بعدی جمع می‌شود و الی آخر
*/
SELECT
	empid, ordermonth, QTY,
	SUM(qty) OVER(ORDER BY ordermonth) AS Sum_Qty
FROM Sales.EmpOrders;
GO
--------------------------------------------------------------------

--هر سه کوئری زیر عملکرد یکسانی دارند
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( PARTITION BY empid
	               ORDER BY ordermonth
	               RANGE BETWEEN UNBOUNDED PRECEDING
	                         AND CURRENT ROW ) AS Total
FROM Sales.EmpOrders;
GO
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( PARTITION BY empid
				   ORDER BY ordermonth
	               RANGE UNBOUNDED PRECEDING ) AS Total
FROM Sales.EmpOrders;
GO
SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( PARTITION BY empid
	               ORDER BY ordermonth ) AS Total
FROM Sales.EmpOrders;
GO
-----------------------------------------------------------

/*
در حالتی‌که ترکیب ROWS و RANGE عملکرد مشابه
.باشد Unique به‌صورت ORDER BY و PARTITION BY بین
*/

SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( PARTITION BY empid
	               ORDER BY ordermonth
	               ROWS BETWEEN UNBOUNDED PRECEDING
	                        AND CURRENT ROW) AS Total
FROM Sales.EmpOrders;
GO

SELECT
	empid, ordermonth, qty,
	SUM(qty) OVER( PARTITION BY empid
	               ORDER BY ordermonth
	               RANGE BETWEEN UNBOUNDED PRECEDING
	                         AND CURRENT ROW) AS Total
FROM Sales.EmpOrders;
GO
-----------------------------------------------------------

/*
در حالتی‌که ترکیب ROWS و RANGE عملکرد متفاوت
.نباشد Unique به‌صورت ORDER BY و PARTITION BY بین
*/

DROP TABLE IF EXISTS dbo.Test_Row_Range;
GO

CREATE TABLE dbo.Test_Row_Range
(
	ID INT NOT NULL PRIMARY KEY,
	Col1 VARCHAR(10) NOT NULL
);

INSERT INTO dbo.Test_Row_Range
VALUES	(10, 'A'),(20, 'A'),
		(30, 'B'),(40, 'B'),(50, 'B'),
		(60, 'C'),(70, 'C'),(80, 'C'),(90, 'C');
GO

SELECT
	ID, Col1,
	COUNT(*) OVER( ORDER BY Col1
	               ROWS BETWEEN UNBOUNDED PRECEDING
	                        AND CURRENT ROW ) AS Num
FROM dbo.Test_Row_Range;
GO

SELECT
	ID, Col1,
	COUNT(*) OVER( ORDER BY Col1
	               RANGE BETWEEN UNBOUNDED PRECEDING
	                         AND CURRENT ROW ) AS Num
FROM dbo.Test_Row_Range;
GO