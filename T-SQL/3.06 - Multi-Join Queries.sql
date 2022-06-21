
USE Test_DB;
GO

/*
Multi-Join Queries
*/

/*
سفارش هر مشتری به‌همراه عنوان شرکتش، کد سفارش، کد محصول و تعداد سفارش
*/

SELECT
	C.CompanyName,
	O.OrderID,
	OD.ProductID,
	OD.Qty
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
JOIN dbo.OrderDetails AS OD
	ON O.OrderID = OD.OrderID;
GO
--------------------------------------------------------------------

/*
نمایش تمامی سفارشات درخواست‌شده به‌همراه مجموع تمامی کالاهای هر سفارش 
.که مربوط به شرکت‌هایی باشند که در استان تهران هستند
*/
SELECT
	C.CustomerID, C.CompanyName,
	O.OrderID,
	SUM(Qty) AS Quantity 
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
JOIN dbo.OrderDetails AS OD
	ON O.OrderID = OD.OrderID
	WHERE C.State = N'تهران'
GROUP BY C.CustomerID, C.CompanyName, O.OrderID;
GO
--------------------------------------------------------------------

/*
.نمایش تعداد سفارشات به‌همراه مجموع کل محصولات سفارش‌‌شده شرکت‌هایی که در استان تهران هستند
*/

SELECT
	C.CustomerID, C.CompanyName,
	COUNT(DISTINCT O.OrderID) AS NumOrders,
	SUM(OD.Qty) AS TotalQuantity
FROM dbo.Customers AS C
JOIN dbo.Orders AS O
	ON C.CustomerID = O.CustomerID
JOIN dbo.OrderDetails AS OD
	ON O.OrderID = OD.OrderID
	WHERE C.State = N'تهران'
GROUP BY C.CustomerID, C.CompanyName;
GO