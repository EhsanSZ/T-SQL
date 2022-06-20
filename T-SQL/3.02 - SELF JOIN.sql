
USE Test_DB;
GO

/*
SELF JOIN
*/

-- ترکیب دو تایی از نام و نام‌خانوادگی کارمندان
SELECT
	E1.FirstName, E1.LastName,
	E2.FirstName, E2.LastName
FROM dbo.Employees AS E1
CROSS JOIN dbo.Employees AS E2
ORDER BY E1.FirstName, E1.LastName;
GO

/*
ایراد کوئری بالا
Self      Pairs:	بهزاد فکری 		بهزاد فکری	
Mirrored  Pairs:    بهزاد فکری 	پیمان سلامی    		پیمان سلامی		بهزاد فکری
*/