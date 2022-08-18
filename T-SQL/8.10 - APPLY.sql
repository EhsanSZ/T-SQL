USE Test_DB;
GO

SELECT
	E1.EmployeeID AS E1_Emp, E2.EmployeeID AS E2_Emp
FROM dbo.Employees AS E1
CROSS APPLY
	 dbo.Employees AS E2; -- .را دارد CROSS JOIN همان کارکرد
GO
--------------------------------------------------------------------

/*
APPLY & Derived Table
*/

-- نمایش 3 سفارش اخیر مشتری 1 
SELECT
	TOP (3) O.CustomerID, O.OrderID, o.OrderDate
FROM dbo.Orders AS O
	WHERE O.CustomerID = 1 -- 1 ... 91
ORDER BY O.OrderDate DESC;
GO

/*
نمایش 3 سفارش اخیر هر مشتری 
APPLY در سمت راست عملگر Derived Table با استفاده از
*/
SELECT
	C.CustomerID, C.CompanyName, Tmp.OrderID
FROM dbo.Customers AS C
CROSS APPLY
	(SELECT TOP(3) O.OrderID FROM dbo.Orders AS O
		WHERE O.CustomerID = C.CustomerID) AS Tmp;
GO


/*
نمایش سه سفارش اخیر هر مشتری حتی مشتریان فاقد سفارش 
APPLY در سمت راست عملگر Derived Table با استفاده از
*/
SELECT
	C.CustomerID, C.CompanyName, Tmp.OrderID, Tmp.OrderDate
FROM dbo.Customers AS C
OUTER APPLY
	(SELECT TOP(3) O.OrderID, O.OrderDate FROM dbo.Orders AS O
		WHERE O.CustomerID = C.CustomerID) AS Tmp;
GO
--------------------------------------------------------------------

/*
APPLY & TVF
*/

/*
تابعی که قبلا نوشتم

DROP FUNCTION IF EXISTS dbo.Top_Orders;
GO

CREATE FUNCTION dbo.Top_Orders(@CustID AS INT, @n AS TINYINT)
RETURNS TABLE
AS
RETURN
	SELECT
		TOP (@n) OrderID, CustomerID, OrderDate
	FROM dbo.Orders
		WHERE CustomerID = @CustID
	ORDER BY OrderDate DESC, OrderID DESC;
GO
*/

-- فراخوانی تابع
SELECT * FROM dbo.Top_Orders(1,5);
GO

/*
نمایش سه سفارش اخیر هر مشتری 
APPLY در سمت راست عملگر TVF با استفاده از
*/
SELECT
	C.CustomerID, C.CompanyName, T.OrderID, T.OrderDate
FROM dbo.Customers AS C
CROSS APPLY dbo.Top_Orders(C.CustomerID,4) AS T;
GO