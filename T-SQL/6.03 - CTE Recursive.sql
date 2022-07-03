USE Test_DB;
GO

/*
CTE Recutsive:

WITH <CTE_Name> [(<Column_List>)]
AS
(
	<Anchor_Member>
	UNION ALL
	<Recursive_Member>
)
<Outer_Query_Against_CTE>;
*/


/*
تولید اعداد 1 تا 1000
با روش‌های مختلف
*/

-- روش اول) CROSS JOIN با استفاده از 
DROP TABLE IF EXISTS dbo.Digits;
GO

CREATE TABLE Digits
(
	Num TINYINT
);
GO

INSERT dbo.Digits
	VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9);
GO

SELECT 
	(D1.Num + 1) + (D2.Num * 10) + (D3.Num * 100) AS Num 
FROM dbo.Digits D1
CROSS JOIN dbo.Digits D2
CROSS JOIN dbo.Digits D3
ORDER BY Num;
GO


-- روش دوم) Derived Table با استفاده از
SELECT Tmp1.Num FROM 
(SELECT 1 AS Num UNION ALL SELECT 1)Tmp1
CROSS JOIN	 
(SELECT 1 AS Num UNION ALL SELECT 1)Tmp2
CROSS JOIN	 
(SELECT 1 AS Num UNION ALL SELECT 1)Tmp3
CROSS JOIN	 
(SELECT 1 AS Num UNION ALL SELECT 1)Tmp4;
GO -- 16 REC

-- روش سوم) CTE Non-Recursive با استفاده از
WITH 
	CTE1
	AS 
	(
		SELECT 1 AS Num UNION ALL SELECT 1
	),
	CTE2 
	AS
	(
		SELECT C1.Num FROM CTE1 AS C1 CROSS JOIN CTE1 AS C2
	),
	CTE3
	AS
	(
		SELECT C1.Num FROM CTE2 AS C1 CROSS JOIN CTE2 AS C2
	)
	SELECT Num FROM CTE3;
GO

-- روش چهارم) CTE Recursive با استفاده از
WITH CTE
AS
(
	SELECT 1 AS Num --Anchor_Member
		UNION ALL
	SELECT Num + 1 AS Num FROM CTE
		WHERE Num < 1000  --Recursive_Member
)
SELECT * FROM CTE
OPTION(MAXRECURSION 1000)
GO
/*
MAXRECURSION : 0 (Infinite)
MAXRECURSION : 100 (Default)
MAXRECURSION : 32767 (Max Value)
*/

-- CROSS JOIN با CTE Recursive مقایسه
SELECT 
	(D1.Num + 1) + (D2.Num * 10) + (D3.Num * 100) AS Num 
FROM dbo.Digits D1
CROSS JOIN dbo.Digits D2
CROSS JOIN dbo.Digits D3
ORDER BY Num;
GO
--------------------------------------------------------------------

SELECT * FROM dbo.Employees;
GO

/*نمایش زیر‌مجموعه‌های کارمند شماره 2 از طریق متغیر جدول*/
DROP TABLE IF EXISTS #Tbl;

CREATE TABLE #Tbl
	(EmployeeID INT, Mgrid TINYINT,
	 FirstName NVARCHAR(100),LastName NVARCHAR(100));

INSERT INTO #Tbl
SELECT
	EmployeeID, Mgrid, Firstname, Lastname
FROM dbo.Employees
	WHERE EmployeeID = 2;

SELECT * FROM #Tbl;

INSERT INTO #Tbl
SELECT
	E.EmployeeID,E.mgrid,E.FirstName,E.LastName
FROM #Tbl AS T
JOIN dbo.Employees AS E
	ON T.EmployeeID = E.mgrid;
GO

SELECT * FROM #Tbl;
-- ... و این داستان هم‌چنان ادامه خواهد داشت				


/* CTE Recutsive نمایش زیر‌مجموعه‌های کارمند شماره 2 از طریق */
WITH Employees_CTE
AS
(
	SELECT
		EmployeeID, mgrid, Firstname, Lastname
	FROM dbo.Employees
		WHERE EmployeeID = 2 -- Anchor_Member

	UNION ALL

	SELECT
		E.EmployeeID, E.mgrid, E.Firstname, E.Lastname
	FROM Employees_CTE AS Emp_CTE
	JOIN dbo.Employees AS E
		ON E.mgrid = Emp_CTE.EmployeeID -- Recursive_Member
)
SELECT
	EmployeeID, mgrid, Firstname, Lastname
FROM Employees_CTE;
GO