
USE WF;
GO

-- Partitioning & Ordering
SELECT
	custid, orderid ,orderdate, val,
	LAG(Val) OVER( PARTITION BY custid 
				   ORDER BY orderdate, orderid ) AS Prv_Val
FROM Sales.OrderValues;
GO

-- Partitioning & Ordering
SELECT
	custid, empid, orderid, orderdate, val,
	LAG(Val) OVER( PARTITION BY custid, empid
				   ORDER BY orderdate, orderid ) AS Prv_Val
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

-- Ordering
SELECT
	custid, orderid, orderdate, val,
	LAG(Val) OVER(ORDER BY orderdate, orderid) AS Prv_Val
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

-- Custom Offset Parameter
SELECT
	custid, orderid, orderdate, val,
	LAG(Val,0) OVER( PARTITION BY custid 
				     ORDER BY orderdate, orderid ) AS Curnt_Val
FROM Sales.OrderValues;
GO

SELECT
	custid, orderid, orderdate, val,
	LAG(Val,3) OVER( PARTITION BY custid 
					 ORDER BY orderdate, orderid ) AS Prv3_Val
FROM Sales.OrderValues;
GO

--------------------------------------------------------------------

-- Custom Offset Parameter & Default Value

SELECT
	custid, orderid, orderdate, val,
	LAG(Val,3,'1') OVER( PARTITION BY custid 
						ORDER BY orderdate, orderid ) AS Prv3_Val
FROM Sales.OrderValues;
GO



DROP TABLE IF EXISTS Test_Tbl;
GO

CREATE TABLE Test_Tbl
(
	ID INT IDENTITY,
	Stat VARCHAR(100)
);
GO

INSERT INTO Test_Tbl
	VALUES ('OK'),('Not_OK'),('OK'),('Wait');
GO

SELECT
	*, LAG(Stat,2,'NO_Stat') OVER(ORDER BY Stat) AS Lag_Stat
FROM Test_Tbl;
GO
--------------------------------------------------------------------

/* 
.کوئری زیر را با روش دلخواه بازنویسی کنید

SELECT
	custid, orderdate, orderid, val,
	LAG(Val) OVER( PARTITION BY custid 
				   ORDER BY orderdate, orderid ) AS Prv_Val
FROM Sales.OrderValues;
GO
*/

WITH CTE
AS
(
	SELECT
		custid, orderdate, orderid, val,
		ROW_NUMBER() OVER(ORDER BY custid, orderdate, orderid ) AS Prv_Val
	FROM Sales.OrderValues
)
SELECT
	CTE.custid, CTE.orderdate, CTE.orderid, CTE.val,
	C.Val AS Prv_Val
FROM CTE
LEFT JOIN CTE AS C -- ???
	ON CTE.custid = C.custid
	AND CTE.Prv_Val = C.Prv_Val + 1;
GO

-- روش دیگر
SELECT
	custid, orderdate, orderid, val,
	MIN(Val) OVER( PARTITION BY custid 
				   ORDER BY orderdate, orderid
				   ROWS BETWEEN 1 PRECEDING
							AND 1 PRECEDING ) AS Prv_Val
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------
