

USE Test_DB;
GO

/*
Exersice 01
مجموع تمامی تعداد سفارشات مشتریان شهرهای تهران، شیراز و اصفهان
*/

/*
Subquery

Outer Query: Orders
Subquery: Customers
*/
SELECT
	(SELECT C.City FROM dbo.Customers AS C
		WHERE C.CustomerID = O.CustomerID
		AND C.City IN(N'تهران',N'شیراز',N'اصفهان')) AS City,
	COUNT(O.OrderID) AS Num
FROM dbo.Orders AS O
GROUP BY O.CustomerID;
GO

/*
Subquery

Outer Query: Customers
Subquery: Orders
*/
SELECT
	C.City,
	(SELECT COUNT(O.OrderID) FROM dbo.Orders AS O
		WHERE O.CustomerID = C.CustomerID) AS Num
FROM dbo.Customers AS C
	WHERE C.City IN(N'تهران',N'شیراز',N'اصفهان')
GROUP BY C.City,C.CustomerID;
GO

-- اصلاح روش بالا
SELECT
	C.City,
	(SELECT COUNT(O.OrderID) FROM dbo.Orders AS O
		WHERE EXISTS(SELECT 1 FROM dbo.Customers AS C1
						WHERE C1.CustomerID = O.CustomerID
						AND C1.City = C.City)) AS Num
FROM dbo.Customers AS C
	WHERE C.City IN(N'تهران',N'شیراز',N'اصفهان')
GROUP BY C.City;
GO



-- Derived Table
SELECT
	Tmp.City,
	SUM(Tmp.Num) AS Num
FROM
(
	SELECT
		C.City,
		(SELECT COUNT(O.OrderID) FROM dbo.Orders AS O
			WHERE O.CustomerID = C.CustomerID) AS Num
	FROM dbo.Customers AS C
		WHERE C.City IN(N'تهران',N'شیراز',N'اصفهان')
	GROUP BY C.City,C.CustomerID
) AS Tmp
GROUP BY Tmp.City;
GO


-- CTE
WITH CTE
AS
(
	SELECT
		C.City,
		(SELECT COUNT(O.OrderID) FROM dbo.Orders AS O
			WHERE O.CustomerID = C.CustomerID) AS Num
	FROM dbo.Customers AS C
		WHERE C.City IN(N'تهران',N'شیراز',N'اصفهان')
	GROUP BY C.City,C.CustomerID
)


SELECT
	City, SUM(Num) AS Num
FROM CTE
GROUP BY City;
GO

-- JOIN
SELECT
	C.City,
	COUNT(O.OrderID) AS Num
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
	WHERE C.City IN(N'تهران',N'شیراز',N'اصفهان')
GROUP BY C.City;
GO
--------------------------------------------------------------------

/*
Exersice 02
کوئری زیر علاوه بر نمایش تعداد سفارشات و جدیدترین سفارش هر کارمند
.همین اطلاعات را در همان سطر و به‌ازای رئیس‌اش نیز انجام می‌دهد
*/

SELECT
	E.EmployeeID, OE.NumOrders, OE.MaxDate
	,OM.Employeeid, OM.NumOrders, OM.MaxDate
FROM dbo.Employees AS E
JOIN
(SELECT
	EmployeeID, COUNT(*) AS NumOrders, MAX(OrderDate) AS MaxDate
 FROM dbo.Orders
 GROUP BY EmployeeID) AS OE
	ON E.EmployeeID = OE.EmployeeID
LEFT JOIN
(SELECT
	EmployeeID, COUNT(*) AS NumOrders, MAX(OrderDate) AS MaxDate
 FROM dbo.Orders
 GROUP BY EmployeeID) AS OM
	ON E.mgrid = OM.EmployeeID;
GO

/*
CTE بازنویسی با
*/
WITH Emp_Cnt_Max
AS
(
	SELECT
		EmployeeID, COUNT(*) AS NumOrders, MAX(OrderDate) AS MaxDate
	FROM dbo.Orders
	GROUP BY EmployeeID
)
SELECT
	ECM1.EmployeeID, ECM1.NumOrders, ECM1.MaxDate,
	ECM2.EmployeeID, ECM2.NumOrders, ECM2.MaxDate
FROM Emp_Cnt_Max AS ECM1
JOIN dbo.Employees AS E
	ON E.EmployeeID = ECM1.EmployeeID
LEFT JOIN Emp_Cnt_Max AS ECM2
	ON E.mgrid = ECM2.EmployeeID;
GO

/*
CTE بازنویسی با
*/
WITH Emp_Cnt_Max
AS
(
	SELECT
		EmployeeID, COUNT(*) AS NumOrders, MAX(OrderDate) AS MaxDate,
		(SELECT E.mgrid FROM dbo.Employees AS E
			WHERE E.EmployeeID = O.EmployeeID) AS Mgrid
	FROM dbo.Orders AS O
	GROUP BY EmployeeID
)
SELECT
	ECM1.EmployeeID, ECM1.NumOrders, ECM1.MaxDate, ECM1.Mgrid,
	ECM2.NumOrders, ECM2.MaxDate
FROM Emp_Cnt_Max AS ECM1
LEFT JOIN Emp_Cnt_Max AS ECM2
	ON ECM1.Mgrid = ECM2.EmployeeID;
GO
--------------------------------------------------------------------

/*
Exersice 03
.مشخصات کارمند شماره 9 و نفراتی که به‌لحاظ ساختار سازمانی بالاتر از او هستند
*/
WITH CTE
AS
(
	SELECT
		EmployeeID, mgrid, FirstName, LastName
	FROM dbo.Employees
		WHERE EmployeeID = 9

	UNION ALL

	SELECT
		E.EmployeeID, E.mgrid, E.FirstName, E.LastName
	FROM CTE
	JOIN Employees AS E
		ON CTE.mgrid = E.EmployeeID

)
SELECT * FROM CTE;
GO