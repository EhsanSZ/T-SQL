
USE Test_DB;
GO

/*
Exersice 01
نمایش سطح هر کارمند در ساختار سلسه مراتبی
*/

WITH Employees_CTE
AS
(
	SELECT
		EmployeeID, Mgrid, Firstname, Lastname, 1 AS Employee_Level
	FROM dbo.Employees
		WHERE EmployeeID = 2 -- Anchor_Member

	UNION ALL

	SELECT
		E.EmployeeID, E.Mgrid, E.Firstname, E.Lastname, Emp_CTE.Employee_Level + 1
	FROM Employees_CTE AS Emp_CTE
	JOIN dbo.Employees AS E
		ON E.Mgrid = Emp_CTE.EmployeeID -- Recursive_Member
)
SELECT
	EmployeeID, Mgrid, Firstname, Lastname, Employee_Level
FROM Employees_CTE;
GO
--------------------------------------------------------------------

/*
Exersice 02
VIEW تعداد کالای ثبتِ‌سفارش شده توسط هر کارمند در هر سال با استفاده از
مجموع تعداد کالاهای ثبت شده در هر سال VIEW و در ادامه با استفاده از
.با مجموع سال‌های قبلی همان کارمند محاسبه شود
*/

--------------------------------
	/* VIEW With JOIN */
--------------------------------
DROP VIEW IF EXISTS dbo.VJ_Employee_Orders;
GO

-- VIEW ایجاد
CREATE VIEW dbo.VJ_Employee_Orders
AS
SELECT
	O.EmployeeID, YEAR(O.OrderDate) AS OrderYear,
	SUM(OD.Qty) AS Qty
FROM dbo.Orders AS O
JOIN dbo.OrderDetails AS OD
	ON O.OrderID = OD.OrderID
GROUP BY O.EmployeeID, YEAR(O.OrderDate);
GO

-- VIEW فراخوانی
SELECT * FROM VJ_Employee_Orders
ORDER BY EmployeeID;
GO

-- جهت نمایش تعداد سفارشات هر سال و سال‌های ماقبل آن VIEW فراخوانی
SELECT
	V1.EmployeeID, V1.OrderYear, V1.Qty, SUM(V2.Qty) AS Total
FROM dbo.VJ_Employee_Orders AS V1
JOIN dbo.VJ_Employee_Orders AS V2
	ON V1.EmployeeID = V2.EmployeeID
	AND V1.OrderYear >= V2.OrderYear
GROUP BY V1.EmployeeID, V1.OrderYear, V1.Qty
ORDER BY V1.EmployeeID;
GO

-- ???
SELECT
	V1.EmployeeID, V1.OrderYear, V1.Qty,
	SUM(V1.Qty) AS Total
FROM dbo.VJ_Employee_Orders AS V1
JOIN dbo.VJ_Employee_Orders AS V2
	ON V1.OrderYear >= V2.OrderYear
	AND V1.EmployeeID = V2.EmployeeID
GROUP BY V1.EmployeeID, V1.OrderYear, V1.Qty
ORDER BY V1.EmployeeID;
GO

--------------------------------
	/* 
	VIEW With Subquery 
	Outer Query: Orders
	Subquery: OrderDetails
	*/
--------------------------------
DROP VIEW IF EXISTS dbo.VS_Employee_Orders;
GO

-- VIEW ایجاد
CREATE VIEW dbo.VS_Employee_Orders
AS
	SELECT
		O.EmployeeID, YEAR(O.OrderDate) AS OrderYear,
		(SELECT SUM(Qty) FROM dbo.OrderDetails AS OD
			WHERE O.OrderID = OD.OrderID) AS Qty
	FROM dbo.Orders AS O
	GROUP BY O.EmployeeID, YEAR(O.OrderDate), O.OrderID
GO

SELECT * FROM VS_Employee_Orders;
GO

-- رفع مشکل کوئری بالا
DROP VIEW IF EXISTS dbo.VS_Employee_Orders;
GO

CREATE VIEW dbo.VS_Employee_Orders
AS
SELECT
	O.EmployeeID,
	YEAR(O.OrderDate) AS OrderYear,
	(SELECT SUM(OD.Qty) FROM dbo.OrderDetails AS OD
		WHERE EXISTS (SELECT 1 FROM dbo.Orders
						WHERE YEAR(Orders.OrderDate) = YEAR(O.OrderDate)
						AND OD.OrderID = Orders.OrderID
						AND Orders.EmployeeID = O.EmployeeID)) AS Qty
FROM dbo.Orders AS O
GROUP BY O.EmployeeID, YEAR(O.OrderDate);
GO

-- VIEW فراخوانی
SELECT * FROM dbo.VS_Employee_Orders
ORDER BY EmployeeID;
GO

-- جهت نمایش تعداد سفارشات هر سال و سال‌های ماقبل آن VIEW فراخوانی
SELECT
	V1.EmployeeID, V1.OrderYear, V1.Qty,
	SUM(V2.Qty) AS Total
FROM dbo.VS_Employee_Orders AS V1
JOIN dbo.VS_Employee_Orders AS V2
	ON V1.EmployeeID = V2.EmployeeID
	AND V1.OrderYear >= V2.OrderYear
GROUP BY V1.EmployeeID, V1.OrderYear, V1.Qty;
GO

------------------------------------
	/* VIEW With Derived Table */
------------------------------------
SELECT
	O.EmployeeID,
	YEAR(O.OrderDate) AS OrderYear,
	(SELECT SUM(OD.Qty) FROM dbo.OrderDetails AS OD
		WHERE O.OrderID = OD.OrderID) AS Qty
FROM dbo.Orders AS O;
GO

DROP VIEW IF EXISTS dbo.VDT_Employee_Orders;
GO

-- VIEW ایجاد
CREATE VIEW dbo.VDT_Employee_Orders
AS
SELECT
	Tmp.EmployeeID,
	Tmp.OrderYear,
	SUM(Tmp.Qty) AS Qty
FROM
(SELECT
	O.EmployeeID,
	YEAR(O.OrderDate) AS OrderYear,
	(SELECT SUM(OD.Qty) FROM dbo.OrderDetails AS OD
		WHERE O.OrderID = OD.OrderID) AS Qty
FROM dbo.Orders AS O) AS Tmp
GROUP BY Tmp.EmployeeID, Tmp.OrderYear;
GO

-- جهت نمایش تعداد سفارشات هر سال و سال‌های ماقبل آن VIEW فراخوانی
SELECT
	V1.EmployeeID, V1.OrderYear, V1.Qty,
	SUM(V2.Qty) AS Total
FROM dbo.VDT_Employee_Orders AS V1
JOIN dbo.VDT_Employee_Orders AS V2
	ON V1.EmployeeID = V2.EmployeeID
	AND V1.OrderYear >= V2.OrderYear
GROUP BY V1.EmployeeID, V1.OrderYear, V1.Qty
ORDER BY EmployeeID;
GO

-- جهت نمایش تعداد سفارشات هر سال و سال‌های ماقبل آن VIEW فراخوانی
SELECT
	V1.EmployeeID, V1.OrderYear, V1.Qty,
	(SELECT SUM(V2.Qty) FROM dbo.VDT_Employee_Orders AS V2
		WHERE V2.EmployeeID = V1.EmployeeID
		AND V2.OrderYear <= V1.OrderYear) AS Total
FROM dbo.VDT_Employee_Orders AS V1
ORDER BY EmployeeID;
GO

-- Window Function معجزه‌ای به نام
SELECT
	V.EmployeeID, V.OrderYear, V.Qty,
	SUM(V.Qty) OVER(PARTITION BY V.EmployeeID ORDER BY V1.OrderYear
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS Total
FROM dbo.VJ_Employee_Orders AS V;
GO