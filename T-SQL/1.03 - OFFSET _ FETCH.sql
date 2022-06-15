
USE Test_DB;
GO


-- نمایش 10 سفارش ثبت‌شده اخیر
SELECT 
	TOP (10) OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders
ORDER BY OrderDate DESC;
GO

-- OFFSET FETCH شبیه‌سازی کوئری بالا با استفاده از 
SELECT 
	OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders
ORDER BY OrderDate DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
GO

/*
جدیدترین 5 سفارش پس از 10 سفارش اخیر
یعنی سفارش‌های 11 تا 15
*/
SELECT
	OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders
ORDER BY OrderDate DESC;
GO
SELECT
	OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders
ORDER BY OrderDate DESC
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;
GO

/*
FETCH بدون OFFSET
نادیده گرفتن 10 سفارش ابتدایی از لیست رکوردها بر اساس نوع مرتب‌سازی و نمایش سایر رکوردها
*/
SELECT 
	OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders
ORDER BY OrderDate DESC, OrderID DESC
OFFSET 10 ROWS;
GO

-- !!!قابل اجرا نیست OFFSET بدون FETCH
SELECT 
	OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders
ORDER BY OrderDate DESC, OrderID DESC
FETCH NEXT 5 ROWS ONLY;
GO

/*
:نکته مهم
OFFSET FETCH در PERCENT و WITH TIES عدم پشتیبانی از  
*/
--------------------------------------------------------------------

/* Logical Order
-- SELECT ترتیب اجرای منطقی بخش‌های مخالف دستور

1- FROM
2- WHERE
3- GROUP BY
4- HAVINGR
5- SELECT
	5-1 Expressions
	5-2 DISTINCT
6- ORDER BY
7- TOP / OFFSET-FETCH

*/