
USE master
GO

-- Drop the database if it already exists
IF  EXISTS (
	SELECT name 
		FROM sys.databases 
		WHERE name = N'KenKennel'
)
DROP DATABASE KenKennel
GO

CREATE DATABASE KenKennel
GO




USE KenKennel
GO
-- Drop tables in referential order if exists
DROP TABLE IF EXISTS
DOG_HISTORY,
DOG_MED,
DOG_VAX,
DOG_TAG,
MEDICATION,
ACTIVITY_VISIT,
VISIT,
RUN,
ACTIVITY,
BELONGING,
DOG,
CUSTOMER_PAYMENT,
CUSTOMER_ADDRESS,
CUSTOMER,
PAYMENT,
[ADDRESS],
RUN_TYPE,
BUILDING,
ACTIVITY_TYPE,
BELONGING_TYPE,
VISIT_STATUS,
VACCINATION,
TAG,
SEX,
BREED,
MED_TYPE,
PHONE_NUM,
ADDRESS_TYPE,
[STATE]
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
)
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
)
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
	BuildingDescr varchar(100) NOT NULL,
    CONSTRAINT PK_building PRIMARY KEY (BuildingID)
)
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
)
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
)
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
)
GO

/*
	Table: TAG

	Description: Stores specific tags for dogs regarding things such as behavioral or medical information

	Columns:
	- TagID: unique identifier for each tag
	- TagChar: The abreviated tag
	- TagDescr: Brief description of each tag

	Constraints:
	- TagID: PK
*/
CREATE TABLE dbo.TAG
(
	TagID int IDENTITY NOT NULL, 
	TagChar varchar(3) NOT NULL,
	TagDescr varchar(150) NOT NULL,
    CONSTRAINT PK_tag PRIMARY KEY (TagID)
)
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
)
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
)
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
    CONSTRAINT PK_medType PRIMARY KEY (MedTypeID)
)
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
)
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
CREATE TABLE dbo.STATE
(
	StateID int IDENTITY NOT NULL, 
	StateName varchar(50) NOT NULL,
	StateAbrv char(2) NOT NULL,
    CONSTRAINT PK_state PRIMARY KEY (StateID)
)
GO

/*
	Table: ACTIVITY

	Description: Stores different activities a dog can book

	Columns:
	- ActivityID: unique identifier for each activity
	- ActivityTypeID: id of the type of activity

	Constraints:
	- ActivityID: PK
	- ActivityTypeID: FK referencing ACTIVITY_TYPE
*/
CREATE TABLE dbo.ACTIVITY
(
	ActivityID int IDENTITY NOT NULL, 
	ActivityTypeID int NOT NULL,
    CONSTRAINT PK_activity PRIMARY KEY (ActivityID),
	CONSTRAINT FK_activity_activityType FOREIGN KEY (ActivityTypeID) REFERENCES dbo.ACTIVITY_TYPE (ActivityTypeID)
)
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
    CONSTRAINT PK_run PRIMARY KEY (RunID),
	CONSTRAINT FK_run_building FOREIGN KEY (BuildingID) REFERENCES dbo.BUILDING (BuildingID),
	CONSTRAINT FK_run_runType FOREIGN KEY (RunTypeID) REFERENCES dbo.RUN_TYPE (RunTypeID)
)
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
)
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
)
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
	[Weight] decimal(3,1) NOT NULL,
	Color varchar(25) NULL,
	Vet varchar(25) NULL,
	Notes varchar(100) NULL,
    CONSTRAINT PK_dog PRIMARY KEY (DogID),
	CONSTRAINT FK_dog_breed FOREIGN KEY (BreedID) REFERENCES dbo.BREED (BreedID),
	CONSTRAINT FK_dog_customer FOREIGN KEY (CustID) REFERENCES dbo.CUSTOMER (CustID),
	CONSTRAINT FK_dog_sex FOREIGN KEY (SexID) REFERENCES dbo.SEX (SexID)
)
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
)
GO

/*
	Table: ACTIVITY_VISIT

	Description: Stores each each activity instance for each visit

	Columns:
	- ActivityVisitID: unique identifier for each activity
	- ActivityID: id for the activity that it is
	- VisitID: id for the visit the activity takes place during
	- ActivityDate: Date that the activity takes place on

	Constraints:
	- ActivityVisitID: PK
	- ActivityID: FK referencing ACTIVITY
	- VisitID: FK referencing VISIT
*/
CREATE TABLE dbo.ACTIVITY_VISIT
(
	ActivityVisitID int IDENTITY NOT NULL, 
	ActivityID int NOT NULL,
	VisitID int NOT NULL,
	ActivityDate DATE NOT NULL,
    CONSTRAINT PK_activityVisit PRIMARY KEY (ActivityVisitID),
	CONSTRAINT FK_activityVisit_activity FOREIGN KEY (ActivityID) REFERENCES dbo.ACTIVITY (ActivityID),
	CONSTRAINT FK_activityVisit_visit FOREIGN KEY (VisitID) REFERENCES dbo.VISIT (VisitID)
)
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
)
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
)
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
)
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
CREATE TABLE dbo.ADDRESS
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
)
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
)
GO

/*
    Table: PAYMENT

    Description: Stores information about payments.

    Columns:
    - PaymentID: unique identifier for each payment
    - CardNum: Card number used for the payment
    - CardType: Type of card
    - CardExpDate: Expiration date of the card (YYYYMM format)

    Constraints:
    - PaymentID: PK
*/
CREATE TABLE dbo.PAYMENT
(
    PaymentID int IDENTITY NOT NULL,
    CardNum varchar(20) NOT NULL,
    CardType varchar(20) NULL,
    CardExpDate int NOT NULL,
    CONSTRAINT PK_payment PRIMARY KEY (PaymentID)
)
GO

/*
    Table: CUSTOMER_PAYMENT

    Description: Stores information about payments associated with customers.

    Columns:
    - CustPaymentID: unique identifier for each customer payment
    - PaymentID: ID of the payment
    - CustID: ID of the customer

    Constraints:
    - CustPaymentID: PK
    - PaymentID: FK referencing PAYMENT
    - CustID: FK referencing CUSTOMER
*/
CREATE TABLE dbo.CUSTOMER_PAYMENT
(
    CustPaymentID int IDENTITY NOT NULL,
    PaymentID int NOT NULL,
    CustID int NOT NULL,
    CONSTRAINT PK_customerPayment PRIMARY KEY (CustPaymentID),
    CONSTRAINT FK_customerPayment_payment FOREIGN KEY (PaymentID) REFERENCES dbo.PAYMENT (PaymentID),
    CONSTRAINT FK_customerPayment_customer FOREIGN KEY (CustID) REFERENCES dbo.CUSTOMER (CustID)
)
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
)
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
)
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
    Age int NULL,
    [Name] varchar(50) NOT NULL,
    Nickname varchar(25) NULL,
    [Weight] decimal(3, 1) NOT NULL,
    Color varchar(25) NULL,
    Vet varchar(25) NULL,
    Notes varchar(100) NULL,
	ReasonDeleted varchar(100) NULL
    CONSTRAINT PK_dogHistory PRIMARY KEY (DogHistID),
    CONSTRAINT FK_dogHistory_breed FOREIGN KEY (BreedID) REFERENCES dbo.BREED (BreedID),
    CONSTRAINT FK_dogHistory_customer FOREIGN KEY (CustID) REFERENCES dbo.CUSTOMER (CustID),
	CONSTRAINT FK_dogHistory_sex FOREIGN KEY (SexID) REFERENCES dbo.SEX (SexID)
)
GO
