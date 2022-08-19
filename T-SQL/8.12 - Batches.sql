
-- Valid Batches
PRINT 'First Batches';
USE Test_DB;
GO

-- Invalid Batches
PRINT 'Second Batches';
SELECT CustomerID FROM dbo.Customers;
SELECT OrderID FOM dbo.Orders; -- Compile Error
GO

-- valid & Invalid Batches
PRINT 'Second Batches';
SELECT CustomerID FROM dbo.Customers;
SELECT OrderID FROM db.Customers;-- Binding!!!
SELECT * FROM dbo.Orders; 
GO

-- Valid Batches
PRINT 'Third Batches';
SELECT EmployeeID FROM HR.Employees;
GO
--------------------------------------------------------------------

DROP TABLE IF EXISTS #Test;
GO

CREATE  TABLE #Test
(
    ID INT CHECK(ID > 10),
    Family VARCHAR(100)
);

INSERT #Test
    VALUES(11,'A'),(12,'B'),(13,'C'),(14,'D');
INSERT #Test
	VALUES(10,'E');
INSERT #Test
	VALUES(15,'E');
GO

SELECT * FROM #Test;
GO


DROP TABLE IF EXISTS #Test;
GO

CREATE  TABLE #Test
(
    ID INT CHECK(ID > 10),
    Family VARCHAR(100)
);

INSERT #Test
	VALUES(10,'E');
INSERT #Test
    VALUES(11,'A'),(12,'B'),(13,'C'),(14,'D');
INSERT #Test
	VALUES(15,'E');
GO

SELECT * FROM #Test;
GO

https://technet.microsoft.com/en-us/library/ms175502(v=sql.105).aspx
--------------------------------------------------------------------

DECLARE @Var INT;
SET @Var = 100;
SELECT @Var;
GO

-- آن Scope عدم دسترسی به متغیر در خارج از
SELECT @Var;
GO
--------------------------------------------------------------------

DROP TABLE IF EXISTS dbo.Batches_GO;
GO

CREATE TABLE dbo.Batches_GO
(
	Col1 INT IDENTITY,
	Col2 INT
);
GO

INSERT INTO dbo.Batches_GO
	VALUES (100);
GO 20

SELECT * FROM dbo.Batches_GO;
GO