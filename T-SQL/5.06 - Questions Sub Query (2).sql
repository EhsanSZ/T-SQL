
USE Test_DB;
GO

/*
Exersice 01
مشخصات شرکت‌هایی که حداقل در یکی از ماه‌های سال 2015 سفارش داشته‌اند
.اما در سال 2016 هنوز درخواست سفارشی نداشته‌اند
*/

/*
Subquery (EXISTS)

Outer Query: Customers
Subquery: Orders
*/
SELECT
	C.CustomerID, C.CompanyName
FROM dbo.Customers AS C
	WHERE EXISTS (SELECT 1 FROM dbo.Orders AS O
					WHERE C.CustomerID = O.CustomerID
					AND YEAR(O.OrderDate) = 2015)
	AND NOT EXISTS (SELECT 1 FROM dbo.Orders AS O
						WHERE O.CustomerID = C.CustomerID
						AND YEAR(OrderDate) = 2016);
GO

/*
Subquery (IN)

Outer Query: Customers
Subquery: Orders
*/
SELECT
	C.CustomerID, C.CompanyName
FROM dbo.Customers AS C
	WHERE C.CustomerID IN (SELECT O.CustomerID FROM dbo.Orders AS O
							WHERE YEAR(O.OrderDate) = 2015)
	AND C.CustomerID NOT IN (SELECT O.CustomerID FROM dbo.Orders AS O
								WHERE YEAR(O.OrderDate) = 2016);
GO
--------------------------------------------------------------------

/*
Exersice 02

.هستند A نمایش رکوردهایی که فقط در جدول
*/

DROP TABLE IF EXISTS A,B;
GO

CREATE TABLE A
(
	ID TINYINT
);
GO

CREATE TABLE B
(
	ID TINYINT
);
GO

INSERT INTO A
	VALUES (1),(2),(3),(4);
GO

INSERT INTO B
	VALUES (2),(NULL);
GO 

-- JOIN
SELECT A.* FROM A
JOIN B
	ON A.ID <> B.ID;
GO

-- Subquery (EXISTS)
SELECT * FROM A
	WHERE EXISTS (SELECT 1 FROM B
					WHERE B.ID <> A.ID);
GO

-- Subquery (NOT EXISTS)
SELECT * FROM A
	WHERE NOT EXISTS (SELECT 1 FROM B
						WHERE B.ID = A.ID);
GO

-- Subquery (NOT IN) Without Checking
SELECT * FROM A
	WHERE A.ID NOT IN (SELECT ID FROM B);
GO

-- Subquery (NOT IN) With Checking
SELECT
	A.ID
FROM A
	WHERE A.ID NOT IN (SELECT ID FROM B
						WHERE B.ID IS NOT NULL);
GO

-- Subquery (NOT IN) With Checking
SELECT
	A.ID
FROM A
	WHERE A.ID NOT IN (SELECT ISNULL(ID, '') FROM B);
GO

-- Subquery (NOT IN - Correlated)
SELECT
	A.ID
FROM A
	WHERE A.ID NOT IN (SELECT ID FROM B
						WHERE B.ID = A.ID);
GO