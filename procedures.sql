/******************************
** File:	procedures.sql
** Desc:	Create stored procedures to add data to KenKennel
** Author:	Kendall Levy
** Date:	6/15/24
**********************
** Change History
**********************
** PR	Date		Author		Description
** 1	6/15/24		Kendall		Created procedure to AddDog and AddCust to database
** 2	6/19/24		Kendall		Updated procedure to AddDog/AddCust to allow more information input. Added AddTag, AddVax, and AddMed
******************************/
use KenKennel;

/*
	Create stored procedure to add a dog to the database.

	Param:
		@Name = name of dog,
		@CustFName = customer's first name,
		@CustLName = customer's last name,
		@BreedName = name of the breed default is mixed breed, 
		@Sex = sex abreviation,
		@Age = age,
		@Nickname = nickname nullable,
		@Weight = weight in lbs,
		@Color = color of dog,
		@Vet = name of vet
		@Notes = any notes on dog, nullable

	Assumptions:
		Customer must already exist
		Breed must already exist
		Dog with the same first name and customer cannot already exist
		Required parameters cannot be null

*/

-- Drop stored procedure if it already exists
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'AddDog' 
)
   DROP PROCEDURE dbo.AddDog
GO

CREATE PROCEDURE dbo.AddDog
	@Name varchar(50),
	@CustFName varchar(50),
	@CustLName varchar(50),
	@BreedName varchar(50) = 'Mixed-Breed',
	@Sex char(1),
	@Age varchar(25),
	@Nickname varchar(25) = NULL,
	@Weight decimal(4, 1),
	@Color varchar(25),
	@Vet varchar(50) = NULL,
	@Notes varchar(150) = NULL

AS
	BEGIN
		-- Check for null or invalid values in required parameters
		IF @CustFName IS NULL OR @CustLName IS NULL OR @Sex IS NULL OR @Age IS NULL OR @Name IS NULL OR @Weight IS NULL OR @Color IS NULL
			BEGIN
				RAISERROR('One or more required parameters are not entered.', 16, 1)
				RETURN
			END
		  -- Check if the dog already exists in the database
		IF EXISTS (
			SELECT 1 FROM DOG
				JOIN CUSTOMER ON DOG.CustID = CUSTOMER.CustID
				WHERE DOG.[Name] = @Name AND CUSTOMER.FName = @CustFName AND CUSTOMER.LName = @CustLName
		)
			BEGIN
					RAISERROR('The dog with the specified name and owner already exists.', 16, 1)
					RETURN
			END

		DECLARE @CustID INT = (SELECT CustID FROM CUSTOMER WHERE CUSTOMER.FName = @CustFName AND CUSTOMER.LName = @CustLName);
		DECLARE @BreedID INT = (SELECT BreedID FROM BREED WHERE BREED.BreedName = @BreedName);
		DECLARE @SexID INT = (SELECT SexID FROM SEX WHERE SEX.SexAbrv = @Sex);

		INSERT INTO DOG (BreedID, CustID, SexID, Age, [Name], Nickname, [Weight], COlor, Vet, Notes)
		VALUES
			(@BreedID, @CustID, @SexID, @Age, @Name, @Nickname, @Weight, @Color, @Vet, @Notes);

	END
GO



/*
	Create stored procedure to add a customer to the database.

	Param:
		@CustFName = customer's first name,
		@CustLName = customer's last name,
		@Email = customer's email can be nullable,
		@Phone = customer's phone number can be nullable,
		@AddrLine1 = first address line of customer,
		@AddrLine2 = second line of address can be nullable,
		@City = city of address,
		@State = State of address,
		@Zip = zip of address

	Assumptions:
		Customer must not already exist
		required params cannot be null
		Phone number can't be associated with a customer already
		Address can't be associated with a customer already

*/
-- Drop stored procedure if it already exists
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'AddCust' 
)
   DROP PROCEDURE dbo.AddCust
GO

CREATE PROCEDURE dbo.AddCust
	@CustFName varchar(50),
	@CustLName varchar(50),
	@Email varchar(100) = NULL,
	@Phone varchar(11) = NULL,
	@AddrLine1 varchar(100),
	@AddrLine2 varchar(100) = NULL,
	@City varchar(50),
	@State char(2),
	@Zip varchar(20)

AS
	BEGIN
		-- Check for null or invalid values in required parameters
		IF @CustFName IS NULL OR @CustLName IS NULL OR @AddrLine1 IS NULL OR @City IS NULL OR @Zip IS NULL
		BEGIN
			RAISERROR('One or more required parameters are not entered.', 16, 1)
			RETURN
		END

		-- Check if the cust already exists in the database
		IF EXISTS (
			SELECT 1 FROM CUSTOMER
				WHERE CUSTOMER.FName = @CustFName AND CUSTOMER.LName = @CustLName
		)
		BEGIN
				RAISERROR('The customer with the specified name already exists.', 16, 1)
				RETURN
		END

		INSERT INTO CUSTOMER (FName, LName, Email)
		VALUES
			(@CustFName, @CustLName, @Email);

		-- Check if the Phone num already exists in the database.
		-- If already exists with CustID NULL, change CustID to new customer,
		-- If already exists with CustID NOT NULL, Raise error
		-- if Doesnt exist, enter new Phone num
		DECLARE @CustID INT = (SELECT CustID FROM CUSTOMER WHERE FName = @CustFName AND LName = @CustLName)

		IF EXISTS (
			SELECT 1 FROM PHONE_NUM
				WHERE PHONE_NUM.Num = @Phone
		)
			BEGIN
					IF (SELECT TOP 1 CustID FROM PHONE_NUM WHERE Num = @Phone) IS NULL
					BEGIN
						UPDATE PHONE_NUM SET CustID = @CustID WHERE Num = @Phone;
					END
					ELSE
					BEGIN
						RAISERROR('The phone number entered already exists.', 16, 1)
						RETURN
					END
			END

		INSERT INTO PHONE_NUM (CustID, Num)
		VALUES
			(@CustID, @Phone);

		-- Check if the Address already exists in the database.
		-- If already exists with CustID NULL, change CustID to new customer,
		-- If already exists with CustID NOT NULL, Raise error
		-- if Doesnt exist, enter new address
		IF EXISTS (
			SELECT 1 FROM [ADDRESS]
				WHERE AddressLine1 = @AddrLine1
				AND City = @City
				AND Zip = @Zip
		)
		BEGIN
				IF (SELECT TOP 1 CustID FROM [ADDRESS] WHERE AddressLine1 = @AddrLine1 AND City = @City AND Zip = @Zip) IS NULL
				BEGIN
					UPDATE [ADDRESS] SET CustID = @CustID WHERE AddressLine1 = @AddrLine1 AND City = @City AND Zip = @Zip;
				END
				ELSE
				BEGIN
					RAISERROR('The address entered already exists.', 16, 1)
					RETURN
				END
		END

		INSERT INTO [ADDRESS] (CustID, StateID, AddressTypeID, AddressLine1, AddressLine2, City, Zip)
		VALUES
			(@CustID, (SELECT StateID FROM [STATE] WHERE StateAbrv = @State), (SELECT AddressTypeID FROM ADDRESS_TYPE WHERE AddressTypeName = 'Home'), @AddrLine1, @AddrLine2, @City, @Zip);

	END
GO


/*
	Create stored procedure to add a tag to a dog

	Param:
		@Name = first name of dog
		@LName = last name of dog
		@TagDescr = tag to associate with dog

	Assumptions:
		Dog must exist
		Tag can't already be assocaited with dog

*/
-- Drop stored procedure if it already exists
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'AddTag' 
)
   DROP PROCEDURE dbo.AddTag
GO


CREATE PROCEDURE dbo.AddTag
	@Name varchar(50),
	@LName varchar(50),
	@TagDescr varchar(50)

AS
	BEGIN
		DECLARE @DogID INT = (SELECT TOP 1 D.DogID FROM DOG D JOIN CUSTOMER C ON C.CustID = D.CustID WHERE D.[Name] = @Name AND C.LName = @LName);
		DECLARE @TagID INT = (SELECT TOP 1 TagID FROM TAG WHERE TagDescr = @TagDescr);

		-- Check for null or invalid values in required parameters
		IF @Name IS NULL OR @LName IS NULL OR @TagDescr IS NULL
		BEGIN
			RAISERROR('One or more required parameters are not entered.', 16, 1)
			RETURN
		END

		-- Check if the dog exists in the database
		IF NOT EXISTS (
			SELECT 1 FROM DOG
				WHERE DogID = @DogID
		)
		BEGIN
				RAISERROR('The dog with the specified name does not exist.', 16, 1)
				RETURN
		END

		-- Check if the tag exists in the database
		IF NOT EXISTS (
			SELECT 1 FROM TAG
				WHERE TagID = @TagID
		)
		BEGIN
				RAISERROR('The tag that was input does not exist.', 16, 1)
				RETURN
		END

		-- Check if the tag is already associated with that dog
		IF EXISTS (
			SELECT 1 FROM DOG_TAG 
				WHERE DogID = @DogID AND TagID = @TagID
		)
		BEGIN
				RAISERROR('The tag is already associated with that dog.', 16, 1)
				RETURN
		END


		INSERT INTO DOG_TAG (DogID, TagID)
		VALUES
			(@DogID, @TagID);


	END
GO

/*
	Create stored procedure to add a vaccine to a dog

	Param:
		@Name = first name of dog
		@LName = last name of dog
		@VaxName = name of the vaccine
		@VaxDate = date the vaccine was given

	Assumptions:
		Dog must exist
		vaccine must already exist
		If vaccine already exists with dog, it will be updated to new date

*/
-- Drop stored procedure if it already exists
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'AddVax' 
)
   DROP PROCEDURE dbo.AddVax
GO


CREATE PROCEDURE dbo.AddVax
	@Name varchar(50),
	@LName varchar(50),
	@VaxName varchar(25),
	@VaxDate date

AS
	BEGIN
		DECLARE @DogID INT = (SELECT D.DogID FROM DOG D JOIN CUSTOMER C ON C.CustID = D.CustID WHERE D.[Name] = @Name AND C.LName = @LName)
		DECLARE @VaxID INT = (SELECT VaxID FROM VACCINATION WHERE VaxName = @VaxName)

		-- Check for null or invalid values in required parameters
		IF @Name IS NULL OR @LName IS NULL OR @VaxName IS NULL OR @VaxDate IS NULL
		BEGIN
			RAISERROR('One or more required parameters are not entered.', 16, 1)
			RETURN
		END

		-- Check if the dog exists in the database
		IF NOT EXISTS (
			SELECT 1 FROM DOG
				WHERE DogID = @DogID
		)
		BEGIN
				RAISERROR('The dog with the specified name does not exist.', 16, 1)
				RETURN
		END

		-- Check if the vaccine exists in the database
		IF NOT EXISTS (
			SELECT 1 FROM VACCINATION
				WHERE VaxID = @VaxID
		)
		BEGIN
				RAISERROR('The vaccination that was input does not exist.', 16, 1)
				RETURN
		END

		-- Check if the vaccine is already associated with that dog, if it is, update date. else create new DOG_VAX entry
		IF EXISTS (
			SELECT 1 FROM DOG_VAX 
				WHERE DogID = @DogID AND VaxID = @VaxID
		)
		BEGIN
			UPDATE DOG_VAX SET VaxDate = @VaxDate WHERE DogID = @DogID AND VaxID = @VaxID
		END
		ELSE
		BEGIN

		INSERT INTO DOG_VAX (DogID, VaxID, VaxDate)
		VALUES
			(@DogID, @VaxID, @VaxDate);
		END

	END
GO

/*
	Create stored procedure to add a medication to a dog

	Param:
		@Name = first name of dog
		@LName = last name of dog
		@MedName = name of the medication
		@Dose = dosage of medication
		@Notes = any specific notes about medication

	Assumptions:
		Dog must exist
		Medication must already exist
		If medication is already associated with dog, dosage and notes will be updated

*/
-- Drop stored procedure if it already exists
IF EXISTS (
  SELECT * 
    FROM INFORMATION_SCHEMA.ROUTINES 
   WHERE SPECIFIC_SCHEMA = N'dbo'
     AND SPECIFIC_NAME = N'AddMed' 
)
   DROP PROCEDURE dbo.AddMed
GO


CREATE PROCEDURE dbo.AddMed
	@Name varchar(50),
	@LName varchar(50),
	@MedName varchar(50),
	@Dose varchar(100),
	@Notes varchar(100) = NULL

AS
	BEGIN
		DECLARE @DogID INT = (SELECT D.DogID FROM DOG D JOIN CUSTOMER C ON C.CustID = D.CustID WHERE D.[Name] = @Name AND C.LName = @LName)
		DECLARE @MedID INT = (SELECT MedID FROM MEDICATION WHERE MedName = @MedName)

		-- Check for null or invalid values in required parameters
		IF @Name IS NULL OR @LName IS NULL OR @MedName IS NULL OR @Dose IS NULL
		BEGIN
			RAISERROR('One or more required parameters are not entered.', 16, 1)
			RETURN
		END

		-- Check if the dog exists in the database
		IF NOT EXISTS (
			SELECT 1 FROM DOG
				WHERE DogID = @DogID
		)
		BEGIN
				RAISERROR('The dog with the specified name does not exist.', 16, 1)
				RETURN
		END

		-- Check if the vaccine exists in the database
		IF NOT EXISTS (
			SELECT 1 FROM MEDICATON
				WHERE MedID = @MedID
		)
		BEGIN
				RAISERROR('The medication that was input does not exist.', 16, 1)
				RETURN
		END

		-- Check if the medication is already associated with that dog, if it is, update does and notes. else create new DOG_MED entry
		IF EXISTS (
			SELECT 1 FROM DOG_MED 
				WHERE DogID = @DogID AND MedID = @MedID
		)
		BEGIN
			UPDATE DOG_MED SET Dose = @Dose, Notes = @Notes WHERE DogID = @DogID AND MedID = @MedID
		END
		ELSE
		BEGIN

		INSERT INTO DOG_MED (DogID, MedID, Dose, Notes)
		VALUES
			(@DogID, @MedID, @Dose, @Notes);
		END

	END
GO
