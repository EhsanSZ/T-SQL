USE Test_DB;
GO

/*
IF ... ELSE IF
*/

DECLARE @Var VARCHAR(5) = '';
IF @Var = 'DESC'
BEGIN
	PRINT N'جدید‌ترین ده سفارش';
	SELECT TOP 10 * FROM dbo.Orders
	ORDER BY OrderID DESC;
END
ELSE IF @Var = 'ASC'
BEGIN
	PRINT N'قدیمی‌ترین ده سفارش'
	SELECT TOP 10 * FROM dbo.Orders
	ORDER BY OrderID;
END
ELSE
BEGIN
	PRINT N'ده سفارش تصادفی'
	SELECT TOP 10 * FROM dbo.Orders
	ORDER BY NEWID();
END
GO
--------------------------------------------------------------------

/*
WHILE
اجرای کد در یک حلقه
*/

DECLARE @i AS INT = 1;
WHILE @i <= 10
BEGIN
	SELECT * FROM dbo.Customers
		WHERE CustomerID = @i;
	SET @i = @i + 1;
END
GO

-- جهت خروج از حلقه BREAK استفاده از
DECLARE @i AS INT = 1;
WHILE @i <= 10
BEGIN
	IF @i = 6 BREAK;
	PRINT @i;
	SET @i = @i + 1;
END
GO

-- جهت نادیده گرفتن دستورات بعدی و پرش به ابتدای حلقه CONTINUE استفاده از 
DECLARE @i AS INT = 0;
WHILE @i < 92
BEGIN
	SET @i = @i + 1;
	IF (SELECT Region FROM dbo.Customers
			WHERE CustomerID = @i) IS NULL CONTINUE;
	SELECT CustomerID, Region FROM dbo.Customers
		WHERE CustomerID = @i;
END
GO
--------------------------------------------------------------------

-- IF & WHILE
DROP TABLE IF EXISTS dbo.Digits;
GO

CREATE TABLE dbo.Digits
(
	Num INT
);
GO

DECLARE @i AS INT = 1;
WHILE @i <= 1000
BEGIN
	IF @i % 2 = 0
	INSERT INTO dbo.Digits(Num)
		VALUES(@i);
	SET @i = @i + 1;
END
GO

SELECT * FROM dbo.Digits;
GO