-- Cecil Data Mart Script Developed by Jean Ben Booker
-- Originally Created: October 2022
-----------------------------------------------------------
IF NOT EXISTS(SELECT * FROM sys.databases
	WHERE NAME = N'CecilDM')
	CREATE DATABASE CecilDM
GO 

USE CecilDM


-- Drop Fact Table and Dimensions

IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'FactReservation'
	)
	DROP TABLE FactReservation;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimCustomer'
	)
	DROP TABLE DimCustomer;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimRoom'
	)
	DROP TABLE DimRoom;
--
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimHotel'
	)
	DROP TABLE DimHotel;
-- 
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimTime'
	)
	DROP TABLE DimTime;
-- 
IF EXISTS(
	SELECT *
	FROM sys.tables
	WHERE NAME = N'DimDate'
	)
	DROP TABLE DimDate;
	
	
-- Create Dimensions and Fact Table

CREATE TABLE DimDate 
(
Date_SK				INT CONSTRAINT pk_date_sk PRIMARY KEY 
, Date				DATE
, FullDate			NCHAR(10) -- Date in MM-dd-yyyy format
, DayOfMonth		INT -- Field will hold day number of Month
, DayName			NVARCHAR(9) -- Contains name of the day, Sunday, Monday 
, DayOfWeek			INT -- First Day Sunday=1 and Saturday=7
, DayOfWeekInMonth	INT -- 1st Monday or 2nd Monday in Month
, DayOfWeekInYear	INT
, DayOfQuarter		INT
, DayOfYear			INT
, WeekOfMonth		INT -- Week Number of Month 
, WeekOfQuarter		INT -- Week Number of the Quarter
, WeekOfYear		INT -- Week Number of the Year
, Month				INT -- Number of the Month 1 to 12{}
, MonthName			NVARCHAR(9) -- January, February etc
, MonthOfQuarter	INT -- Month Number belongs to Quarter
, Quarter			NCHAR(2) 
, QuarterName		NVARCHAR(9) -- First,Second...
, Year				INT -- Year value of Date stored in Row
, YearName			NCHAR(7) -- CY 2017,CY 2018
, MonthYear			NCHAR(10) -- Jan-2018,Feb-2018
, MMYYYY			INT
, FirstDayOfMonth	DATE
, LastDayOfMonth	DATE
, FirstDayOfQuarter	DATE
, LastDayOfQuarter	DATE
, FirstDayOfYear	DATE
, LastDayOfYear		DATE
, IsHoliday			BIT -- Flag 1=National Holiday, 0-No National Holiday
, IsWeekday			BIT -- 0=Week End ,1=Week Day
, Holiday			NVARCHAR(50) -- Name of Holiday in US
, Season			NVARCHAR(10) -- Name of Season
);
--
CREATE TABLE DimTime
(
Time_SK 			INT IDENTITY(1,1) CONSTRAINT [PK_dim_time] PRIMARY KEY
, Time 				NCHAR(8) NOT NULL
, Hour 				NCHAR(2) NOT NULL
, MilitaryHour 		NCHAR(2) NOT NULL
, Minute 			NCHAR(2) NOT NULL
, Second 			NCHAR(2) NOT NULL
, AmPm 				NCHAR(2) NOT NULL
, StandardTime 		NCHAR(11) NULL
);
--
CREATE TABLE DimHotel
(
Hotel_SK 			INT IDENTITY (1,1) CONSTRAINT pk_hotel_sk PRIMARY KEY
, Hotel_AK			INT NOT NULL
, Rooms 			INT NOT NULL -- Number of rooms in the hotel
, Rating 			NCHAR(1) NOT NULL -- Rating 1 through 5
, City				NVARCHAR(30) NOT NULL
, Built 			INT NOT NULL -- Year of construction
, Renovation 		INT NOT NULL -- Year of most recent renovation, 9999 if the hotel has not been renovated
, RenovationStart	DATE NOT NULL -- Historical data field
, RenovationEnd		DATE -- Historical data field
, Brand 			NVARCHAR(50) NOT NULL -- Brand name or chain to which the hotel belongs
);
--
CREATE TABLE DimRoom
(
Room_SK 			INT IDENTITY (1,1) CONSTRAINT pk_room_sk PRIMARY KEY
, Room_AK			INT NOT NULL
, Direction 		NVARCHAR(5) NOT NULL -- Cardinal direction the room is facing
, Accessibility 	NVARCHAR(30) NOT NULL -- Types of impairment the room has support for
, Beds				INT NOT NULL -- Number of beds in the room, including pullouts
, Tier 				NVARCHAR(25) NOT NULL -- Class of room; gold, platinum etc.
, BaseRate 			MONEY NOT NULL
, BaseRateStart		DATE NOT NULL -- Historical data field
, BaseRateEnd		DATE -- Historical data field
, Occupancy 		INT NOT NULL -- Maximum number of occupants
);
--
CREATE TABLE DimCustomer
(
Customer_SK 		INT IDENTITY (1,1) CONSTRAINT pk_customer_sk PRIMARY KEY
, Customer_AK		INT NOT NULL
, DOB 				DATE NOT NULL
, State 			NCHAR(2) NOT NULL -- State listed on customers identification
, PayType			NVARCHAR(25) NOT NULL -- Card processor; Mastercard, Visa, Amex, Discover
, DiscType			NVARCHAR(25) NOT NULL -- Name of discount, NA for none applied
, DiscValue			DECIMAL(2,2) NOT NULL -- Value of discount; i.e. 10% off is held as (.10)
);
--
CREATE TABLE FactReservation
(
Customer_SK 		INT NOT NULL
, Room_SK			INT NOT NULL
, Hotel_SK			INT NOT NULL
, CheckInDate		INT NOT NULL
, CheckOutDate 		INT -- Nullable as check out date will not be available for all reservations at time of ETL
, CheckInTime		INT NOT NULL
, CheckOutTime 		INT -- Nullable as check out time will not be available for all reservations at time of ETL
, Adults 			INT NOT NULL -- Number of adults in the party
, Children 			INT NOT NULL -- Number of children in the party
, Rate 				MONEY NOT NULL -- Rate of charge for the room each day
, Food 				MONEY NOT NULL -- Charge for food and drink purchased from the hotel; room service, room charge from resaurant, minifridge etc.
, Pet 				MONEY NOT NULL -- Charge for bringing a pet; initial fee to cover additional cleaning, further fees relating to pet mess
, Late 				MONEY NOT NULL -- Charge for checking out of the room after the specified time
, Damage			MONEY NOT NULL -- Charge for any damage found to property of the hotel
, CONSTRAINT pk_fact_reservation PRIMARY KEY (Customer_SK, Room_SK, Hotel_SK, CheckInDate, CheckInTime)
, CONSTRAINT fk_dim_customer FOREIGN KEY (Customer_SK) REFERENCES DimCustomer (Customer_SK)
, CONSTRAINT fk_dim_room FOREIGN KEY (Room_SK) REFERENCES DimRoom (Room_SK)
, CONSTRAINT fk_dim_hotel FOREIGN KEY (Hotel_SK) REFERENCES DimHotel (Hotel_SK)
, CONSTRAINT fk_checkin_dim_date FOREIGN KEY (CheckInDate) REFERENCES DimDate (Date_SK)
, CONSTRAINT fk_checkout_dim_date FOREIGN KEY (CheckOutDate) REFERENCES DimDate (Date_SK)
, CONSTRAINT fk_checkin_dim_time FOREIGN KEY (CheckInTime) REFERENCES DimTime (Time_SK)
, CONSTRAINT fk_checkout_dim_time FOREIGN KEY (CheckOutTime) REFERENCES DimTime (Time_SK)
);