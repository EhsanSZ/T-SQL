
USE WF;
GO

SELECT
	orderid, val,
	ROW_NUMBER() OVER(ORDER BY orderid) AS Row_Num
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

-- بر روی بیش از یک فیلد Ordering
SELECT
	orderid, custid, empid, val,
	ROW_NUMBER() OVER(ORDER BY custid DESC, empid) AS Row_Num
FROM Sales.OrderValues;
GO
--------------------------------------------------------------------

-- OVER از بخش ORDER BY مربوط به عبارت Cost حذف

DROP TABLE IF EXISTS Test_Cost;
GO

CREATE TABLE Test_Cost
(
	ID INT IDENTITY,
	Family NVARCHAR(100)
);
GO

SET NOCOUNT ON;
GO

INSERT INTO Test_Cost
	VALUES (N'بهرامی'),(N'سعادت'),(N'پویا'),(N'اکبری'),(N'شجاعیان');
GO 1000

SELECT * FROM Test_Cost;
GO

-- .دیده می‌شود Sort در پلن کوئری اپراتور
SELECT
	*, ROW_NUMBER() OVER(ORDER BY Family) AS Row_Num
FROM Test_Cost;
GO

-- .دیده نخواهد شد Sort در پلن کوئری اپراتور
SELECT
	*, ROW_NUMBER() OVER(ORDER BY (SELECT NULL)) AS Row_Num
FROM Test_Cost;
GO

-- .دیده نخواهد شد Sort در پلن کوئری اپراتور
SELECT
	*, ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS Row_Num
FROM Test_Cost;
GO

-- .دیده نخواهد شد Sort در پلن کوئری اپراتور
SELECT
	*, ROW_NUMBER() OVER(ORDER BY (SELECT 100)) AS Row_Num
FROM Test_Cost;
GO
--------------------------------------------------------------------

DROP TABLE IF EXISTS T1;
GO

CREATE TABLE T1
(
	Col1 CHAR(1) NOT NULL
);
GO

INSERT INTO T1
	VALUES ('A'),('B'),('C'),('D'),('E'),('F');
GO

-- WHERE ها در بخش WF عدم استفاده از

-- CTE دور زدن محدودیت با استفاده از
WITH CTE
AS
(
	SELECT
		orderid, orderdate, val,
		ROW_NUMBER() OVER(ORDER BY orderdate) AS Row_Num
	FROM Sales.OrderValues
)
SELECT * FROM CTE
	WHERE Row_Num > 100;
GO

-- Derived Table دور زدن محدودیت با استفاده از
SELECT * FROM
(
	SELECT
		orderid, orderdate, val,
		ROW_NUMBER() OVER(ORDER BY orderdate) AS Row_Num
	FROM Sales.OrderValues
) AS Tmp
	WHERE Tmp.Row_Num > 100;
GO
--------------------------------------------------------------------

/*
 country   Row_Num
--------  --------
  UK         1
  USA        2

(2 rows affected)
*/

-- CTE
WITH CTE
AS
(
	SELECT
		DISTINCT country
	FROM HR.Employees
)
SELECT
	country,
	ROW_NUMBER() OVER(ORDER BY country) AS Row_Num
FROM CTE;
GO

-- Derived Table
SELECT
	Tmp.country,
	ROW_NUMBER() OVER(ORDER BY Tmp.country) AS Row_Num
FROM
(
	SELECT
		DISTINCT country
	FROM HR.Employees
) AS Tmp;
GO