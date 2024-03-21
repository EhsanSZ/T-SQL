
USE WF;
GO

-- Partitioning & Ordering
SELECT
	custid, orderid, orderdate, val,
	LEAD(Val) OVER( PARTITION BY custid 
				    ORDER BY orderdate, orderid ) AS Nxt_Val
FROM Sales.OrderValues;
GO

-- Partitioning & Ordering
SELECT
	custid, empid, orderid, orderdate, val,
	LEAD(Val) OVER( PARTITION BY custid, empid
				    ORDER BY orderdate, orderid ) AS Nxt_Val
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

-- Ordering
SELECT
	custid, orderid, orderdate, val,
	LEAD(Val) OVER(ORDER BY orderdate, orderid) AS Nxt_Val
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

-- Custom Offset Parameter
SELECT
	custid, orderid, orderdate, val,
	LEAD(Val,0) OVER( PARTITION BY custid 
					  ORDER BY orderdate, orderid ) AS Curnt_Val
FROM Sales.OrderValues;
GO

SELECT
	custid, orderid, orderdate, val,
	LEAD(Val,3) OVER( PARTITION BY custid 
					  ORDER BY orderdate, orderid ) AS Nxt3_Val
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

-- Custom Offset Parameter & Default Value
SELECT
	custid, orderid, orderdate, val,
	LEAD(Val,3,-1) OVER( PARTITION BY custid 
						 ORDER BY orderdate, orderid ) AS Nxt3_Val
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

/*
.کوئری زیر را با روش دلخواه بازنویسی کنید
SELECT
	custid, orderdate, orderid, val,
	LEAD(Val) OVER( PARTITION BY custid 
				    ORDER BY orderdate, orderid ) AS Nxt_Val
FROM Sales.OrderValues;
GO
*/

WITH CTE
AS
(
	SELECT
		custid, orderdate, orderid, val,
		ROW_NUMBER() OVER(ORDER BY custid, orderdate, orderid ) AS Nxt_Val
	FROM Sales.OrderValues
)
SELECT
	CTE.custid, CTE.orderdate, CTE.orderid, CTE.val,
	C.Val AS Prv_Val
FROM CTE
LEFT JOIN CTE AS C
	ON CTE.custid = C.custid
	AND CTE.Nxt_Val = C.Nxt_Val - 1;
GO

-- روش دیگر
SELECT
	custid, orderdate, orderid, val,
	MIN(Val) OVER( PARTITION BY custid 
				   ORDER BY orderdate, orderid
				   ROWS BETWEEN 1 FOLLOWING
							AND 1 FOLLOWING ) AS Prv_Val
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

-- های مختلف WF ترکیب
SELECT
	ROW_NUMBER() OVER (ORDER BY custid) AS Row_Num,
	custid, orderid, orderdate , val,
	LAG(Val)  OVER( PARTITION BY custid
				    ORDER BY custid ) AS Prv_Val,
	LEAD(Val) OVER( PARTITION BY custid
					ORDER BY custid ) AS Nxt_Val,
	SUM(Val)  OVER( PARTITION BY custid
					ORDER BY orderdate, orderid) AS Sum_Val
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------