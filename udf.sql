/******************************
** File:	udf.sql
** Desc:	Create user defined functions
** Author:	Kendall Levy
** Date:	6/21/24
**********************
** Change History
**********************
** PR	Date		Author		Description
** 1	6/21/2024	Kendall		Created F_Get_CustID and F_GetDogID
******************************/
USE KenKennel;
GO

IF OBJECT_ID (N'dbo.F_Get_CustID') IS NOT NULL
   DROP FUNCTION dbo.F_Get_CustID
GO

/*
	Create function to get CustID

	Param:
		@FName = first name of customer
		@LName = last name of customer

*/
CREATE FUNCTION F_Get_CustID 
(
	-- Add the parameters for the function here
	@FName varchar(50),
	@LName varchar(50)
)
RETURNS int
AS
BEGIN

	DECLARE @CustID INT = (SELECT CustID FROM CUSTOMER WHERE FName = @FName AND LName = @LName)

	-- Return the result of the function
	RETURN @CustID

END
GO

IF OBJECT_ID (N'dbo.F_Get_DogID') IS NOT NULL
   DROP FUNCTION dbo.F_Get_DogID
GO

/*
	Create function to get DogID

	Param:
		@Name = first name of dog
		@CustLName = last name of customer

*/
CREATE FUNCTION F_Get_DogID 
(
	-- Add the parameters for the function here
	@Name varchar(50),
	@CustLName varchar(50)
)
RETURNS int
AS
BEGIN

	DECLARE @DogID INT = (SELECT TOP 1 D.DogID FROM DOG D JOIN CUSTOMER C ON C.CustID = D.CustID WHERE D.[Name] = @Name AND C.LName = @CustLName);

	-- Return the result of the function
	RETURN @DogID

END
GO