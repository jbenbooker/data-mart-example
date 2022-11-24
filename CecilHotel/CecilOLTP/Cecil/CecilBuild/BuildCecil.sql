-- Cecil Database Script Developed by Jean Ben Booker
-- Originally Created: September & October 2022
-----------------------------------------------------------
-- Replace <data_path> with the full path to this file 
-- Ensure it ends with a backslash. 
-- E.g., C:\MyDatabases\ See line 17
-----------------------------------------------------------

IF NOT EXISTS(SELECT * FROM sys.databases
WHERE NAME = N'Cecil')
CREATE DATABASE Cecil
GO
USE Cecil

DECLARE
@data_path NVARCHAR(256);
SELECT @data_path = 'C:\MyDatabases\';



-- Drop Tables

IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'RESERVATION'
       )
DROP TABLE RESERVATION;


IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'ROOM'
       )
DROP TABLE ROOM;


IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'STYLE'
       )
DROP TABLE STYLE;


IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'EMPLOYEE_HISTORY'
       )
DROP TABLE EMPLOYEE_HISTORY;


IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'EMPLOYEE'
       )
DROP TABLE EMPLOYEE;


IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'PAYMENT'
       )
DROP TABLE PAYMENT;


IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'DISCOUNT'
       )
DROP TABLE DISCOUNT;


IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'CUSTOMER'
       )
DROP TABLE CUSTOMER;


IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'HOTEL'
       )
DROP TABLE HOTEL;


IF EXISTS(
SELECT *
FROM sys.tables
WHERE NAME = N'BRAND'
       )
DROP TABLE BRAND;



-- Create Tables

CREATE TABLE BRAND
(
BrandID 				INT IDENTITY (1,1) CONSTRAINT pk_brand PRIMARY KEY
, BrandName 			NVARCHAR(50) NOT NULL
, BrandStreet 			NVARCHAR(50) NOT NULL
, BrandCity 			NVARCHAR(30) NOT NULL
, BrandState			NCHAR(2) NOT NULL
, BrandZip 				NVARCHAR(10) NOT NULL
, BrandPhone 			NVARCHAR(13) NOT NULL
);

CREATE TABLE HOTEL
(
HotelID 				INT IDENTITY (1,1) CONSTRAINT pk_hotel PRIMARY KEY
, BrandID 				INT NOT NULL
, HotelName 			NVARCHAR(50) NOT NULL
, HotelNumRoom			INT NOT NULL
, HotelRating 			NCHAR(1) NOT NULL
, HotelStreet 			NVARCHAR(50) NOT NULL
, HotelCity 			NVARCHAR(30) NOT NULL
, HotelState			NCHAR(2) NOT NULL
, HotelZip 				NVARCHAR(10) NOT NULL
, HotelPhone 			NVARCHAR(13) NOT NULL
, HotelBuildYear		INT NOT NULL
, HotelRenoYear			INT NOT NULL
, CONSTRAINT fk_hotel_brand FOREIGN KEY (BrandID) REFERENCES BRAND (BrandID)
);

CREATE TABLE CUSTOMER
(
CustomerID 				INT IDENTITY (1,1) CONSTRAINT pk_customer PRIMARY KEY
, CustFirstName 		NVARCHAR(25) NOT NULL
, CustLastName 			NVARCHAR(25) NOT NULL
, CustStreet 			NVARCHAR(50) NOT NULL
, CustCity 				NVARCHAR(30) NOT NULL
, CustState				NCHAR(2) NOT NULL
, CustZip 				NVARCHAR(10) NOT NULL
, CustPhone 			NVARCHAR(13) NOT NULL
, CustDOB				DATE NOT NULL
);

CREATE TABLE DISCOUNT
(
DiscountID 				INT IDENTITY (1,1) CONSTRAINT pk_discount PRIMARY KEY
, DiscType				NVARCHAR(25) NOT NULL
, DiscValue				DECIMAL(2,2) NOT NULL
);

CREATE TABLE PAYMENT
(
PaymentID 				INT IDENTITY (1,1) CONSTRAINT pk_payment PRIMARY KEY
, CustomerID			INT NOT NULL
, DiscountID			INT NOT NULL
, PayType				NVARCHAR(25) NOT NULL
, PayDate				DATETIME NOT NULL
, CONSTRAINT fk_customer_payment FOREIGN KEY (CustomerID) REFERENCES CUSTOMER (CustomerID)
, CONSTRAINT fk_payment_discount FOREIGN KEY (DiscountID) REFERENCES DISCOUNT (DiscountID)
);

CREATE TABLE EMPLOYEE
(
EmployeeID 				INT IDENTITY (1,1) CONSTRAINT pk_employee PRIMARY KEY
, HotelID				INT NOT NULL
, EmpFirstName 			NVARCHAR(25) NOT NULL
, EmpLastName 			NVARCHAR(25) NOT NULL
, EmpStreet 			NVARCHAR(50) NOT NULL
, EmpCity 				NVARCHAR(30) NOT NULL
, EmpState				NCHAR(2) NOT NULL
, EmpZip 				NVARCHAR(10) NOT NULL
, EmpPhone 				NVARCHAR(13) NOT NULL
, EmpDOB				DATE NOT NULL
, CONSTRAINT fk_employee_hotel FOREIGN KEY (HotelID) REFERENCES HOTEL (HotelID)
);

CREATE TABLE EMPLOYEE_HISTORY
(
EmployeeHistoryID 		INT IDENTITY (1,1) CONSTRAINT pk_employee_history PRIMARY KEY
, EmployeeID			INT NOT NULL
, EmpHistPosition		NVARCHAR(50) NOT NULL
, EmpHistDepartment		NVARCHAR(25) NOT NULL
, EmpHistSalary			MONEY NOT NULL
, EmpHistStartDate		DATE NOT NULL
, EmpHistEndDate		DATE
, CONSTRAINT fk_employee_history_employee FOREIGN KEY (EmployeeID) REFERENCES EMPLOYEE (EmployeeID)
);

CREATE TABLE STYLE
(
StyleID 				INT IDENTITY (1,1) CONSTRAINT pk_style PRIMARY KEY
, StyleNumBed			INT NOT NULL
, StyleTier				NVARCHAR(25) NOT NULL
, StyleTierNumber		NCHAR(1) NOT NULL
, StyleBaseRate			MONEY NOT NULL
, StyleMaxOccupancy		INT NOT NULL
);

CREATE TABLE ROOM
(
RoomID 					INT IDENTITY (1,1) CONSTRAINT pk_room PRIMARY KEY
, HotelID				INT NOT NULL
, StyleID				INT NOT NULL
, RoomNumber			INT NOT NULL
, RoomAvailability		BIT NOT NULL
, RoomDirection			NVARCHAR(5) NOT NULL
, RoomDirectionNumber	NCHAR(1) NOT NULL
, RoomAccessibility 	NVARCHAR(30)
, RoomSqFt				INT NOT NULL
, CONSTRAINT fk_room_hotel FOREIGN KEY (HotelID) REFERENCES HOTEL (HotelID)
, CONSTRAINT fk_room_style FOREIGN KEY (StyleID) REFERENCES STYLE (StyleID)
);

CREATE TABLE RESERVATION
(
ReservationID 			INT IDENTITY (1,1) CONSTRAINT pk_reservation PRIMARY KEY
, HotelID				INT NOT NULL
, CustomerID			INT NOT NULL
, RoomID				INT NOT NULL
, ResNumAdult			INT NOT NULL
, ResNumChild			INT NOT NULL
, ResRequest			NVARCHAR(500) NOT NULL
, ResCheckIn			DATETIME NOT NULL
, ResCheckOut			DATETIME
, ResDayRate			MONEY NOT NULL
, ResDeposite			MONEY NOT NULL
, ResFoodCharge			MONEY NOT NULL
, ResPetCharge			MONEY NOT NULL
, ResLateCharge			MONEY NOT NULL
, ResDamageCharge		MONEY NOT NULL
, CONSTRAINT fk_reservation_hotel FOREIGN KEY (HotelID) REFERENCES HOTEL (HotelID)
, CONSTRAINT fk_reservation_customer FOREIGN KEY (CustomerID) REFERENCES CUSTOMER (CustomerID)
, CONSTRAINT fk_reservation_room FOREIGN KEY (RoomID) REFERENCES ROOM (RoomID)
, CONSTRAINT ck_reservation_checkout CHECK ((ResCheckOut > ResCheckIn) OR (ResCheckOut IS NULL))
);



-- Insert Data

EXECUTE (N'BULK INSERT BRAND FROM ''' + @data_path + N'BrandData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT HOTEL FROM ''' + @data_path + N'HotelData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT CUSTOMER FROM ''' + @data_path + N'CustomerData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT DISCOUNT FROM ''' + @data_path + N'DiscountData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT PAYMENT FROM ''' + @data_path + N'PaymentData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT EMPLOYEE FROM ''' + @data_path + N'EmployeeData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT EMPLOYEE_HISTORY FROM ''' + @data_path + N'EmployeeHistoryData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT STYLE FROM ''' + @data_path + N'StyleData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT ROOM FROM ''' + @data_path + N'RoomData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');

EXECUTE (N'BULK INSERT RESERVATION FROM ''' + @data_path + N'ReservationData.csv''
WITH (
	FIRSTROW = 2,
	CHECK_CONSTRAINTS,
	CODEPAGE=''ACP'',
	DATAFILETYPE = ''char'',
	FIELDTERMINATOR= '','',
	ROWTERMINATOR = ''\n'',
	TABLOCK
	);
');



-- List Tables and Row Counts

SET NOCOUNT ON
SELECT 'BRAND' AS "Table",	COUNT(*) AS "Rows"	FROM BRAND				UNION
SELECT 'HOTEL',				COUNT(*)			FROM HOTEL				UNION
SELECT 'CUSTOMER',			COUNT(*)			FROM CUSTOMER			UNION
SELECT 'DISCOUNT',			COUNT(*)			FROM DISCOUNT			UNION
SELECT 'PAYMENT',			COUNT(*)			FROM PAYMENT			UNION
SELECT 'EMPLOYEE',			COUNT(*)			FROM EMPLOYEE			UNION
SELECT 'EMPLOYEE_HISTORY',	COUNT(*)			FROM EMPLOYEE_HISTORY	UNION
SELECT 'STYLE',				COUNT(*)			FROM STYLE				UNION
SELECT 'ROOM',				COUNT(*)			FROM ROOM				UNION
SELECT 'RESERVATION',		COUNT(*)			FROM RESERVATION
ORDER BY 1;
SET NOCOUNT OFF
GO