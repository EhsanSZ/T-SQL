
USE Test_DB;
GO

-- مشاهده جدیدترین 5 سفارش ثبت‌شده
SELECT
	TOP (5) OrderID, OrderDate
FROM dbo.Orders
ORDER BY OrderDate DESC;
GO

-- مشاهده قدیمی‌ترین 5 سفارش ثبت‌شده
SELECT
	TOP (5) OrderID, OrderDate
FROM dbo.Orders
ORDER BY OrderDate;
GO


-- انتخاب پنج درصد از جدیدترین سفارش‌های ثبت‌شده
SELECT
	TOP (5) PERCENT OrderID, OrderDate
FROM dbo.Orders
ORDER BY OrderDate DESC;
GO

--  انتخاب جدیدترین پنج سفارش ثبت‌شده با درنظر گرفتن سایر مقادیر برابر
SELECT
	TOP (5) WITH TIES OrderID, OrderDate, CustomerID, EmployeeID
FROM dbo.Orders
ORDER BY OrderDate DESC;
GO