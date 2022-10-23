USE Test_DB;
GO

-- Plan Cache مربوط به Cache پاک کردن
-- تو سرور های عملیاتی این کارو نکن خطرناکه
DBCC FREEPROCCACHE;
GO

SELECT * FROM dbo.Employees
	WHERE EmployeeID = 1;
GO

-- شده است Cache آن‌ها Plan لیست کوئری‌هایی که
SELECT * FROM sys.dm_exec_cached_plans;
GO

-- به همراه متن کوئری Plan Cache مشاهده کوئری‌های موجود در
SELECT
	P.bucketid, P.usecounts, P.size_in_bytes, P.objtype, T.text
FROM sys.dm_exec_cached_plans AS P
CROSS APPLY sys.dm_exec_sql_text(P.plan_handle) AS T;
GO
--------------------------------------------------------------------

/*
SP چندین مرتبه فراخوانی
*/

-- Plan Cache مربوط به Cache پاک کردن
DBCC FREEPROCCACHE;
GO

EXEC GetEmployeeByID 1;
GO

EXEC GetEmployeeByID 4;
GO

EXEC GetEmployeeByID 9;
GO

--  به‌همراه متن کوئری Plan Cache مشاهده کوئری‌های موجود در
SELECT
	P.bucketid, P.usecounts, P.size_in_bytes, T.text
FROM sys.dm_exec_cached_plans AS P
CROSS APPLY sys.dm_exec_sql_text(P.plan_handle) AS T
	WHERE T.text LIKE '%Employees%';
GO
--------------------------------------------------------------------

/*
sp_executesql اجرای کوئری با استفاده از
*/

DBCC FREEPROCCACHE;
GO


EXEC sp_executesql N'SELECT * FROM dbo.Orders WHERE CustomerID = @Customerid',
	N'@Customerid INT', @Customerid=79;
GO

EXEC sp_executesql N'SELECT * FROM dbo.Orders WHERE CustomerID = @Customerid',
	N'@Customerid INT', @Customerid=3;
GO

EXEC sp_executesql N'SELECT * FROM dbo.Orders WHERE CustomerID = @Customerid',
	N'@Customerid INT', @Customerid=28;
GO

SELECT
	P.bucketid, P.usecounts, P.size_in_bytes, T.text
FROM sys.dm_exec_cached_plans AS P
CROSS APPLY sys.dm_exec_sql_text(P.plan_handle) AS T
	WHERE T.text LIKE '%Orders%';
GO
--------------------------------------------------------------------

/*
کوئری Ad-hoc اجرای چندین
*/

-- Plan Cache مربوط به Cache پاک کردن
DBCC FREEPROCCACHE;
GO

SELECT * FROM dbo.Employees
	WHERE EmployeeID = 1;
GO

SELECT * FROM dbo.Employees
	WHERE EmployeeID= 1;
GO

SELECT * FROM dbo.Employees
	WHERE EmployeeID= 1; -- کد کارمند
GO

-- اجرایی Plan به همراه متن کوئری و Plan Cache مشاهده کوئری‌های موجود در
SELECT
	P.bucketid, P.usecounts, P.size_in_bytes, T.text
FROM sys.dm_exec_cached_plans AS P
CROSS APPLY sys.dm_exec_sql_text(P.plan_handle) AS T;
GO
