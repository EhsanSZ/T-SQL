
USE Test_DB;
GO

/*
Inline Table-Value FUNCTION
*/

DROP VIEW IF EXISTS dbo.Customers_Info;
GO

--.ای كه اطلاعات شرکت و سفارش‌هاي مشتريان را نمايش مي‌دهد VIEW ایجاد
CREATE VIEW dbo.Customers_Info
AS
	SELECT
		C.CompanyName, C.City ,O.OrderID, O.OrderDate    
	FROM dbo.Customers AS C
	JOIN dbo.Orders AS O
		ON C.CustomerID=O.CustomerID; 
GO

--نمايش سفارش هاي مشتريان تهرانی
SELECT * FROM dbo.Customers_Info
	WHERE City= N'تهران';
GO

/*
Inline Table Valued Function
FUNCTION بالا با استفاده از VIEW ایجاد
*/

DROP FUNCTION IF EXISTS dbo.Func_Customers_Info;
GO

CREATE FUNCTION dbo.Func_Customers_Info (@City NVARCHAR(50))
RETURNS TABLE
AS
RETURN
	SELECT
		C.CompanyName, C.City ,O.OrderID, O.OrderDate    
	FROM dbo.Customers AS C
	JOIN dbo.Orders AS O
		ON C.CustomerID=O.CustomerID
		WHERE C.City = @City;
GO

-- فراخوانی تابع
SELECT * FROM dbo.Func_Customers_Info(N'تهران');
GO

/*
JOIN مشاهده جزئیات سفارش کارمندان از طریق
OrderDetails با جدول Func_Customers_Info میان تابع
*/
SELECT * FROM dbo.Func_Customers_Info (N'تهران') AS F
JOIN dbo.OrderDetails AS OD
	ON F.OrderID = OD.OrderID;
GO
--------------------------------------------------------------------

/*
.تابعی که تعداد مشخصی از جدیدترین سفارش یک مشتری را نمایش دهد
پارامترهای ورودی: کد مشتری - عدد مربوط به تعداد سفارشات جدید
*/

DROP FUNCTION IF EXISTS dbo.Top_Orders;
GO

-- ایجاد تابع
CREATE FUNCTION dbo.Top_Orders (@C_ID INT,@N TINYINT)
RETURNS TABLE
AS
RETURN
	SELECT
		TOP (@N) OrderID, CustomerID, OrderDate
	FROM dbo.Orders
		WHERE CustomerID = @C_ID
	ORDER BY OrderDate DESC;
GO

-- فراخوانی تابع
SELECT * FROM dbo.Top_Orders(1,5);
GO