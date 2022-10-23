
USE Test_DB;
GO

/*
Scalar-Value FUNCTION
*/

DROP FUNCTION IF EXISTS dbo.Abbreviation;
GO

-- تعریف تابع
CREATE FUNCTION dbo.Abbreviation (@FirstName NVARCHAR(50),@LastName NVARCHAR(100))
RETURNS NCHAR(3)
AS
BEGIN
	DECLARE @Output NCHAR(3)
	SET @Output = LEFT(@FirstName,1) + '.' + LEFT(@LastName,1)
	RETURN @Output
END
GO

-- استفاده از تابع در حالت عادی
SELECT dbo.Abbreviation(N'سعید',N'پاشایی');
GO

/*
استفاده از تابع برای بازیابی رکوردهای جداول

ترکیب نام و نام‌خانوادگی کارمندان
*/
SELECT
	EmployeeID, FirstName, LastName,
	dbo.Abbreviation(FirstName,LastName)
FROM dbo.Employees;
GO
--------------------------------------------------------------------

/*
.تابعی که سن کارمندان را نمایش دهد
*/

DROP FUNCTION IF EXISTS dbo.GetAge;
GO

CREATE FUNCTION dbo.GetAge (@BirthDate DATE)
RETURNS TINYINT
AS
BEGIN
	--DECLARE @Age TINYINT
	--SET @Age = DATEDIFF(YEAR,@BirthDate,GETDATE())
	--RETURN @Age
	RETURN DATEDIFF(YEAR,@BirthDate,GETDATE())
END
GO

SELECT
	EmployeeID, FirstName, LastName,
	dbo.GetAge(Birthdate) AS Age
FROM dbo.Employees;
GO