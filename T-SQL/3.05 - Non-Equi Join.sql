USE Test_DB;
GO
/*
Non-Equi Join
*/

-- ترکیب دو تایی از نام و نام‌خانوادگی کارمندان
SELECT
	E1.EmployeeID, E1.FirstName, E1.LastName,
	E2.EmployeeID, E2.FirstName, E2.LastName
FROM dbo.Employees AS E1
CROSS JOIN dbo.Employees AS E2
ORDER BY E1.FirstName, E1.LastName;
GO

-- Equi Join
SELECT
	E1.EmployeeID, E1.FirstName, E1.LastName,
	E2.EmployeeID, E2.FirstName, E2.LastName
FROM dbo.Employees AS E1
JOIN dbo.Employees AS E2
	ON E1.EmployeeID = E2.EmployeeID;
GO

-- Non-Equi Join
-- تمامی ترکیبات دو تایی غیر‌تکراری از نام و نام‌خانوادگی کارمندان
SELECT
	E1.EmployeeID, E1.FirstName, E1.LastName,
	E2.EmployeeID, E2.FirstName, E2.LastName
FROM dbo.Employees AS E1
JOIN dbo.Employees AS E2
	ON E1.EmployeeID > E2.EmployeeID;
GO

/*
 تمامی ترکیبات دو تایی از نام و نام‌خانوادگی کارمندان
.به‌جز حالت تشابه میان یک کارمند با خودش را در خروجی نمایش دهد
*/

SELECT
	E1.EmployeeID, E1.FirstName, E1.LastName,
	E2.EmployeeID, E2.FirstName, E2.LastName
FROM dbo.Employees AS E1
JOIN dbo.Employees AS E2
	ON E1.EmployeeID <> E2.EmployeeID;
GO

/*
SQL تفسیر کوئری بالا به زبان
.آن فیلتر شده است INNER JOIN ای است که بخشCROSS JOIN
*/