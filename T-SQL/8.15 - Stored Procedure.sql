/*
CREATE { PROC | PROCEDURE } 
    [schema_name.] procedure_name
    [ { @parameter data_type }  
        [ = default ] [ OUT | OUTPUT | [READONLY]  
    ] [ ,...n ]   
AS { [ BEGIN ] sql_statement [;] [ ...n ] [ END ] }  
[;]  
*/

USE Test_DB;
GO

-- ساده SP ایجاد یک
DROP PROCEDURE IF EXISTS GetAllCustomers;
GO

CREATE PROCEDURE GetAllCustomers --PROC
AS
BEGIN	
	SELECT 
		CustomerID, City
	FROM dbo.Customers;
END
GO

-- SP روش‌های فراخوانی
EXEC GetAllCustomers;
GO

GetAllCustomers;
GO
--------------------------------------------------------------------

-- SP ویرایش
ALTER PROCEDURE GetAllCustomers
AS
BEGIN	
	SELECT 
		CustomerID, State, City
	FROM dbo.Customers;
END
GO

EXEC GetAllCustomers;
GO
--------------------------------------------------------------------

/*
SP With Input Parameters
*/

DROP PROCEDURE IF EXISTS GetEmployeeByID;
GO

CREATE PROCEDURE GetEmployeeByID
(
	@ID INT
)
AS
BEGIN
	SELECT 
		EmployeeID, FirstName, LastName
	FROM dbo.Employees
		WHERE EmployeeID = @ID;
END
GO

-- با پارامتر ورودی SP روش اول فراخوانی
EXEC GetEmployeeByID 1;
GO

-- با پارامتر ورودی SP روش دوم فراخوانی
EXEC GetEmployeeByID @ID = 1;
GO

-- با پارامتر ورودی SP روش سوم فراخوانی
GetEmployeeByID 1;
GO
--------------------------------------------------------------------

/*
SP With Output Parameters
*/

DROP PROCEDURE IF EXISTS ExistsCustomer;
GO

CREATE PROCEDURE ExistsCustomer
(
	@CustomerID INT,
	@Exists BIT OUTPUT
)
AS
BEGIN	
	IF EXISTS(SELECT CustomerID FROM dbo.Customers
				WHERE CustomerID = @CustomerID)
		BEGIN
		SET @Exists ='TRUE'
		END
	ELSE
		SET @Exists ='FALSE'
END
GO

-- دارای پارامتر ورودی و خروجی SP فراخوانی
DECLARE @V_RecordExistance BIT;
EXEC ExistsCustomer 5,  @V_RecordExistance OUTPUT;
SELECT @V_RecordExistance;
GO

DROP PROCEDURE IF EXISTS ConcatInfo;
GO

CREATE PROCEDURE ConcatInfo
(
	@FirstName NVARCHAR(40),
	@LastName NVARCHAR(60),
	@FullName NVARCHAR(100) OUTPUT
)
AS
BEGIN
	SELECT @FullName = CONCAT(@FirstName, ' ', @LastName)
END
GO

DECLARE @V_FullName NVARCHAR(100);
EXEC ConcatInfo N'احمد', N'اسدی', @V_FullName OUTPUT;
SELECT @V_Fullname;
GO