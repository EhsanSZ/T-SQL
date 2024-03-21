
USE WF;
GO

--Gap & Numeric Values
DROP TABLE IF EXISTS dbo.Gap_Numeric;
GO

CREATE TABLE dbo.Gap_Numeric
(
	Col1 INT PRIMARY KEY
);
GO

INSERT INTO dbo.Gap_Numeric(Col1)
VALUES
	(2),(3),(7),(8),(9),(11),(15),(16),(17),(28);
GO

SELECT * FROM dbo.Gap_Numeric;
GO

/*
Gap_Numeric با توجه به‌مقادیر موجود در جدول
:به‌صورت زیر خواهد بود Gap محدوده

Range_Start   Range_End
-----------  -----------
    4           6
    10          10
    12          14
    18          27
*/

WITH CTE
AS
(
	SELECT
		Col1 AS Crnt,
		LEAD(Col1) OVER(ORDER BY Col1) AS Nxt
	FROM dbo.Gap_Numeric
)
SELECT
	Crnt + 1 AS Range_Start,
	Nxt - 1 AS Range_End
FROM CTE
	WHERE Nxt - Crnt > 1;
GO
--------------------------------------------------------------------

--Gap & Date Values
DROP TABLE IF EXISTS dbo.Gap_Date;
GO

CREATE TABLE dbo.Gap_Date
(
  Col1 DATE PRIMARY KEY
);
GO

INSERT INTO dbo.Gap_Date(Col1)
VALUES
	('20120202'),
	('20120203'),
	('20120207'),
	('20120208'),
	('20120209'),
	('20120211'),
	('20120215'),
	('20120216'),
	('20120217'),
	('20120228');
GO

SELECT * FROM dbo.Gap_Date;
GO

/*
Gap_Date با توجه به‌مقادیر موجود در جدول
:به‌صورت زیر خواهد بود Gap محدوده

Range_Start  Range_End
-----------  ----------
2012-02-04   2012-02-06
2012-02-10   2012-02-10
2012-02-12   2012-02-14
2012-02-18   2012-02-27
*/

WITH CTE
AS
(
	SELECT
		Col1 AS Crnt,
		LEAD(Col1) OVER(ORDER BY Col1) AS Nxt
	FROM dbo.Gap_Date
)
SELECT
	DATEADD(DAY, 1, Crnt) AS Range_Start,
	DATEADD(DAY, -1, Nxt) Range_End
FROM CTE
	WHERE DATEDIFF(DAY, Crnt, Nxt) > 1;
GO

https://www.red-gate.com/simple-talk/sql/t-sql-programming/introduction-to-gaps-and-islands-analysis/