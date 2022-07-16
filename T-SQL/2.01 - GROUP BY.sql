USE Test_DB;
GO

/*
GROUP BY و DISTINCT تشابه عملیات
*/
-- DISTINCT
SELECT
	 DISTINCT EmployeeID, CustomerID
FROM dbo.Orders;
GO
-- GROUP BY
SELECT
	EmployeeID, CustomerID
FROM dbo.Orders
GROUP BY EmployeeID, CustomerID;
GO
--------------------------------------------------------------------

-- .شرکت داشته باشند GROUP BY استفاده می‌شوند می‌بایست حتما در SELECT فیلدهایی که در بخش
SELECT
	EmployeeID, CustomerID
FROM dbo.Orders
GROUP BY EmployeeID;--, CustomerID
GO

-- .ظاهر نشده‌اند، استفاده کرد SELECT می‌توان از فیلدهایی که در بخش GROUP BY در بخش
SELECT
	EmployeeID
FROM dbo.Orders
GROUP BY EmployeeID, CustomerID;
GO

-- .شرکت کنند ORDER BY شرکت نکرده‌اند نمی‌توانند در بخش GROUP BY فیلدهایی که در
SELECT
	EmployeeID, CustomerID
FROM dbo.Orders
GROUP BY EmployeeID, CustomerID
ORDER BY OrderID;
GO