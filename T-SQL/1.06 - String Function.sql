
USE Test_DB;
GO

/*
LEN/DATALENGTH Function

LEN ( string_expression )
DATALENGTH ( expression )

طول رشته و تعداد بایت‌های تخصیص داده‌شده به رشته 
*/

-- های یونیکدی Data Type تفاوت عملکرد با
SELECT LEN(N'سلام');
SELECT DATALENGTH(N'سلام');

SELECT LEN('A');
SELECT DATALENGTH('A');
GO

SELECT DATALENGTH(N'A');
GO

-- پس از رشته Blank مقادیر
SELECT LEN(N'My String   ');
SELECT DATALENGTH(N'My String   ');
GO
--------------------------------------------------------------------

/*
LOWER/UPPER Functions

LOWER ( character_expression )
UPPER ( character_expression )

کوچک و بزرگ کردن کاراکترهای یک رشته
*/

SELECT UPPER('my sTRing');
SELECT LOWER('my sTRing');
GO
--------------------------------------------------------------------

/*
RTRIM/LTRIM Functions

RTRIM ( character_expression )
LTRIM ( character_expression )

حذف فضای خالی از ابتدا یا انتهای رشته
*/

SELECT RTRIM(' str '), LEN(RTRIM(' str '));
SELECT LTRIM(' str '), LEN(LTRIM(' str '));
SELECT RTRIM(LTRIM(' str ')), LEN(RTRIM(LTRIM(' str ')));
GO
--------------------------------------------------------------------

/*
LEFT/RIGHT Function

LEFT ( character_expression , integer_expression ) 
RIGHT ( character_expression , integer_expression ) 

استخراج بخشی از یک رشته از سمت راست یا چپ آن رشته
*/

SELECT LEFT(N'علی رضا', 3);
SELECT RIGHT(N'علی رضا', 3);
SELECT LEFT('ABCD', 3);
SELECT LEFT(N'ABCD', 3);
SELECT RIGHT(N'ABCD', 3);
GO
--------------------------------------------------------------------

/*
SUBSTRING Function

SUBSTRING ( expression , start , length )

استخراج بخشی از یک رشته
*/

SELECT SUBSTRING('My String', 1, 2);
GO
--------------------------------------------------------------------

/*
CHARINDEX Function

CHARINDEX ( expressionToFind , expressionToSearch [ , start_location ] )

 اولین موقعیتِ کاراکترِ عین یک عبارت در رشته
*/

SELECT CHARINDEX(' ', N'امیر حسین سعیدی');
GO

SELECT CHARINDEX(N'ید', N'امیر حسین سعیدی');
GO

SELECT CHARINDEX(N'یک', N'امیر حسین سعیدی');
GO
--------------------------------------------------------------------

/*
PATINDEX Function

PATINDEX ( '%pattern%' , expression )  

 اولین موقعیتِ الگو در رشته
*/

SELECT PATINDEX('[0-9]%', '3ab12cd34ef56gh');
GO

SELECT PATINDEX('[0-9]%', 'a4b12cd34ef56gh');
GO

SELECT PATINDEX('%[1]%', '3ab12cd34ef56gh');
GO
--------------------------------------------------------------------

/*
REPLACE Function

REPLACE ( string_expression , string_pattern , string_replacement )

.جایگزین کردن بخشی از زیررشته با رشته موردنظر
! رشته می‌تواند تک کاراکتر هم باشد
*/

SELECT REPLACE('my-string    is-simple!', '-', ' ');
GO

--------------------------------------------------------------------

/*
REPLICATE Function

REPLICATE ( string_expression ,integer_expression )

تکرار یک رشته
*/

SELECT REPLICATE('abc', 3);
GO
--------------------------------------------------------------------

/*
STUFF Function

STUFF ( character_expression , start , length , replaceWith_expression ) 

حذف بخشی از رشته و جایگزین کردن رشته موردنظر
*/

SELECT STUFF('Test', 2, 1, N'***');
GO

DECLARE @MyStr VARCHAR(30);
SET @MyStr= 'SQL Server Management Studio';
SELECT STUFF(@MyStr, 1, LEN(@MyStr), 'SSMS');
GO
--------------------------------------------------------------------

/*
Concatenation عملیات
*/

-- + با استفاده از  
SELECT 
	EmployeeID, FirstName + N'-' + LastName AS FullName
FROM dbo.Employees;
GO

/*
CONCAT با استفاده از تابع Concatenation عملیات

CONCAT ( string_value1, string_value2 [, string_valueN ] )

*/

SELECT CONCAT('my', ',', 'String', ',', 'is' ,',' , 'simple', '!');
GO

SELECT 'A' + NULL + '-' + 'B';
SELECT CONCAT('A' , NULL , '-' , 'B');
GO

SELECT 
	CustomerID, State, Region, City,
	CONCAT(State, '*' , Region, '*' , City) AS Cust_location
FROM dbo.Customers;
GO

/*
.بازنویسی کوئری بالا را با استفاده از + 
*/
SELECT 
	CustomerID, State, Region, City,
	ISNULL(State,'') + '*' + ISNULL(Region,'') + '*' + City AS Cust_location
FROM dbo.Customers;
GO