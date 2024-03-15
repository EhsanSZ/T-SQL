
USE WF;
GO

/*
Sales.OrderValues: 830 Records

830 / 10 = 83 
830 % 10 = 0
*/
SELECT
	orderid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS Row_Num,
	NTILE(10)	 OVER(ORDER BY val) AS Tile_Num
FROM Sales.OrderValues;
GO

/*
Sales.OrderValues: 830 Records

830 / 100 = 8 
830 % 100 = 30
*/
SELECT
	orderid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS Row_Num,
	NTILE(100)	 OVER(ORDER BY val) AS Tile_Num
FROM Sales.OrderValues;
GO


/*
Sales.OrderValues: 830 Records

830 / 10 = 83 
830 % 10 = 0
*/
SELECT
	orderid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS Row_Num,
	NTILE(10)	 OVER(ORDER BY val) AS Tile_Num
FROM Sales.OrderValues;
GO

/*
Sales.OrderValues: 830 Records

830 / 100 = 8 
830 % 100 = 30
*/
SELECT
	orderid, val,
	ROW_NUMBER() OVER(ORDER BY val) AS Row_Num,
	NTILE(100)	 OVER(ORDER BY val) AS Tile_Num
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

/*
NonDeterministic
!!! آن‌ها Range تقسیم‌بندی و دسته‌بندی براساس تعداد رکوردها خواهد بود ونه براساس محدوده یا
*/
SELECT
	orderid, val,
	ROW_NUMBER() OVER(ORDER BY val, orderid) AS Row_Num,
	NTILE(10)    OVER(ORDER BY val, orderid) AS Tile_Num
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

/*
کوئری‌ای که براساس چارک‌های سال 2017 میزان مجموع فروش
.از کمترین تا بیشترین مقدار را در هر ماه از آن سال مشخص کند

OrderMonth    Total     Tile_Num
----------- ----------  ----------
    6        36362.82      1
    2        38483.64      1
    3        38547.23      1
    11       43533.80      2
    8        47287.68      2
    7        51020.86      2
    4        53032.95      3
    5        53781.30      3
    9        55629.27      3
    1        61258.08      4
    10       66749.23      4
    12       71398.44      4

(12 rows affected)

*/
WITH C1
AS
(
	SELECT
		MONTH(orderdate) AS OrderMonth,
		SUM(val) AS Total
	FROM Sales.OrderValues
		WHERE orderdate BETWEEN '20170101' AND '20171231'
	GROUP BY MONTH(orderdate)
)
SELECT
	OrderMonth,
	Total,
	NTILE(4) OVER(ORDER BY Total)
FROM C1;


SELECT
	MONTH(orderdate) AS OrderMonth,
	SUM(val) AS Total,
	NTILE(4) OVER(ORDER BY SUM(val)) AS Tile_Num
FROM Sales.OrderValues
	WHERE orderdate BETWEEN '2017-01-01' AND '2017-12-31'
GROUP BY MONTH(orderdate);
GO
--------------------------------------------------------------------
