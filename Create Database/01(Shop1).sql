USE master
GO
--بررسی جهت وجود بانک اطلاعاتی
IF DB_ID('Shop1')>0
BEGIN
	--تک کاربره کردن بانک اطلاعاتی
	ALTER DATABASE Shop1 SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	
	--حذف بانک اطلاعاتی
	DROP DATABASE Shop1 
END	
GO
----------------------------------------------------------------------
--ایجاد بانک اطلاعاتی در مسیر پیش فرض 
CREATE DATABASE Shop1 COLLATE Persian_100_CI_AI
GO

---- به دیتابیس Data File اضافه کردن یک
--ALTER DATABASE Shop1
--	ADD FILE (NAME = naDB24, FILENAME = 'D:\TmpDB\Shop1Data6.mdf', SIZE = 10MB, MAXSIZE = 200, FILEGROWTH = 20MB)
--GO
---- به دیتابیس LOG File اضافه کردن یک
--ALTER DATABASE Shop1
--	ADD LOG FILE (NAME = naL3, FILENAME = 'E:\TmpDB\Shop1Log3.ldf', SIZE = 2MB, MAXSIZE = 30MB, FILEGROWTH = 15MB) 
--GO

-----------------------------------------------------------------------------------------------
--CREATE DATABASE Shop1 
--	ON
--    (NAME = naDB1, FILENAME = 'E:\TmpDB\Shop1Data1.mdf', SIZE = 10MB, MAXSIZE = 100, FILEGROWTH = 20MB),
--    (NAME = naDB2, FILENAME = 'E:\TmpDB\Shop1Data3.ndf', SIZE = 10MB, MAXSIZE = UNLIMITED, FILEGROWTH = 20)
--LOG ON 
--   (NAME = naL1, FILENAME = 'E:\TmpDB\Shop1Log1.ldf', SIZE = 100MB, MAXSIZE = 100, FILEGROWTH = 20),
--   (NAME = naL2, FILENAME = 'E:\TmpDB\Shop1Log2.ldf', SIZE = 50MB, MAXSIZE = 100, FILEGROWTH = 20);
--GO
----------------------------------------------------------------------

-- تنظیم بانک اطلاعاتی پیش فرض
USE Shop1
GO
--Customer ایجاد اسکیما
CREATE SCHEMA Customer
GO
--Production ایجاد اسکیما
CREATE SCHEMA Production
GO
--Sales ایجاد اسکیما
CREATE SCHEMA Sales
GO
--Geographics ایجاد اسکیما
CREATE SCHEMA Geographics
GO

-----------------------------------------------------------------------

--States ایجاد جدول 
CREATE TABLE Geographics.[State]
(
	StateCode TINYINT NOT NULL,
	StateTitle NVARCHAR(100) NOT NULL
)
GO
--اضافه شدن کلید اصلی به جدول
ALTER TABLE Geographics.State ADD CONSTRAINT PK_States
PRIMARY KEY CLUSTERED (StateCode)
GO

-----------------------------------------------------------------------

--States ایجاد جدول 
CREATE TABLE Geographics.City
(
	StateCode TINYINT NOT NULL,
	CityCode SMALLINT NOT NULL,
	CityTitle NVARCHAR(100) NOT NULL
)
GO
--اضافه شدن کلید اصلی به صورت ترکیبی به جدول
ALTER TABLE Geographics.City ADD CONSTRAINT PK_City
PRIMARY KEY CLUSTERED (StateCode,CityCode)
GO
--Geographics.State و Geographics.City ایجاد ارتباط بین جدول 
ALTER TABLE Geographics.City ADD CONSTRAINT FK_City_State
FOREIGN KEY(StateCode) REFERENCES Geographics.State(StateCode)
	ON UPDATE  NO ACTION 
	ON DELETE  NO ACTION 
GO

-----------------------------------------------------------------------

--Customer ایجاد جدول 
CREATE TABLE Customer.Customer
(
	CustomerID INT IDENTITY(1,1) NOT NULL,
	FirstName NVARCHAR(50),
	LastName NVARCHAR(50) NOT NULL,
	BrithDate DATE ,
	--ورود از طریق یکی از سه ورودی زیر انجام میشود
	Telephone CHAR(14),
	Gmail VARCHAR(100),
	UserName varchar(50),
	--رمز با یک الگوریتم سمت برنامه نویسی هش شده ذخیره میشود
	[Password] CHAR(32),
	StateCode TINYINT  NOT NULL,
	CityCode SMALLINT  NOT NULL,
	[Address] NVARCHAR(250),
	PostalCode CHAR(10),
)
GO
--اضافه شدن کلید اصلی به جدول
ALTER TABLE Customer.Customer ADD CONSTRAINT PK_Customer
PRIMARY KEY CLUSTERED (CustomerID)
GO
--اضافه شدن کلید یکتا موبایل به جدول
ALTER TABLE Customer.Customer ADD CONSTRAINT UK_Telephone
UNIQUE NONCLUSTERED  (Telephone)
GO
--اضافه شدن کلید یکتا ایمیل به جدول
ALTER TABLE Customer.Customer ADD CONSTRAINT UK_Email
UNIQUE NONCLUSTERED  (Gmail)
GO
--اضافه شدن کلید یکتا نام کاربری به جدول
ALTER TABLE Customer.Customer ADD CONSTRAINT UK_UserName
UNIQUE NONCLUSTERED  (UserName)
GO
--Geographics.City Costomer.Customer ایجاد ارتباط بین جدول 
ALTER TABLE Customer.Customer ADD CONSTRAINT FK_Customer_City
FOREIGN KEY(StateCode,CityCode) REFERENCES Geographics.City(StateCode,CityCode)
	ON UPDATE  NO ACTION 
	ON DELETE  NO ACTION 
GO

-----------------------------------------------------------------------

--Web Information ایجاد جدول 
CREATE TABLE Customer.WebInformation
(
	-- یک سطر در جدول مشتری برای اشخاصی که ثبت نام نکردن بزار که این جا به مشکل نخوری
	InfoID INT IDENTITY(1,1) NOT NULL,
	CustomerID INT NOT NULL,
	-- IP
	-- Browser
	-- Version
	-- Operating System
	--اطلاعات لازمه رو در بیار 
)
GO
--اضافه شدن کلید اصلی به جدول
ALTER TABLE Customer.WebInformation ADD CONSTRAINT PK_InfoID
PRIMARY KEY CLUSTERED (InfoID)
GO
--Customer.Customer و Customer.WebInformation ایجاد ارتباط بین جدول 
ALTER TABLE Customer.WebInformation ADD CONSTRAINT FK_WebInformation_Customer
FOREIGN KEY(CustomerID) REFERENCES Customer.Customer(CustomerID)
	ON UPDATE  NO ACTION 
	ON DELETE  NO ACTION 
GO

-----------------------------------------------------------------------

--ProductCategory ایجاد جدول 
CREATE TABLE Production.ProductCategory
(
	ProductCategoryCode TINYINT NOT NULL,
	ProductCategoryTitle NVARCHAR(100) NOT NULL
)
GO
--اضافه شدن کلید اصلی به جدول
ALTER TABLE Production.ProductCategory ADD CONSTRAINT PK_ProductCategory 
PRIMARY KEY CLUSTERED (ProductCategoryCode)
GO

-----------------------------------------------------------------------

--Product ایجاد جدول 
CREATE TABLE Production.Product
(
	ProductID INT IDENTITY(1,1) NOT NULL,
	ProductName NVARCHAR(200) NOT NULL,
	ProductCategoryCode TINYINT NOT NULL,
	Price BIGINT ,
	ProductImage VARBINARY(MAX)
)
GO
--اضافه شدن کلید اصلی به جدول
ALTER TABLE Production.Product ADD CONSTRAINT PK_Product 
PRIMARY KEY CLUSTERED (ProductID)
GO
--Production.ProductCategory و Production.Product ایجاد ارتباط بین جدول 
ALTER TABLE Production.Product ADD CONSTRAINT FK_Product_ProductCategory
FOREIGN KEY(ProductCategoryCode) REFERENCES Production.ProductCategory(ProductCategoryCode)
	ON UPDATE  NO ACTION 
	ON DELETE  NO ACTION 
GO

-----------------------------------------------------------------------

--OrderHeader ایجاد جدول 
CREATE TABLE Sales.OrderHeader
(
	OrderHeaderID INT IDENTITY(1,1) NOT NULL,
	OrderDate DATETIME NOT NULL,
	ShipDate DATETIME ,
	CustomerID INT NOT NULL,
	ShipStateCode TINYINT  NOT NULL,
	ShipCityCode SMALLINT  NOT NULL,
	ShipAddress NVARCHAR(200)  NOT NULL,
	ShipPostalCode VARCHAR(20),
	Price BIGINT NOT NULL ,
	PaymentCode VARCHAR(100) NOT NULL,
	Fright BIGINT
)
--اضافه شدن کلید اصلی به جدول
ALTER TABLE Sales.OrderHeader ADD CONSTRAINT PK_OrderHeader
PRIMARY KEY CLUSTERED (OrderHeaderID)
GO
--Customer.Customer و Sales.OrderHeader ایجاد ارتباط بین جدول 
ALTER TABLE Sales.OrderHeader ADD CONSTRAINT FK_OrderHeader_Customer
FOREIGN KEY(CustomerID) REFERENCES Customer.Customer(CustomerID)
	ON UPDATE  NO ACTION 
	ON DELETE  NO ACTION 
GO
--Geographics.City و Sales.OrderHeader ایجاد ارتباط بین جدول 
ALTER TABLE Sales.OrderHeader ADD CONSTRAINT FK_OrderHeader_City
FOREIGN KEY(ShipStateCode,ShipCityCode) REFERENCES Geographics.City(StateCode,CityCode)
	ON UPDATE  NO ACTION 
	ON DELETE  NO ACTION 
GO

-----------------------------------------------------------------------

--OrderDetail ایجاد جدول 
CREATE TABLE Sales.OrderDetail
(
	OrderDetailID INT IDENTITY(1,1) NOT NULL,
	OrderHeaderID  INT NOT NULL,
	ProductID INT NOT NULL ,
	UnitPrice BIGINT NOT NULL,
	Quantity DECIMAL(12,2) NOT NULL,
	Discount BIGINT ,
	RowTotalPrice BIGINT ,
)
GO

--اضافه شدن کلید اصلی به جدول
ALTER TABLE Sales.OrderDetail ADD CONSTRAINT PK_OrderDetail
PRIMARY KEY CLUSTERED (OrderDetailID)
GO
--اضافه شدن کلید یکتا به جدول
ALTER TABLE Sales.OrderDetail ADD CONSTRAINT UK_OrderDetail 
UNIQUE NONCLUSTERED  (OrderHeaderID,ProductID)
GO
--Sales.OrderHeader و Sales.OrderDetail ایجاد ارتباط بین جدول 
ALTER TABLE Sales.OrderDetail ADD CONSTRAINT FK_OrderDetail_OrderHeader
FOREIGN KEY(OrderHeaderID) REFERENCES Sales.OrderHeader(OrderHeaderID)
	ON UPDATE  NO ACTION 
	ON DELETE  NO ACTION 
GO
--Production.Product و Sales.OrderDetail ایجاد ارتباط بین جدول 
ALTER TABLE Sales.OrderDetail ADD CONSTRAINT FK_OrderDetail_Product
FOREIGN KEY(ProductID) REFERENCES Production.Product(ProductID)
	ON UPDATE  NO ACTION 
	ON DELETE  NO ACTION 
GO

-----------------------------------------------------------------------

---- ایجاد جدول خطاها یا استفاده از ELMAH
--CREATE TABLE Customer.Error
--(
   --
--)
--GO
