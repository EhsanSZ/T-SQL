USE Test_DB;
GO

/*
Composite Join
*/

DROP TABLE IF EXISTS Composite1, Composite2;
GO

CREATE TABLE Composite1
(
	ID1 INT,
	ID2 INT,
	Family NVARCHAR(50)
);
GO

CREATE TABLE Composite2
(
	ID1 INT,
	ID2 INT,
	Serial INT IDENTITY,
	CheckedDate CHAR(10) DEFAULT GETDATE()
);
GO

INSERT INTO dbo.Composite1(ID1, ID2, Family)
	VALUES	(1,10,N'احمدی'),(1,20,N'سعادت'),
			(2,10,N'پایدار'),(2,20,N'رضایی');
GO

INSERT INTO dbo.Composite2(ID1, ID2)
	VALUES	(1,10),(1,10),(1,20),(1,20),
			(2,10),(1,10),(1,10),(2,10);
GO

SELECT * FROM dbo.Composite1;
SELECT * FROM dbo.Composite2;
GO

SELECT
	C1.Family, C2.Serial
FROM dbo.Composite1 AS C1
JOIN dbo.Composite2 AS C2
	ON  C1.ID1 = C2.ID1
	AND C1.ID2 = C2.ID2;
GO

/*
برای درک بهتر کوئری بالا، یک بار هم کوئری
.زیر را اجرا کرده تا تفاوت نتایج را مشاهده کنید
*/
SELECT
	C1.Family, C2.Serial
FROM dbo.Composite1 AS C1
JOIN dbo.Composite2 AS C2
	ON C1.ID1 = C2.ID1;
GO