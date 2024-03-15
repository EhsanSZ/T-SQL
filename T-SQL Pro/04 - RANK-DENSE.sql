USE WF;
GO

/*
ROW_NUMBER, RANK, DENSE_RANK
!نیست Unique به‌صورت orderdate توجه داشته باشید که در کوئری زیر مقادیر فیلد
*/
SELECT
	orderid, orderdate, val,
	ROW_NUMBER() OVER(ORDER BY orderdate DESC) AS Row_Num,
	RANK()       OVER(ORDER BY orderdate DESC) AS Rnk,
	DENSE_RANK() OVER(ORDER BY orderdate DESC) AS D_Rnk
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

/*
شبیه‌سازی
 DENSE_RANK و RANK عملیات مربوط به توابع
orderid          orderdate           val       Rnk   D_Rnk
--------  -----------------------  --------  ------ -------
11077     2018-05-06 00:00:00.000  1255.72     1      1
11076     2018-05-06 00:00:00.000  792.75      1      1
11075     2018-05-06 00:00:00.000  498.10      1      1
...		 						   		       
10250     2016-07-08 00:00:00.000  1552.60     827    478
10249     2016-07-05 00:00:00.000  1863.40     829    479
10248     2016-07-04 00:00:00.000  440.00      830    480

(830 rows affected)
*/
SELECT
	O1.orderid, O1.orderdate, O1.val,
	(SELECT COUNT(O2.orderdate) FROM Sales.OrderValues AS O2
		WHERE O2.orderdate > O1.orderdate) + 1 AS Rnk,
	(SELECT COUNT( DISTINCT O2.orderdate) FROM Sales.OrderValues AS O2
		WHERE O2.orderdate > O1.orderdate) + 1 AS D_Rnk
FROM Sales.OrderValues AS O1
ORDER BY O1.orderdate DESC;
GO
--------------------------------------------------------------------

-- RANK, DENSE_RANK (Ordering & Partitioning)
SELECT
	custid, orderid, orderdate, val,
	RANK()       OVER(PARTITION BY custid ORDER BY orderdate DESC) AS Rnk,
	DENSE_RANK() OVER(PARTITION BY custid ORDER BY orderdate DESC) AS D_Rnk
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

/*
رتبه‌بندی DENSE_RANK کوئری‌ای  که با استفاده از تابع
.هر مشتری را براساس تعداد سفارشاتی که داشته است، انجام دهد

custid  Num_Orders   D_Rnk
------  ----------- -------
 71         31         1
 20         30         2
 63         28         3
 ...	       			 
 33         2          20
 43         2          20
 13         1          21

(89 rows affected)
*/
SELECT
	custid,
	COUNT(orderid) AS Num_Orders,
	DENSE_RANK() OVER(ORDER BY COUNT(orderid) DESC) AS D_Rnk
FROM Sales.OrderValues
GROUP BY custid;
GO