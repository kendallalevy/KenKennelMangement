/******************************
** File:	schema.sql
** Desc:	Create schema and populate tables for kennel management software
** Author:	Kendall Levy
** Date:	6/9/24
**********************
** Change History
**********************
** PR	Date		Author		Description
** 1	6/9/24		Kendall		Created all tables for schema
** 2	6/13/24		Kendall		Inserted dummy data for tables
******************************/
USE master;
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'KenKennel'
)
DROP DATABASE KenKennel;
GO

CREATE DATABASE KenKennel;
GO

USE KenKennel;
GO
-- Drop tables in referential order if exists
DROP TABLE IF EXISTS
DOG_HISTORY,
DOG_MED,
DOG_VAX,
DOG_TAG,
MEDICATION,
ACTIVITY_VISIT,
ACTIVITY,
BELONGING,
DOG,
RUN,
CUSTOMER_ADDRESS,
[ADDRESS],
RUN_TYPE,
BUILDING,
ACTIVITY_TYPE,
BELONGING_TYPE,
VISIT_STATUS,
VISIT,
VACCINATION,
TAG,
SEX,
BREED,
MED_TYPE,
PHONE_NUM,
ADDRESS_TYPE,
[STATE],
CUSTOMER;
GO

/*
	Table: BELONGING_TYPE

	Description: Stores the type of belonging that the customers bring in for their dog

	Columns:
	- BelongingTypeID: unique identifier for each type
	- BelongingTypeName: brief description of each belonging type
	
	Constraints:
	- BelongingTypeID: PK
*/
CREATE TABLE dbo.BELONGING_TYPE
(
	BelongingTypeID int IDENTITY NOT NULL, 
	BelongingTypeName varchar(50) NOT NULL,
    CONSTRAINT PK_belongingType PRIMARY KEY (BelongingTypeID)
);
GO

/*
	Table: ACTIVITY_TYPE

	Description: Stores types of activities offered to dogs

	Columns:
	- ActivityTypeID: unique identifier for each type
	- ActivityTypeName: Label for each type
	- ActivityTypeDescr: Brief description of each type

	Constraints:
	- ActivityTypeID: PK
*/
CREATE TABLE dbo.ACTIVITY_TYPE
(
	ActivityTypeID int IDENTITY NOT NULL, 
	ActivityTypeName varchar(50) NOT NULL,
	ActivityTypeDescr varchar(100) NOT NULL,
    CONSTRAINT PK_activityType PRIMARY KEY (ActivityTypeID)
);
GO

/*
	Table: BUILDING

	Description: Stores information about each building

	Columns:
	- BuildingID: unique identifier for each building
	- BuildingName: Label for each building
	- BuildingDescr: Brief description of each building

	Constraints:
	- BuildingID: PK
*/
CREATE TABLE dbo.BUILDING
(
	BuildingID int IDENTITY NOT NULL, 
	BuildingName char(1) NOT NULL,
	BuildingDescr varchar(255) NOT NULL,
    CONSTRAINT PK_building PRIMARY KEY (BuildingID)
);
GO

/*
	Table: RUN_TYPE

	Description: Stores types of dog runs

	Columns:
	- RunTypeID: unique identifier for each type
	- RunTypeName: Label for each type
	- RunTypeAbrv: Abreviation for each type

	Constraints:
	- RunTypeID: PK
*/
CREATE TABLE dbo.RUN_TYPE
(
	RunTypeID int IDENTITY NOT NULL, 
	RunTypeName varchar(25) NOT NULL,
	RunTypeAbrv char(1) NOT NULL,
    CONSTRAINT PK_runType PRIMARY KEY (RunTypeID)
);
GO

/*
	Table: VISIT_STATUS

	Description: Stores status types for visits

	Columns:
	- StatusID: unique identifier for each type
	- Status: Label for each type

	Constraints:
	- StatusID: PK
*/
CREATE TABLE dbo.VISIT_STATUS
(
	StatusID int IDENTITY NOT NULL, 
	VisitStatus varchar(50) NOT NULL,
    CONSTRAINT PK_visitStatus PRIMARY KEY (StatusID)
);
GO

/*
	Table: VACCINATION

	Description: Stores vaccination types

	Columns:
	- VaxID: unique identifier for each type
	- VaxName: Label for each type

	Constraints:
	- VaxID: PK
*/
CREATE TABLE dbo.VACCINATION
(
	VaxID int IDENTITY NOT NULL, 
	VaxName varchar(25) NOT NULL,
    CONSTRAINT PK_vaccination PRIMARY KEY (VaxID)
);
GO

/*
	Table: TAG

	Description: Stores specific tags for dogs regarding things such as behavioral or medical information

	Columns:
	- TagID: unique identifier for each tag
	- TagDescr: Brief description of each tag

	Constraints:
	- TagID: PK
*/
CREATE TABLE dbo.TAG
(
	TagID int IDENTITY NOT NULL, 
	TagDescr varchar(50) NOT NULL,
    CONSTRAINT PK_tag PRIMARY KEY (TagID)
);
GO

/*
	Table: SEX

	Description: Stores sex or neuter/spay status of dogs

	Columns:
	- SexID: unique identifier for each value
	- SexAbrv: Label for each type
	- SexName: Neuter, Spayed, Male, or Female

	Constraints:
	- SexID: PK
*/
CREATE TABLE dbo.SEX
(
	SexID int IDENTITY NOT NULL, 
	SexAbrv char(1) NOT NULL,
	SexName varchar(10) NOT NULL,
    CONSTRAINT PK_sex PRIMARY KEY (SexID)
);
GO

/*
	Table: BREED

	Description: Stores breeds of dogs

	Columns:
	- BreedID: unique identifier for each breed
	- BreedName: Name of breed

	Constraints:
	- BreedID: PK
*/
CREATE TABLE dbo.BREED
(
	BreedID int IDENTITY NOT NULL, 
	BreedName varchar(50) NOT NULL,
    CONSTRAINT PK_breed PRIMARY KEY (BreedID)
);
GO

/*
	Table: MED_TYPE

	Description: Stores types of medications administered to dogs

	Columns:
	- MedTypeID: unique identifier for each type
	- MedTypeName: Name of medication

	Constraints:
	- MedTypeID: PK
*/
CREATE TABLE dbo.MED_TYPE
(
	MedTypeID int IDENTITY NOT NULL, 
	MedTypeName varchar(25) NOT NULL,
	Color varchar(10) NOT NULL,
    CONSTRAINT PK_medType PRIMARY KEY (MedTypeID)
);
GO

/*
	Table: ADDRESS_TYPE

	Description: Stores types of addresses

	Columns:
	- AddressTypeID: unique identifier for each address
	- AddressTypeName: name of each address type (billing, home, business)

	Constraints:
	- AddressTypeID: PK
*/
CREATE TABLE dbo.ADDRESS_TYPE
(
	AddressTypeID int IDENTITY NOT NULL, 
	AddressTypeName varchar(50) NOT NULL,
    CONSTRAINT PK_addressType PRIMARY KEY (AddressTypeID)
);
GO

/*
	Table: STATE

	Description: Stores U.S. states

	Columns:
	- StateID: unique identifier for each state
	- StateName: The name of each state
	- State Abrv: 2 character abreviation of each state

	Constraints:
	- StateID: PK
*/
CREATE TABLE dbo.[STATE]
(
	StateID int IDENTITY NOT NULL, 
	StateName varchar(50) NOT NULL,
	StateAbrv char(2) NOT NULL,
    CONSTRAINT PK_state PRIMARY KEY (StateID)
);
GO

/*
	Table: RUN

	Description: Stores different Runs for dogs to go in

	Columns:
	- RunID: unique identifier for each run
	- BuildingID: id of the building the run is in
	- RunTypeID: id of the type of run it is
	- RunNumber: run identifier in the format building, type (if applicable), number. e.g. (EL78 or AC10)

	Constraints:
	- RunID: PK
	- BuildingID: FK referencing BUILDING
	- RunTypeID: FK referencing RUN_TYPE
*/
CREATE TABLE dbo.RUN
(
	RunID int IDENTITY NOT NULL, 
	BuildingID int NOT NULL,
	RunTypeID int NULL,
	RunNumber varchar(5) UNIQUE NOT NULL,
    CONSTRAINT PK_run PRIMARY KEY (RunID),
	CONSTRAINT FK_run_building FOREIGN KEY (BuildingID) REFERENCES dbo.BUILDING (BuildingID),
	CONSTRAINT FK_run_runType FOREIGN KEY (RunTypeID) REFERENCES dbo.RUN_TYPE (RunTypeID)
);
GO

/*
	Table: CUSTOMER

	Description: Stores information about different customers

	Columns:
	- CustID: unique identifier for each customer
	- PhoneNumID: id of a phone number

	Constraints:
	- ActivityID: PK
	- ActivityTypeID: FK referencing ACTIVITY_TYPE
*/
CREATE TABLE dbo.CUSTOMER
(
	CustID int IDENTITY NOT NULL, 
	FName varchar(50) NOT NULL,
	LName varchar(50) NOT NULL,
	Email varchar(100) NULL,
    CONSTRAINT PK_customer PRIMARY KEY (CustID)
);
GO

/*
	Table: PHONE_NUM

	Description: Stores phone numbers

	Columns:
	- PhoneNumID: unique identifier for each number
	- Num: The number

	Constraints:
	- PhoneNumID: PK
*/
CREATE TABLE dbo.PHONE_NUM
(
	PhoneNumID int IDENTITY NOT NULL, 
	CustID INT NULL,
	Num varchar(11) NOT NULL,
    CONSTRAINT PK_phoneNum PRIMARY KEY (PhoneNumID),
	CONSTRAINT FK_customer_phoneNum FOREIGN KEY (CustID) REFERENCES dbo.CUSTOMER (CustID)
);
GO

/*
	Table: DOG

	Description: Stores information about different dogs

	Columns:
	- DogID: unique identifier for each dog
	- BreedID: id of the main breed of the dog
	- CustID: id of the owner
	- SexID: id of the sex of the dog
	- Age: age of the dog
	- Name: dog's name
	- Nickname: if dog has a short version of name
	- Weight: weight in lb
	- Color: description of the color of the dog
	- Vet: name of the vet the dog regularly sees
	- Notes: any special notes

	Constraints:
	- DogID: PK
	- BreedID: FK referencing BREED
	- CustID: FK referencing CUSTOMER
	- SexID: FK referencing SEX
*/
CREATE TABLE dbo.DOG
(
	DogID int IDENTITY NOT NULL, 
	BreedID int NULL,
	CustID int NOT NULL,
	SexID int NOT NULL,
	Age varchar(25) NULL,
	[Name] varchar(50) NOT NULL,
	Nickname varchar(25) NULL,
	[Weight] decimal(4,1) NOT NULL,
	Color varchar(25) NULL,
	Vet varchar(50) NULL,
	Notes varchar(150) NULL,
    CONSTRAINT PK_dog PRIMARY KEY (DogID),
	CONSTRAINT FK_dog_breed FOREIGN KEY (BreedID) REFERENCES dbo.BREED (BreedID),
	CONSTRAINT FK_dog_customer FOREIGN KEY (CustID) REFERENCES dbo.CUSTOMER (CustID),
	CONSTRAINT FK_dog_sex FOREIGN KEY (SexID) REFERENCES dbo.SEX (SexID)
);
GO

/*
	Table: VISIT

	Description: Stores each booked visit

	Columns:
	- VisitID: unique identifier for each visit
	- DogID: id of the dog associated with the visit
	- RunID: id of the run the visit is in
	- StatusID: id of status of the visit
	- ArrivalDate: date the dog arrived/arrives
	- DepartDate: date the dog departed/departs
	- GroomDate: date the dog is groomed
	- TotCost: total cost charged to the owners (excluding tax)

	Constraints:
	- VisitID: PK
	- DogID: FK referencing DOG
	- RunID: FK referencing RUN
	- StatusID: FK referencing VISIT_STATUS
*/
CREATE TABLE dbo.VISIT
(
	VisitID int IDENTITY NOT NULL, 
	DogID int NOT NULL,
	RunID int NOT NULL,
	StatusID int NOT NULL,
	ArrivalDate date NOT NULL,
	DepartDate date NULL,
	GroomDate date NULL,
	TotCost money NULL,
    CONSTRAINT PK_visit PRIMARY KEY (VisitID),
	CONSTRAINT FK_visit_dog FOREIGN KEY (DogID) REFERENCES dbo.DOG (DogID),
	CONSTRAINT FK_visit_run FOREIGN KEY (RunID) REFERENCES dbo.RUN (RunID),
	CONSTRAINT FK_visit_visitStatus FOREIGN KEY (StatusID) REFERENCES dbo.VISIT_STATUS (StatusID)
);
GO

/*
	Table: ACTIVITY

	Description: Stores each each activity for each visit

	Columns:
	- ActivityID: unique identifier for each activity
	- ActivityTypeID: id for the type of activity that it is
	- VisitID: id for the visit the activity takes place during
	- ActivityDate: Date that the activity takes place on

	Constraints:
	- ActivityID: PK
	- VisitID: FK referencing VISIT
*/
CREATE TABLE dbo.ACTIVITY
(
	ActivityID int IDENTITY NOT NULL, 
	ActivityTypeID int NOT NULL,
	VisitID int NOT NULL,
	ActivityDate DATE UNIQUE NOT NULL,
    CONSTRAINT PK_activity PRIMARY KEY (ActivityID),
	CONSTRAINT FK_activity_visit FOREIGN KEY (VisitID) REFERENCES dbo.VISIT (VisitID),
	CONSTRAINT FK_activity_activityType FOREIGN KEY (ActivityTypeID) REFERENCES dbo.ACTIVITY_TYPE (ActivityTypeID)
);
GO

/*
    Table: BELONGING

    Description: Stores information about belongings associated with dogs.

    Columns:
    - BelongingID: unique identifier for each belonging
    - DogID: ID of the dog the belonging belongs to
    - BelongingTypeID: ID indicating the type of belonging
    - BelongingDescr: Description of the belonging

    Constraints:
    - BelongingID: PK
    - DogID: FK referencing DOG
    - BelongingTypeID: FK referencing BELONGING_TYPE
*/
CREATE TABLE dbo.BELONGING
(
    BelongingID int IDENTITY NOT NULL,
    DogID int NOT NULL,
    BelongingTypeID int NOT NULL,
    BelongingDescr varchar(50) NULL,
    CONSTRAINT PK_belonging PRIMARY KEY (BelongingID),
    CONSTRAINT FK_belonging_dog FOREIGN KEY (DogID) REFERENCES dbo.DOG (DogID),
    CONSTRAINT FK_belonging_belongingType FOREIGN KEY (BelongingTypeID) REFERENCES dbo.BELONGING_TYPE (BelongingTypeID)
);
GO

/*
    Table: DOG_TAG

    Description: Stores information about tags associated with dogs.

    Columns:
    - DogTagID: unique identifier for each dog tag
    - DogID: ID of the dog associated with the tag
    - TagID: ID of the tag type

    Constraints:
    - DogTagID: PK
    - DogID: FK referencing DOG
    - TagID: FK referencing TAG
*/
CREATE TABLE dbo.DOG_TAG
(
    DogTagID int IDENTITY NOT NULL,
    DogID int NOT NULL,
    TagID int NOT NULL,
    CONSTRAINT PK_dogTag PRIMARY KEY (DogTagID),
    CONSTRAINT FK_dogTag_dog FOREIGN KEY (DogID) REFERENCES dbo.DOG (DogID),
    CONSTRAINT FK_dogTag_tag FOREIGN KEY (TagID) REFERENCES dbo.TAG (TagID)
);
GO

/*
    Table: DOG_VAX

    Description: Stores information about vaccinations associated with dogs.

    Columns:
    - DogVaxID: unique identifier for each vaccination record
    - DogID: ID of the dog associated with the vaccination
    - VaxID: ID of the vaccination type
    - VaxDate: Date of the vaccination

    Constraints:
    - DogVaxID: PK
    - DogID: FK referencing DOG
    - VaxID: FK referencing VACCINATION
*/
CREATE TABLE dbo.DOG_VAX
(
    DogVaxID int IDENTITY NOT NULL,
    DogID int NOT NULL,
    VaxID int NOT NULL,
    VaxDate DATE NOT NULL,
    CONSTRAINT PK_dogVax PRIMARY KEY (DogVaxID),
    CONSTRAINT FK_dogVax_dog FOREIGN KEY (DogID) REFERENCES dbo.DOG (DogID),
    CONSTRAINT FK_dogVax_vaccination FOREIGN KEY (VaxID) REFERENCES dbo.VACCINATION (VaxID)
);
GO

/*
    Table: ADDRESS

    Description: Stores information about addresses.

    Columns:
    - AddressID: unique identifier for each address
    - StateID: ID of the state
    - AddressTypeID: ID of the address type
    - AddressLine1: First line of the address
    - AddressLine2: Second line of the address
    - City: City of the address
    - Zip: ZIP code of the address

    Constraints:
    - AddressID: PK
    - StateID: FK referencing STATE
    - AddressTypeID: FK referencing ADDRESS_TYPE
*/
CREATE TABLE dbo.[ADDRESS]
(
    AddressID int IDENTITY NOT NULL,
    StateID int NOT NULL,
    AddressTypeID int NULL,
    AddressLine1 varchar(100) NOT NULL,
    AddressLine2 varchar(100) NULL,
    City varchar(50) NOT NULL,
    Zip varchar(20) NOT NULL,
    CONSTRAINT PK_address PRIMARY KEY (AddressID),
    CONSTRAINT FK_address_state FOREIGN KEY (StateID) REFERENCES dbo.STATE (StateID),
    CONSTRAINT FK_address_addressType FOREIGN KEY (AddressTypeID) REFERENCES dbo.ADDRESS_TYPE (AddressTypeID)
);
GO

/*
    Table: CUSTOMER_ADDRESS

    Description: Stores information about addresses associated with customers.

    Columns:
    - CustAddressID: unique identifier for each customer address
    - AddressID: ID of the address
    - CustID: ID of the customer

    Constraints:
    - CustAddressID: PK
    - AddressID: FK referencing ADDRESS
    - CustID: FK referencing CUSTOMER
*/
CREATE TABLE dbo.CUSTOMER_ADDRESS
(
    CustAddressID int IDENTITY NOT NULL,
    AddressID int NOT NULL,
    CustID int NOT NULL,
    CONSTRAINT PK_customer_address PRIMARY KEY (CustAddressID),
    CONSTRAINT FK_customerAddress_address FOREIGN KEY (AddressID) REFERENCES dbo.ADDRESS (AddressID),
    CONSTRAINT FK_customerAddress_customer FOREIGN KEY (CustID) REFERENCES dbo.CUSTOMER (CustID)
);
GO

/*
    Table: MEDICATION

    Description: Stores information about medications.

    Columns:
    - MedID: unique identifier for each medication
    - MedTypeID: ID of the medication type
    - MedName: Name of the medication

    Constraints:
    - MedID: PK
    - MedTypeID: FK referencing MEDICATION_TYPE
*/
CREATE TABLE dbo.MEDICATION
(
    MedID int IDENTITY NOT NULL,
    MedTypeID int NOT NULL,
    MedName varchar(50) NOT NULL,
    CONSTRAINT PK_medication PRIMARY KEY (MedID),
    CONSTRAINT FK_medication_medType FOREIGN KEY (MedTypeID) REFERENCES dbo.MED_TYPE (MedTypeID)
);
GO

/*
    Table: DOG_MED

    Description: Stores information about medications given to dogs.

    Columns:
    - DogMedID: unique identifier for each record of medication given to a dog
    - MedID: ID of the medication
    - DogID: ID of the dog receiving the medication
    - Dose: The dose of medication given
    - Notes: Additional notes about the medication

    Constraints:
    - DogMedID: PK
    - MedID: FK referencing MEDICATION
    - DogID: FK referencing DOG
*/
CREATE TABLE dbo.DOG_MED
(
    DogMedID int IDENTITY NOT NULL,
    MedID int NOT NULL,
    DogID int NOT NULL,
    Dose varchar(100) NOT NULL,
    Notes varchar(100) NULL,
    CONSTRAINT PK_dogMed PRIMARY KEY (DogMedID),
    CONSTRAINT FK_dogMed_medication FOREIGN KEY (MedID) REFERENCES dbo.MEDICATION (MedID),
    CONSTRAINT FK_dogMed_dog FOREIGN KEY (DogID) REFERENCES dbo.DOG (DogID)
);
GO

/*
    Table: DOG_HISTORY

    Description: Stores historical information about dogs.

    Columns:
    - DogHistID: unique identifier for each dog history record
    - BreedID: ID of the breed
    - CustID: ID of the customer
    - Sex: Sex of the dog
    - Age: Age of the dog
    - Name: Name of the dog
    - Nickname: Nickname of the dog
    - Weight: Weight of the dog
    - Color: Color of the dog
    - Vet: Name of the veterinarian
    - Notes: Additional notes about the dog

    Constraints:
    - DogHistID: PK
    - BreedID: FK referencing BREED
    - CustID: FK referencing CUSTOMER
	- SexID: FK referencing SEX
*/
CREATE TABLE dbo.DOG_HISTORY
(
    DogHistID int IDENTITY NOT NULL,
    BreedID int NULL,
    CustID int NOT NULL,
    SexID int NOT NULL,
    Age varchar(25) NULL,
    [Name] varchar(50) NOT NULL,
    Nickname varchar(25) NULL,
    [Weight] decimal(3, 1) NOT NULL,
    Color varchar(25) NULL,
    Vet varchar(25) NULL,
    Notes varchar(100) NULL,
    CONSTRAINT PK_dogHistory PRIMARY KEY (DogHistID),
    CONSTRAINT FK_dogHistory_breed FOREIGN KEY (BreedID) REFERENCES dbo.BREED (BreedID),
    CONSTRAINT FK_dogHistory_customer FOREIGN KEY (CustID) REFERENCES dbo.CUSTOMER (CustID),
	CONSTRAINT FK_dogHistory_sex FOREIGN KEY (SexID) REFERENCES dbo.SEX (SexID)
);
GO

--=====================================================

/* Create index on CUSTOMER */
CREATE INDEX IX_CUSTOMER_LName ON CUSTOMER (LName);
GO

/* Create unique index on RUN */
CREATE UNIQUE INDEX IX_RUN_RunNumber ON RUN (RunNumber);
GO

--=====================================================
/* Populate tables with data */
INSERT INTO dbo.BELONGING_TYPE (BelongingTypeName)
VALUES 
    ('Bedding'),
    ('Toy'),
    ('Food'),
    ('Container'),
    ('Medication'),
    ('Clothing'),
    ('Restraints'),
    ('Crate'),
	('Other');
GO

INSERT INTO dbo.ACTIVITY_TYPE (ActivityTypeName, ActivityTypeDescr)
VALUES 
    ('Walk', '30 minute walk'),
	('Private Play', 'Play with staff'),
	('Group', 'Play with other dogs'),
	('Swim', 'Swim in pool with fitness coaches'),
	('Massage', 'Massage by trained therapist'),
	('Snuggle', 'Snuggle time with staff'),
	('Groom', 'Baths and grooming');
GO

INSERT INTO dbo.ADDRESS_TYPE (AddressTypeName)
VALUES
	('Billing'),
	('Home'),
	('Business');
GO

INSERT INTO dbo.[STATE] (StateName, StateAbrv)
VALUES
    ('Washington', 'WA'),
    ('Oregon', 'OR'),
    ('California', 'CA'),
    ('Nevada', 'NV'),
    ('Arizona', 'AZ'),
    ('Idaho', 'ID'),
    ('Utah', 'UT'),
    ('Colorado', 'CO'),
    ('Montana', 'MT'),
    ('New Mexico', 'NM');
GO


DECLARE @StateID int = (SELECT StateID FROM dbo.STATE WHERE StateName = 'Washington');
DECLARE @BillingID int = (SELECT AddressTypeID FROM dbo.ADDRESS_TYPE WHERE AddressTypeName = 'Billing');
DECLARE @HomeID int = (SELECT AddressTypeID FROM dbo.ADDRESS_TYPE WHERE AddressTypeName = 'Home');
DECLARE @BusinessID int = (SELECT AddressTypeID FROM dbo.ADDRESS_TYPE WHERE AddressTypeName = 'Business');

INSERT INTO dbo.[ADDRESS] (StateID, AddressTypeID, AddressLine1, AddressLine2, City, Zip)
VALUES
    (@StateID, @BillingID, '123 Maple St', NULL, 'Woodinville', '98072'),
    (@StateID, @HomeID, '456 Oak Ave', 'Apt 2', 'Woodinville', '98072'),
    (@StateID, @BusinessID, '789 Pine Ln', NULL, 'Woodinville', '98072'),
    (@StateID, @BillingID, '101 Birch St', 'Suite 300', 'Woodinville', '98072'),
    (@StateID, @HomeID, '202 Cedar Dr', NULL, 'Woodinville', '98072'),
    (@StateID, @BusinessID, '303 Spruce Ct', NULL, 'Woodinville', '98072'),
    (@StateID, @BillingID, '404 Fir Rd', NULL, 'Woodinville', '98072'),
    (@StateID, @HomeID, '505 Redwood Pl', NULL, 'Woodinville', '98072'),
    (@StateID, @BusinessID, '606 Sequoia Blvd', NULL, 'Woodinville', '98072'),
    (@StateID, @BillingID, '707 Palm Way', NULL, 'Woodinville', '98072'),
    (@StateID, @HomeID, '808 Elm St', NULL, 'Woodinville', '98072'),
    (@StateID, @BusinessID, '909 Ash Ln', NULL, 'Woodinville', '98072'),
    (@StateID, @BillingID, '110 Maple St', NULL, 'Bothell', '98011'),
    (@StateID, @HomeID, '111 Oak Ave', 'Apt 3', 'Bothell', '98011'),
    (@StateID, @BusinessID, '112 Pine Ln', NULL, 'Bothell', '98011'),
    (@StateID, @BillingID, '113 Birch St', 'Suite 301', 'Bothell', '98011'),
    (@StateID, @HomeID, '114 Cedar Dr', NULL, 'Bothell', '98011'),
    (@StateID, @BusinessID, '115 Spruce Ct', NULL, 'Bothell', '98011'),
    (@StateID, @BillingID, '116 Fir Rd', NULL, 'Bothell', '98011'),
    (@StateID, @HomeID, '117 Redwood Pl', NULL, 'Bothell', '98011'),
    (@StateID, @BusinessID, '118 Sequoia Blvd', NULL, 'Bothell', '98011'),
    (@StateID, @BillingID, '119 Palm Way', NULL, 'Redmond', '98052'),
    (@StateID, @HomeID, '120 Elm St', NULL, 'Redmond', '98052'),
    (@StateID, @BusinessID, '121 Ash Ln', NULL, 'Redmond', '98052'),
    (@StateID, @BillingID, '122 Maple St', NULL, 'Redmond', '98052'),
    (@StateID, @HomeID, '123 Oak Ave', 'Apt 4', 'Redmond', '98052'),
    (@StateID, @BusinessID, '124 Pine Ln', NULL, 'Redmond', '98052'),
    (@StateID, @BillingID, '125 Birch St', 'Suite 302', 'Redmond', '98052'),
    (@StateID, @HomeID, '126 Cedar Dr', NULL, 'Redmond', '98052'),
    (@StateID, @BusinessID, '127 Spruce Ct', NULL, 'Redmond', '98052'),
    (@StateID, @BillingID, '128 Fir Rd', NULL, 'Kirkland', '98033'),
    (@StateID, @HomeID, '129 Redwood Pl', NULL, 'Kirkland', '98033'),
    (@StateID, @BusinessID, '130 Sequoia Blvd', NULL, 'Kirkland', '98033'),
    (@StateID, @BillingID, '131 Palm Way', NULL, 'Kirkland', '98033'),
    (@StateID, @HomeID, '132 Elm St', NULL, 'Kirkland', '98033'),
    (@StateID, @BusinessID, '133 Ash Ln', NULL, 'Kirkland', '98033'),
    (@StateID, @BillingID, '134 Maple St', NULL, 'Snohomish', '98290'),
    (@StateID, @HomeID, '135 Oak Ave', 'Apt 5', 'Snohomish', '98290'),
    (@StateID, @BusinessID, '136 Pine Ln', NULL, 'Snohomish', '98290'),
    (@StateID, @BillingID, '137 Birch St', 'Suite 303', 'Snohomish', '98290'),
    (@StateID, @HomeID, '138 Cedar Dr', NULL, 'Snohomish', '98290'),
    (@StateID, @BusinessID, '139 Spruce Ct', NULL, 'Snohomish', '98290'),
    (@StateID, @BillingID, '140 Fir Rd', NULL, 'Snohomish', '98290'),
    (@StateID, @HomeID, '141 Redwood Pl', NULL, 'Snohomish', '98290'),
    (@StateID, @BusinessID, '142 Sequoia Blvd', NULL, 'Snohomish', '98290');
GO

INSERT INTO dbo.CUSTOMER (FName, LName, Email)
VALUES
    ('John', 'Doe', 'john.doe@example.com'),
    ('Jane', 'Smith', 'jane.smith@example.com'),
    ('Michael', 'Johnson', 'michael.johnson@example.com'),
    ('Emily', 'Williams', 'emily.williams@example.com'),
    ('Daniel', 'Brown', 'daniel.brown@example.com'),
    ('Sophia', 'Jones', 'sophia.jones@example.com'),
    ('David', 'Garcia', 'david.garcia@example.com'),
    ('Emma', 'Martinez', 'emma.martinez@example.com'),
    ('James', 'Rodriguez', 'james.rodriguez@example.com'),
    ('Olivia', 'Hernandez', 'olivia.hernandez@example.com'),
    ('Robert', 'Lopez', 'robert.lopez@example.com'),
    ('Isabella', 'Gonzalez', 'isabella.gonzalez@example.com'),
    ('William', 'Wilson', 'william.wilson@example.com'),
    ('Mia', 'Anderson', 'mia.anderson@example.com'),
    ('Charles', 'Thomas', 'charles.thomas@example.com'),
    ('Ava', 'Taylor', 'ava.taylor@example.com'),
    ('Joseph', 'Moore', 'joseph.moore@example.com'),
    ('Sophia', 'Martin', 'sophia.martin@example.com'),
    ('George', 'Lee', 'george.lee@example.com'),
    ('Charlotte', 'Perez', 'charlotte.perez@example.com'),
    ('Henry', 'White', 'henry.white@example.com'),
    ('Amelia', 'Harris', 'amelia.harris@example.com'),
    ('Richard', 'Clark', 'richard.clark@example.com'),
    ('Evelyn', 'Lewis', 'evelyn.lewis@example.com'),
    ('Thomas', 'Walker', 'thomas.walker@example.com'),
    ('Harper', 'Young', 'harper.young@example.com'),
    ('Christopher', 'Hall', 'christopher.hall@example.com'),
    ('Abigail', 'Allen', 'abigail.allen@example.com'),
    ('Matthew', 'King', 'matthew.king@example.com'),
    ('Elizabeth', 'Wright', 'elizabeth.wright@example.com'),
    ('Anthony', 'Scott', 'anthony.scott@example.com'),
    ('Sofia', 'Green', 'sofia.green@example.com'),
    ('Mark', 'Adams', 'mark.adams@example.com'),
    ('Avery', 'Baker', 'avery.baker@example.com'),
    ('Andrew', 'Gonzalez', 'andrew.gonzalez@example.com'),
    ('Ella', 'Nelson', 'ella.nelson@example.com'),
    ('Joshua', 'Carter', 'joshua.carter@example.com'),
    ('Scarlett', 'Mitchell', 'scarlett.mitchell@example.com'),
    ('Ethan', 'Perez', 'ethan.perez@example.com'),
    ('Grace', 'Roberts', 'grace.roberts@example.com'),
    ('Benjamin', 'Turner', 'benjamin.turner@example.com'),
    ('Lily', 'Phillips', 'lily.phillips@example.com'),
    ('Jacob', 'Campbell', 'jacob.campbell@example.com'),
    ('Hannah', 'Parker', 'hannah.parker@example.com'),
    ('William', 'Evans', 'william.evans@example.com'),
    ('Samantha', 'Edwards', 'samantha.edwards@example.com'),
    ('Michael', 'Collins', 'michael.collins@example.com'),
    ('Ariana', 'Stewart', 'ariana.stewart@example.com'),
    ('James', 'Sanchez', 'james.sanchez@example.com'),
    ('Mila', 'Morris', 'mila.morris@example.com');
GO


INSERT INTO dbo.PHONE_NUM (CustID, Num)
VALUES
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'John' AND LName = 'Doe'), '1234567890'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Jane' AND LName = 'Smith'), '2345678901'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Michael' AND LName = 'Johnson'), '3456789012'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Emily' AND LName = 'Williams'), '4567890123'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Daniel' AND LName = 'Brown'), '5678901234'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Sophia' AND LName = 'Jones'), '6789012345'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'David' AND LName = 'Garcia'), '7890123456'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Emma' AND LName = 'Martinez'), '8901234567'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'James' AND LName = 'Rodriguez'), '9012345678'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Olivia' AND LName = 'Hernandez'), '0123456789'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Robert' AND LName = 'Lopez'), '1235678901'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Isabella' AND LName = 'Gonzalez'), '2346789012'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'William' AND LName = 'Wilson'), '3457890123'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Mia' AND LName = 'Anderson'), '4568901234'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Charles' AND LName = 'Thomas'), '5679012345'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Ava' AND LName = 'Taylor'), '6780123456'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Joseph' AND LName = 'Moore'), '7891234567'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Sophia' AND LName = 'Martin'), '8902345678'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'George' AND LName = 'Lee'), '9013456789'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Charlotte' AND LName = 'Perez'), '0124567890'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Henry' AND LName = 'White'), '123678 9012'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Amelia' AND LName = 'Harris'), '2347890123'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Richard' AND LName = 'Clark'), '3458901234'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Evelyn' AND LName = 'Lewis'), '4569012345'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Thomas' AND LName = 'Walker'), '5670123456'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Harper' AND LName = 'Young'), '6781234567'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Christopher' AND LName = 'Hall'), '7892345678'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Abigail' AND LName = 'Allen'), '8903456789'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Matthew' AND LName = 'King'), '9014567890'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Elizabeth' AND LName = 'Wright'), '0125678901'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Anthony' AND LName = 'Scott'), '1237890123'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Sofia' AND LName = 'Green'), '2348901234'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Mark' AND LName = 'Adams'), '3459012345'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Avery' AND LName = 'Baker'), '4560123456'),
    ((SELECT CustID FROM dbo.CUSTOMER WHERE FName = 'Andrew' AND LName = 'Gonzalez'), '5671234567');
GO

INSERT INTO dbo.CUSTOMER_ADDRESS (AddressID, CustID)
SELECT
    a.AddressID,
    c.CustID
FROM
    (SELECT TOP 10 AddressID FROM dbo.ADDRESS ORDER BY NEWID()) a,
    (SELECT TOP 10 CustID FROM dbo.CUSTOMER ORDER BY NEWID()) c;


INSERT INTO dbo.BREED (BreedName)
VALUES
    ('Labrador Retriever'),
    ('German Shepherd'),
    ('Golden Retriever'),
    ('Bulldog'),
    ('Beagle'),
    ('Poodle'),
    ('Rottweiler'),
    ('Yorkshire Terrier'),
    ('Boxer'),
    ('Dachshund'),
	('Shih Tzu'),
    ('Siberian Husky'),
    ('Chihuahua'),
    ('Doberman Pinscher'),
    ('Great Dane'),
    ('Australian Shepherd'),
    ('Border Collie'),
    ('Basset Hound'),
    ('Shetland Sheepdog'),
    ('Cocker Spaniel'),
	('Mixed-Breed');
GO

INSERT INTO dbo.SEX (SexAbrv, SexName)
VALUES
	('M', 'Male'),
	('F', 'Female'),
	('N', 'Neutered'),
	('S', 'Spayed');
GO

DECLARE @Male int = (SELECT SexID FROM SEX WHERE SexAbrv = 'M');
DECLARE @Female int = (SELECT SexID FROM SEX WHERE SexAbrv = 'F');
DECLARE @Spayed int = (SELECT SexID FROM SEX WHERE SexAbrv = 'S');
DECLARE @Neutered int = (SELECT SexID FROM SEX WHERE SexAbrv = 'N');

INSERT INTO dbo.DOG_HISTORY (BreedID, CustID, SexID, Age, [Name], Nickname, [Weight], Color, Vet, Notes)
VALUES
    ((SELECT BreedID FROM BREED WHERE BreedName = 'Golden Retriever'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '7 years', 'Buddy', 'Bud', 65.2, 'Golden', 'Pawsitive Pet Care', 'Healthy dog, very playful'),
    ((SELECT BreedID FROM BREED WHERE BreedName = 'Doberman Pinscher'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '5 years', 'Max', NULL, 75, 'Black and Tan', 'VetVantage', 'Had a leg injury'),
	((SELECT TOP 1 BreedID FROM dbo.BREED ORDER BY NEWID()), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Spayed, '5 months', 'Bella', NULL, 30.2, 'Brown', 'Vet2', 'Has allergies'),
	((SELECT TOP 1 BreedID FROM dbo.BREED ORDER BY NEWID()), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '3 years', 'Charlie', NULL, 2.4, 'Apricot', 'Vet Paradise', NULL),
	((SELECT TOP 1 BreedID FROM dbo.BREED ORDER BY NEWID()), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Spayed, '8 years', 'Lucy', NULL, 25.6, 'White', 'I am a vet', 'Goofy'),
	((SELECT TOP 1 BreedID FROM dbo.BREED ORDER BY NEWID()), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '6 months', 'Baily', NULL, 12.3, 'Brindle', 'abc vet', 'Surgery in 2019'),
	((SELECT TOP 1 BreedID FROM dbo.BREED ORDER BY NEWID()), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Spayed, '12 years', 'Daisy', NULL, 36.2, 'Tan', '123 Vet', 'Tripod'),
	((SELECT TOP 1 BreedID FROM dbo.BREED ORDER BY NEWID()), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '2 years', 'Boeing', 'Bo', 54.1, 'Black', 'Vet for dogs', 'Matted fur'),
	((SELECT TOP 1 BreedID FROM dbo.BREED ORDER BY NEWID()), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '10 months', 'Karluchio', 'Karl', 20.0, 'Cream', 'Exotic animal vet', 'Likes cheese'),
	((SELECT TOP 1 BreedID FROM dbo.BREED ORDER BY NEWID()), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '9 years', 'Tiki', NULL, 50.8, 'Brindle and white', 'The best vet', 'Bad allergies');
GO


INSERT INTO dbo.MED_TYPE (MedTypename, Color)
VALUES
	('Food', 'Red'),
	('Lead', 'Green'),
	('Manager', 'Pink')
GO

DECLARE @Food int = (SELECT MedTypeID FROM MED_TYPE WHERE MedTYpeName = 'Food');
DECLARE @Lead int = (SELECT MedTypeID FROM MED_TYPE WHERE MedTYpeName = 'Lead');
DECLARE @Manager int = (SELECT MedTypeID FROM MED_TYPE WHERE MedTYpeName = 'Manager');

INSERT INTO dbo.MEDICATION (MedTypeID, MedName)
VALUES
	(@Food, 'Fish Oil'),
	(@Food, 'Cosequin'),
	(@Food, 'Fortiflora'),
	(@Food, 'Pumpkin Powder'),
	(@Food, 'Probiotic'),
	(@Food, 'Joint chew'),
	(@Food, 'Vitamin'),
	(@Lead, 'Amoxicillin'),
	(@Lead, 'Carprofen'),
	(@Lead, 'Benadryl'),
	(@Lead, 'Ear Wash'),
	(@Lead, 'Eye Drops'),
	(@Lead, 'Zyrtec'),
	(@Lead, 'Atopica'),
	(@Lead, 'Apoquel'),
	(@Lead, 'Cephalexin'),
	(@Lead, 'Diphenhydramine'),
	(@Lead, 'Metronidazole'),
	(@Lead, 'Deracoxib'),
	(@Lead, 'Doxepin'),
	(@Manager, 'Benazepril'),
	(@Manager, 'Alprazolam'),
	(@Manager, 'Gabapentin'),
	(@Manager, 'Diazepam'),
	(@Manager, 'Hydroxyzine'),
	(@Manager, 'Levetiracetam'),
	(@Manager, 'Levothyroxine'),
	(@Manager, 'Mirtazapine'),
	(@Manager, 'Phenylpropanolamine '),
	(@Manager, 'Predinsone'),
	(@Manager, 'Tramadol');
GO

INSERT INTO BUILDING (BuildingName, BuildingDescr)
VALUES
	('A', 'A building to house dogs, has guillatine doors to let dogs outside. Has 4ft x 6ft covered and uncovered kennels. Has tall guillatine doors in some kennels. Used to house aggressive/no contact dogs, has small suites'),
	('B', 'A building to house dogs, has guillatine doors to let dogs outside. Has 4ft x 6ft covered and uncovered kennels. Has tall guillatine doors in some kennels. Used to house aggressive/no contact dogs, has small suites'),
	('D', 'A building to house dogs, has guillatine doors to let dogs outside. Has only 4ft x 12ft uncovered kennels. Has tall guillatine doors in all kennels. Mainly used to house large dogs. has large suites'),
	('E', 'A building to house dogs, has indoor kennels and separate outdoor kennels. Has covered 4ft x 4ft kennels some of which are stacked on each other, and uncovered 4ft x 8ft kennels. Mainly used to house small dogs');
GO

INSERT INTO RUN_TYPE (RunTypeName, RunTypeAbrv)
VALUES
	('Covered', 'C'),
	('Tall', 'T'),
	('Suite', 'S'),
	('Upper', 'U'),
	('Lower', 'L');
GO

DECLARE @A int = (SELECT BuildingID FROM BUILDING WHERE BuildingName = 'A');
DECLARE @B int = (SELECT BuildingID FROM BUILDING WHERE BuildingName = 'B');
DECLARE @D int = (SELECT BuildingID FROM BUILDING WHERE BuildingName = 'D');
DECLARE @E int = (SELECT BuildingID FROM BUILDING WHERE BuildingName = 'E');

DECLARE @C int = (SELECT RunTypeID FROM RUN_TYPE WHERE RunTypeAbrv = 'C');
DECLARE @T int = (SELECT RunTypeID FROM RUN_TYPE WHERE RunTypeAbrv = 'T');
DECLARE @S int = (SELECT RunTypeID FROM RUN_TYPE WHERE RunTypeAbrv = 'S');
DECLARE @U int = (SELECT RunTypeID FROM RUN_TYPE WHERE RunTypeAbrv = 'U');
DECLARE @L int = (SELECT RunTypeID FROM RUN_TYPE WHERE RunTypeAbrv = 'L');

INSERT INTO RUN (BuildingID, RunTypeID, RunNumber)
VALUES
	(@A, @C, 'AC1'),
	(@A, @C, 'AC2'),
	(@A, @C, 'AC3'),
	(@A, @C, 'AC4'),
	(@A, @C, 'AC5'),
	(@A, @T, 'AT6'),
	(@A, @T, 'AT7'),
	(@A, @T, 'AT8'),
	(@A, NULL, 'A9'),
	(@A, NULL, 'A10'),
	(@A, NULL, 'A11'),
	(@A, NULL, 'A12'),
	(@A, NULL, 'A13'),
	(@A, NULL, 'A14'),
	(@A, NULL, 'A15'),
	(@A, NULL, 'A16'),
	(@A, NULL, 'A17'),
	(@A, NULL, 'A18'),
	(@A, NULL, 'A19'),
	(@A, NULL, 'A20'),
	(@A, NULL, 'A21'),
	(@A, NULL, 'A22'),
	(@A, NULL, 'AS23'),
	(@A, NULL, 'AS24'),
	(@A, NULL, 'AS25'),
	(@B, @C, 'BC1'),
	(@B, @C, 'BC2'),
	(@B, @C, 'BC3'),
	(@B, @C, 'BC4'),
	(@B, @C, 'BC5'),
	(@B, @T, 'BT6'),
	(@B, @T, 'BT7'),
	(@B, @T, 'BT8'),
	(@B, NULL, 'B9'),
	(@B, NULL, 'B10'),
	(@B, NULL, 'B11'),
	(@B, NULL, 'B12'),
	(@B, NULL, 'B13'),
	(@B, NULL, 'B14'),
	(@B, NULL, 'B15'),
	(@B, NULL, 'B16'),
	(@B, NULL, 'B17'),
	(@B, NULL, 'B18'),
	(@B, NULL, 'B19'),
	(@B, NULL, 'B20'),
	(@B, NULL, 'B21'),
	(@B, NULL, 'B22'),
	(@B, @S, 'BS23'),
	(@B, @S, 'BS24'),
	(@B, @S, 'BS25'),
	(@D, @S, 'DS1'),
	(@D, @S, 'DS2'),
	(@D, @S, 'DS3'),
	(@D, @S, 'DS4'),
	(@D, @S, 'DS5'),
	(@D, @S, 'DS6'),
	(@D, @S, 'DS7'),
	(@D, @S, 'DS8'),
	(@D, @S, 'DS9'),
	(@D, @S, 'DS10'),
	(@D, NULL, 'D1'),
	(@D, NULL, 'D2'),
	(@D, NULL, 'D3'),
	(@D, NULL, 'D4'),
	(@D, NULL, 'D5'),
	(@D, NULL, 'D6'),
	(@D, NULL, 'D7'),
	(@D, NULL, 'D8'),
	(@D, NULL, 'D9'),
	(@D, NULL, 'D10'),
	(@D, NULL, 'D11'),
	(@D, NULL, 'D12'),
	(@D, NULL, 'D13'),
	(@D, NULL, 'D14'),
	(@D, NULL, 'D15'),
	(@D, NULL, 'D16'),
	(@D, NULL, 'D17'),
	(@D, NULL, 'D18'),
	(@D, NULL, 'D19'),
	(@D, NULL, 'D20'),
	(@D, NULL, 'D21'),
	(@D, NULL, 'D22'),
	(@D, NULL, 'D23'),
	(@D, NULL, 'D24'),
	(@D, NULL, 'D25'),
	(@D, NULL, 'D26'),
	(@D, NULL, 'D27'),
	(@D, NULL, 'D28'),
	(@D, NULL, 'D29'),
	(@D, NULL, 'D30'),
	(@D, NULL, 'D31'),
	(@D, NULL, 'D32'),
	(@D, NULL, 'D33'),
	(@D, NULL, 'D34'),
	(@D, NULL, 'D35'),
	(@D, NULL, 'D36'),
	(@D, NULL, 'D37'),
	(@D, NULL, 'D38'),
	(@D, NULL, 'D39'),
	(@D, NULL, 'D40'),
	(@E, NULL, 'E1'),
	(@E, NULL, 'E2'),
	(@E, NULL, 'E3'),
	(@E, NULL, 'E4'),
	(@E, NULL, 'E5'),
	(@E, NULL, 'E6'),
	(@E, NULL, 'E7'),
	(@E, NULL, 'E8'),
	(@E, NULL, 'E9'),
	(@E, NULL, 'E10'),
	(@E, NULL, 'E11'),
	(@E, NULL, 'E12'),
	(@E, NULL, 'E13'),
	(@E, NULL, 'E14'),
	(@E, NULL, 'E15'),
	(@E, NULL, 'E16'),
	(@E, NULL, 'E17'),
	(@E, NULL, 'E18'),
	(@E, NULL, 'E19'),
	(@E, NULL, 'E20'),
	(@E, NULL, 'E21'),
	(@E, NULL, 'E22'),
	(@E, NULL, 'E23'),
	(@E, NULL, 'E24'),
	(@E, NULL, 'E25'),
	(@E, NULL, 'E26'),
	(@E, NULL, 'E27'),
	(@E, NULL, 'E28'),
	(@E, NULL, 'E29'),
	(@E, NULL, 'E30'),
	(@E, NULL, 'E31'),
	(@E, NULL, 'E32'),
	(@E, NULL, 'E33'),
	(@E, NULL, 'E34'),
	(@E, NULL, 'E35'),
	(@E, NULL, 'E36'),
	(@E, NULL, 'E37'),
	(@E, NULL, 'E38'),
	(@E, NULL, 'E39'),
	(@E, NULL, 'E40'),
	(@E, NULL, 'E41'),
	(@E, NULL, 'E42'),
	(@E, NULL, 'E43'),
	(@E, NULL, 'E44'),
	(@E, NULL, 'E45'),
	(@E, NULL, 'E46'),
	(@E, NULL, 'E47'),
	(@E, NULL, 'E48'),
	(@E, @U, 'EU49'),
	(@E, @U, 'EU50'),
	(@E, @U, 'EU51'),
	(@E, @U, 'EU52'),
	(@E, @U, 'EU53'),
	(@E, @U, 'EU54'),
	(@E, @U, 'EU55'),
	(@E, @L, 'EL56'),
	(@E, @L, 'EL57'),
	(@E, @L, 'EL58'),
	(@E, @L, 'EL59'),
	(@E, @L, 'EL60'),
	(@E, @L, 'EL61'),
	(@E, @L, 'EL62'),
	(@E, @U, 'EU63'),
	(@E, @U, 'EU64'),
	(@E, @U, 'EU65'),
	(@E, @U, 'EU66'),
	(@E, @U, 'EU67'),
	(@E, @U, 'EU68'),
	(@E, @U, 'EU69'),
	(@E, @L, 'EL70'),
	(@E, @L, 'EL71'),
	(@E, @L, 'EL72'),
	(@E, @L, 'EL73'),
	(@E, @L, 'EL74'),
	(@E, @L, 'EL75'),
	(@E, @L, 'EL76'),
	(@E, @L, 'EL77'),
	(@E, @L, 'EL78')
GO

INSERT INTO TAG (TagDescr)
VALUES
	('Approach with caution'),
	('Feed separate'),
	('No stuffed bedding'),
	('Food aggressive'),
	('No bedding'),
	('No hammock'),
	('Resource guarder'),
	('Old, go slow'),
	('Fear biter'),
	('Nothing but own food/treats'),
	('Escape artist'),
	('Bolter'),
	('Fence climber'),
	('Stool eater'),
	('No rugs, rubs nose'),
	('Own bedding only'),
	('Do not wash my bedding'),
	('Do not enter'),
	('People aggressive'),
	('Chewer'),
	('Nothing around neck, medical'),
	('Extra potty walks'),
	('Picky eater')
GO

INSERT INTO VACCINATION (VaxName)
VALUES
	('DHPP'),
	('Bordetella'),
	('Rabies'),
	('Parvo Virus')
GO

DECLARE @Male int = (SELECT SexID FROM SEX WHERE SexAbrv = 'M');
DECLARE @Female int = (SELECT SexID FROM SEX WHERE SexAbrv = 'F');
DECLARE @Spayed int = (SELECT SexID FROM SEX WHERE SexAbrv = 'S');
DECLARE @Neutered int = (SELECT SexID FROM SEX WHERE SexAbrv = 'N');

INSERT INTO DOG (BreedID, CustID, SexID, Age, [Name], Nickname, [Weight], Color, Vet, Notes)
VALUES
	((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Labrador Retriever'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '3 years', 'Max', NULL, 70.5, 'Yellow', 'Happy Paws Veterinary Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'German Shepherd'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '2 years', 'Bella', NULL, 65.2, 'Black and Tan', 'Healthy Tails Animal Hospital', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Golden Retriever'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Spayed, '5 years', 'Lucy', NULL, 68.0, 'Golden', 'Pet Haven Vet Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Bulldog'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '4 years', 'Rocky', NULL, 50.0, 'Brindle', 'Pawfect Care Veterinary', 'Snorts a lot, has hip dysplasia'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Beagle'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '17 year', 'Daisy', NULL, 25.3, 'Tri-color', 'Best Friends Animal Clinic', 'Very old, go slow!'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Poodle'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '6 years', 'Charlie', NULL, 45.0, 'White', 'Happy Tails Veterinary Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Rottweiler'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '3 years', 'Thor', NULL, 95.0, 'Black and Tan', 'Guardian Vet Care', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Yorkshire Terrier'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '2 years', 'Molly', NULL, 7.5, 'Blue and Tan', 'Tiny Paws Veterinary', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Boxer'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '15 years', 'Buddy', 'Bud', 65.0, 'Fawn', 'Barks and Meows Animal Hospital', 'Has dementia, will pace in circles'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Dachshund'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '3 years', 'Sadie', NULL, 15.0, 'Red', 'Long Body Vet Clinic', 'Has back issues'),
	((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Shih Tzu'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '4 years', 'Ginger', NULL, 12.0, 'White and Brown', 'Shiny Paws Veterinary Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Siberian Husky'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '2 years', 'Blaze', NULL, 50.0, 'Black and White', 'North Pole Vet Care', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Chihuahua'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '3 years', 'Coco', NULL, 5.0, 'Tan', 'Small Paws Veterinary', 'Reverse Sneezer'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Doberman Pinscher'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '4 years', 'Zeus', NULL, 90.0, 'Black and Tan', 'Guardian Angels Vet Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Great Dane'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '5 years', 'Athena', NULL, 120.0, 'Harlequin', 'Big Paws Veterinary Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Australian Shepherd'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '3 years', 'Cooper', NULL, 50.0, 'Blue Merle', 'Herding Vet Care', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Border Collie'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '2 years', 'Luna', NULL, 40.0, 'Black and White', 'Agility Vet Clinic', 'Might not eat the first few days'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Basset Hound'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '6 years', 'Winston', 'Winnie', 55.0, 'Tri-color', 'Droopy Paws Veterinary', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Shetland Sheepdog'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '5 years', 'Misty', NULL, 25.0, 'Sable', 'Sheltie Vet Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Cocker Spaniel'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Spayed, '4 years', 'Lily', NULL, 30.0, 'Golden', 'Floppy Ears Veterinary', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Mixed-Breed'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '2 years', 'Rex', NULL, 45.0, 'Black and White', 'Mixed Breed Vet Care', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Labrador Retriever'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '1 year', 'Jake', NULL, 60.0, 'Chocolate', 'Happy Paws Veterinary Clinic', 'Only use hypo shampoo'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'German Shepherd'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '7 years', 'Roxy', NULL, 70.0, 'Black and Tan', 'Healthy Tails Animal Hospital', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Golden Retriever'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Spayed, '6 years', 'Maggie', NULL, 65.0, 'Golden', 'Pet Haven Vet Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Bulldog'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '2 years', 'Tank', NULL, 55.0, 'White and Brindle', 'Pawfect Care Veterinary', 'Snorts a lot, very strong'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Beagle'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '3 years', 'Bailey', NULL, 22.0, 'Tri-color', 'Best Friends Animal Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Poodle'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '8 years', 'Oscar', NULL, 50.0, 'Black', 'Happy Tails Veterinary Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Rottweiler'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '5 years', 'Duke', NULL, 100.0, 'Black and Tan', 'Guardian Vet Care', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Yorkshire Terrier'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '4 years', 'Bella', NULL, 8.0, 'Blue and Tan', 'Tiny Paws Veterinary', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Boxer'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '3 years', 'Rocky', NULL, 70.0, 'Brindle', 'Barks and Meows Animal Hospital', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Dachshund'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '2 years', 'Penny', NULL, 12.0, 'Black and Tan', 'Long Body Vet Clinic', 'Pulls hard on leash'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Shih Tzu'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '5 years', 'Sophie', NULL, 13.0, 'White and Gold', 'Shiny Paws Veterinary Clinic', 'Has 3 legs'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Siberian Husky'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '4 years', 'Shadow', NULL, 55.0, 'Grey and White', 'North Pole Vet Care', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Chihuahua'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '6 years', 'Zoe', NULL, 6.0, 'Brown', 'Small Paws Veterinary', 'Poultry Allergy, Approach w/ Caution Will bite! Very Protective of space'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Doberman Pinscher'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '3 years', 'Bruno', NULL, 88.0, 'Black and Tan', 'Guardian Angels Vet Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Great Dane'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '4 years', 'Nala', NULL, 125.0, 'Black', 'Big Paws Veterinary Clinic', NULL),
	((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Australian Shepherd'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Neutered, '2 years', 'Finn', NULL, 52.0, 'Red Merle', 'Herding Vet Care', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Border Collie'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '1 year', 'Riley', NULL, 38.0, 'Black and White', 'Agility Vet Clinic', NULL),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Basset Hound'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Male, '7 years', 'Oliver', NULL, 57.0, 'Tri-color', 'Droopy Paws Veterinary', 'Has GI issues, regular to have SS/D'),
    ((SELECT BreedID FROM dbo.BREED WHERE BreedName = 'Shetland Sheepdog'), (SELECT TOP 1 CustID FROM dbo.CUSTOMER ORDER BY NEWID()), @Female, '6 years', 'Ellie', NULL, 26.0, 'Tri-color', 'Sheltie Vet Clinic', NULL);
GO

INSERT INTO VISIT_STATUS (VisitStatus)
VALUES
	('Scheduled to board'),
	('Departed')
GO

INSERT INTO dbo.DOG_MED (MedID, DogID, Dose, Notes)
VALUES
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Fish Oil'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 capsule on PM meal', 'open on food'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Cosequin'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 tab AM/PM', 'use hd or pill pockets'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Fortiflora'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 packet on AM meal', 'mix with food'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Pumpkin Powder'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 tsp on meal AM/PM', 'mix with food'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Probiotic'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 capsule with AM meal', 'open and sprinkle on food'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Joint chew'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 chew daily in PM', NULL),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Vitamin'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 tablet on AM meal', NULL),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Amoxicillin'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 tablet AM/PM', 'use hd, might need to handpill'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Carprofen'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 tablet AM', 'use pill pockets'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Benadryl'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1/2 tablet AM?PM', 'in pb'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Ear Wash'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), 'PM', 'apply directly to ears'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Gabapentin'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 capsule AM/NOON/PM', 'in can food'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Diazepam'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 tablet as needed', 'in string cheese'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Phenylpropanolamine'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 tablet NOON', 'use pb or pill pockets'),
    ((SELECT MedID FROM MEDICATION WHERE MedName = 'Tramadol'), (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), '1 tablet AM/PM', 'use hd or pill pockets');
GO


INSERT INTO DOG_TAG (DogID, TagID)
VALUES
	(5, 8),
	(17, 23),
	(34, 1),
	(34, 9),
	(39, 10)
GO

INSERT INTO DOG_TAG (DogID, TagID)
SELECT
    (SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()),
    (SELECT TOP 1 TagID FROM TAG ORDER BY NEWID())
FROM
    (SELECT TOP 10 * FROM DOG) AS d
CROSS JOIN
    (SELECT TOP 10 * FROM TAG) AS t;
GO

DECLARE @DHPP INT = (SELECT VaxID FROM VACCINATION WHERE VaxName = 'DHPP');
DECLARE @Bordetella INT = (SELECT VaxID FROM VACCINATION WHERE VaxName = 'Bordetella');
DECLARE @Rabies INT = (SELECT VaxID FROM VACCINATION WHERE VaxName = 'Rabies');
DECLARE @ParvoVirus INT = (SELECT VaxID FROM VACCINATION WHERE VaxName = 'Parvo Virus');

DECLARE @CurrentDate DATE = '2024-06-12';
DECLARE @SixMonthsAgo DATE = DATEADD(MONTH, -6, @CurrentDate);
DECLARE @ThreeYearsAgo DATE = DATEADD(YEAR, -3, @CurrentDate);

INSERT INTO DOG_VAX (DogID, VaxID, VaxDate)
SELECT DogID, @DHPP, DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1095), @CurrentDate) FROM DOG
UNION ALL
SELECT DogID, @Bordetella, DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 180), @CurrentDate) FROM DOG
UNION ALL
SELECT DogID, @Rabies, DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1095), @CurrentDate) FROM DOG
UNION ALL
SELECT DogID, @ParvoVirus, DATEADD(DAY, -ABS(CHECKSUM(NEWID()) % 1095), @CurrentDate) FROM DOG;
GO


DECLARE @Bedding INT = (SELECT BelongingTypeID FROM BELONGING_TYPE WHERE BelongingTypeName = 'Bedding');
DECLARE @Toy INT = (SELECT BelongingTypeID FROM BELONGING_TYPE WHERE BelongingTypeName = 'Toy');
DECLARE @Food INT = (SELECT BelongingTypeID FROM BELONGING_TYPE WHERE BelongingTypeName = 'Food');
DECLARE @Container INT = (SELECT BelongingTypeID FROM BELONGING_TYPE WHERE BelongingTypeName = 'Container');
DECLARE @Medication INT = (SELECT BelongingTypeID FROM BELONGING_TYPE WHERE BelongingTypeName = 'Medication');
DECLARE @Clothing INT = (SELECT BelongingTypeID FROM BELONGING_TYPE WHERE BelongingTypeName = 'Clothing');
DECLARE @Restraints INT = (SELECT BelongingTypeID FROM BELONGING_TYPE WHERE BelongingTypeName = 'Restraints');
DECLARE @Crate INT = (SELECT BelongingTypeID FROM BELONGING_TYPE WHERE BelongingTypeName = 'Crate');
DECLARE @Other INT = (SELECT BelongingTypeID FROM BELONGING_TYPE WHERE BelongingTypeName = 'Other');

INSERT INTO BELONGING (DogID, BelongingTypeID, BelongingDescr)
VALUES
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Bedding, 'Green blanket with white bones'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Bedding, 'Grey fuzzy donut bed'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Bedding, 'Black create mat'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Bedding, 'Pink bolster bed'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Bedding, 'Red and blue beach towel'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Toy, 'Lamb Chop'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Toy, 'Unstuffed snake toy'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Toy, 'Y-benebone'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Container, 'Plastic fridge tupperware'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Container, 'Trader joes reusable bag'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Container, 'Large plastic food container with red scoop'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Clothing, 'Puffy red rain jacket'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Restraints, 'C/H/L'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Restraints, 'C/L'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Restraints, 'H/L'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Crate, 'Metal crate'),
	((SELECT TOP 1 DogID FROM DOG ORDER BY NEWID()), @Crate, 'Plastic crate')
GO