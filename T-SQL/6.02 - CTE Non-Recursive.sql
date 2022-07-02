
USE Test_DB;
GO

/*
CTE Non-Recursive:

WITH <CTE_Name> [(<Column_List>)]
AS
(
	<Inner_Query_Defining_CTE> -- باید دارای الزامات سه گانه باشد
)
<Outer_Query_Against_CTE>;
*/

-- Derived Table فهرست کد و نام شرکت مشتریان تهرانی با استفاده از
SELECT
	TC.CompanyName
FROM (SELECT
		C.CustomerID, C.CompanyName
	  FROM dbo.Customers AS C
		WHERE C.State = N'تهران') AS TC;
GO

-- Derived Table عدم استفاده مجدد از
SELECT
	TC.CompanyName
FROM (SELECT
		C.CustomerID, C.CompanyName
	  FROM dbo.Customers AS C
		WHERE C.State = N'تهران') AS TC
JOIN TC AS TC1
	ON TC.CustomerID = TC1.CustomerID;
GO

-- Derived Table نمونه‌سازی مجدد با استفاده از
SELECT
	TC1.CompanyName
FROM (SELECT
		C.CustomerID, C.CompanyName
	  FROM dbo.Customers AS C
		WHERE C.State = N'تهران') AS TC1
JOIN (SELECT
		C.CustomerID, C.CompanyName
	  FROM dbo.Customers AS C
		WHERE C.State = N'تهران') AS TC2
	ON TC1.CustomerID = TC2.CustomerID;
GO

-- CTE فهرست کد و نام شرکت مشتریان تهرانی با استفاده از
WITH Tehran_Customers
AS
(
	SELECT
		CustomerID, CompanyName
	FROM dbo.Customers
		WHERE State = N'تهران'
)
SELECT * FROM Tehran_Customers AS TC;
GO

-- در بخش کوئری بیرونی CTE استفاده مجدد از کوئری درونی
WITH Tehran_Customers
AS
(
	SELECT
		CustomerID, CompanyName
	FROM dbo.Customers
		WHERE State = N'تهران'
)
SELECT
	TC1.CompanyName, TC1.CustomerID
FROM Tehran_Customers AS TC1
JOIN Tehran_Customers AS TC2
	ON TC1.CustomerID = TC2.CustomerID;
GO

-- CTE تعیین نام ستون‌های خروجی
WITH Tehran_Customers (Col1,Col2) 
AS
(
	SELECT
		CustomerID, CompanyName
	FROM Customers AS C
		WHERE C.City = N'تهران'
)
SELECT
	T.Col1, T.Col2 -- !می‌توان استفاده کرد WITH فقط از نام‌های تعریف‌شده در جلو
FROM Tehran_Customers AS T;
GO
--------------------------------------------------------------------

/*
در هر سال چه تعداد مشتری داشته‌ایم؟
!انجام شود CTE عملیات محاسبه تعداد مشتری و گروه‌بندی سال‌ها در کوئری بیرونی
*/
WITH CustPerYear
AS
(
	SELECT
		YEAR(OrderDate) AS OrderYear,
		CustomerID
	FROM dbo.Orders
)
SELECT
	CY.OrderYear,
	COUNT(DISTINCT CY.CustomerID) AS Customers_Num
FROM CustPerYear AS CY
GROUP BY CY.OrderYear;
GO
--------------------------------------------------------------------

/*
فهرست تعداد مشتریان هر سال و سال قبل از آن و بررسی
.میزان افزایش یا کاهش تعداد مشتری نسبت به سال قبل

.انجام شود CTE محاسبه تعداد مشتریان در بخش کوئری درونی
. انجام شود CTE و JOIN  به دو روش‌
*/

-- تعداد مشتریان به‌ازای هر سال
SELECT
	YEAR(O1.OrderDate) AS OrderYear,
	COUNT(DISTINCT O1.CustomerID) AS Cust_Num
FROM dbo.Orders AS O1
GROUP BY YEAR(O1.OrderDate);
GO

SELECT
	YEAR(O1.OrderDate) AS OrderYear,
	COUNT(DISTINCT O1.CustomerID) AS Cust_Num,
	YEAR(O2.OrderDate) AS OrderYear,
	COUNT(DISTINCT O2.CustomerID) AS Cust_Num
FROM dbo.Orders AS O1
JOIN dbo.Orders AS O2
	ON YEAR(O1.OrderDate) = YEAR(O2.OrderDate)
GROUP BY YEAR(O1.OrderDate), YEAR(O2.OrderDate);
GO

-- ON کوئری بالا با تغییر در بخش
SELECT
	YEAR(O1.OrderDate) AS OrderYear,
	COUNT(DISTINCT O1.CustomerID) AS Cust_Num,
	YEAR(O2.OrderDate) AS OrderYear,
	COUNT(DISTINCT O2.CustomerID) AS Cust_Num
FROM dbo.Orders AS O1
JOIN dbo.Orders AS O2
	ON YEAR(O1.OrderDate) = YEAR(O2.OrderDate) + 1
GROUP BY YEAR(O1.OrderDate), YEAR(O2.OrderDate);
GO

-- JOIN  با استفاده از
SELECT
	YEAR(O1.OrderDate) AS OrderYear,
	COUNT(DISTINCT O1.CustomerID) AS Cust_Num,
	COUNT(DISTINCT O2.CustomerID) AS Previous_Cust_Num,
	COUNT(DISTINCT O1.CustomerID) - COUNT(DISTINCT O2.CustomerID) AS Growth
FROM dbo.Orders AS O1
LEFT JOIN dbo.Orders AS O2
	ON YEAR(O1.OrderDate) = YEAR(O2.OrderDate) + 1
GROUP BY YEAR(O1.OrderDate), YEAR(O2.OrderDate);
GO

-- CTE  با استفاده از
WITH Customers_Per_Year
AS
(
	SELECT
		YEAR(O1.OrderDate) AS OrderYear,
		COUNT(DISTINCT O1.CustomerID) AS Cust_Num
	FROM dbo.Orders AS O1
	GROUP BY YEAR(O1.OrderDate)
)
SELECT
	C.OrderYear,
	C.Cust_Num AS Cust_Num,
	ISNULL(P.Cust_Num, 0) AS Previous_Cust_Num,
	C.Cust_Num - ISNULL(P.Cust_Num, 0) AS Growth
FROM Customers_Per_Year AS C
LEFT JOIN Customers_Per_Year AS P
	ON C.OrderYear = P.OrderYear + 1;
GO

-- Derived Table  با استفاده از
SELECT
	Current_Year.OrderYear,
	Current_Year.Cust_Num AS Cust_Num,
	ISNULL(Previous_Year.Cust_Num, 0) AS Previous_Cust_Num,
	Current_Year.Cust_Num - ISNULL(Previous_Year.Cust_Num, 0) AS Growth
FROM (SELECT
		YEAR(OrderDate) AS OrderYear,
		COUNT(DISTINCT CustomerID) AS Cust_Num
	  FROM dbo.Orders
	  GROUP BY YEAR(OrderDate)) AS Current_Year -- Derived Table اولین
	  LEFT JOIN (SELECT 
					YEAR(OrderDate) AS OrderYear,
					COUNT(DISTINCT CustomerID) AS Cust_Num 
				 FROM dbo.Orders 
			     GROUP BY YEAR(OrderDate)) AS Previous_Year -- اول Derived Table تکرار مجدد
		ON Current_Year.OrderYear = Previous_Year.OrderYear + 1;
GO

-- Subquery  با استفاده از
SELECT
	YEAR(Current_Year.OrderDate) AS OrderYear,
	COUNT(DISTINCT Current_Year.CustomerID) AS Cust_Num,
	ISNULL((SELECT COUNT(DISTINCT O.CustomerID) FROM dbo.Orders AS O
				WHERE YEAR(Current_Year.OrderDate) = YEAR(O.OrderDate) + 1
			GROUP BY YEAR(O.OrderDate)), 0) AS Previous_Cust_Num,
	COUNT(DISTINCT Current_Year.CustomerID) -
	ISNULL((SELECT COUNT(DISTINCT O.CustomerID) FROM dbo.Orders AS O
				WHERE YEAR(Current_Year.OrderDate) = YEAR(O.OrderDate) + 1
			GROUP BY YEAR(O.OrderDate)), 0) AS Growth
FROM dbo.Orders AS Current_Year
GROUP BY YEAR(Current_Year.OrderDate);
GO
--------------------------------------------------------------------

/*
تودرتو CTE

WITH <CTE_Name1> [(<column_list>)]
AS
(
	<inner_query_defining_CTE>
),
	<CTE_Name2> [(<column_list>)]
AS
(
	<inner_query_defining_CTE>
)
	<outer_query_against_CTE>;
*/

-- تودرتو CTE  با استفاده از
WITH Current_Year
AS
(
	SELECT
		YEAR(OrderDate) AS OrderYear,
		COUNT(DISTINCT CustomerID) AS Cust_Num
	FROM dbo.Orders AS O
	GROUP BY YEAR(OrderDate)
),
Previous_Year
AS
(
	SELECT
		YEAR(OrderDate) AS OrderYear,
		COUNT(DISTINCT CustomerID) AS Cust_Num
	FROM dbo.Orders AS O
	GROUP BY YEAR(OrderDate)
)
SELECT
	Current_Year.OrderYear,
	Current_Year.Cust_Num,
	ISNULL(Previous_Year.OrderYear,0) AS Previous_Cust_Num,
	Current_Year.Cust_Num - ISNULL(Previous_Year.Cust_Num,0) AS Growth
FROM Current_Year
LEFT JOIN Previous_Year
	ON Current_Year.OrderYear = Previous_Year.OrderYear + 1;
GO

/*
نکته مهم
به‌صورت تو در تو ،‌CTE پس از تعریف چندین
استفاده از آن‌‌ها در چندین دستور جداگانه
.امکان‌پذیر نیست CTE در کوئری بیرونی
.های غیر تو در تو هم برقرار است‌CTE این موضوع در مورد
*/