/******************************
** File:	udf.sql
** Desc:	Create user defined functions
** Author:	Kendall Levy
** Date:	6/21/24
**********************
** Change History
**********************
** PR	Date		Author		Description
** 1	6/21/2024	Kendall		Created F_Get_CustID and F_Get_DogID
** 2	6/27/2024	Kendall		Adjusted F_Get_DogID to take in customer first name
******************************/
USE KenKennel;
GO


IF OBJECT_ID (N'dbo.F_Get_CustID') IS NOT NULL
   DROP FUNCTION dbo.F_Get_CustID
GO

/*
	Create function to get CustID

	Returns INT

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

	Returns INT

	Param:
		@CustFName = first name of customer
		@CustLName = last name of customer
		@DogName = dog first name

*/
CREATE FUNCTION F_Get_DogID 
(
	-- Add the parameters for the function here
	@CustFName varchar(50),
	@CustLName varchar(50),
	@DogName varchar(50)
)
RETURNS int
AS
BEGIN
	DECLARE @CustID INT = (SELECT dbo.F_Get_CustID(@CustFName, @CustLName))
	DECLARE @DogID INT = (SELECT DogID FROM DOG D WHERE CustID = @CustID AND [Name] = @DogName);

	-- Return the result of the function
	RETURN @DogID

END
GO

/*
	Create function to get VisitID

	Returns INT

	Param:
		@RunID = ID of the run
		@Arrive = arrival date
		@Depart = departure date

*/
CREATE FUNCTION F_Get_VisitID 
(
	-- Add the parameters for the function here
	@RunID int,
	@Arrive date,
	@Depart date
)
RETURNS int
AS
BEGIN
	DECLARE @VisitID INT = (SELECT VisitID FROM VISIT WHERE RunID = @RunID AND ArrivalDate = @Arrive AND DepartDate = @Depart);

	-- Return the result of the function
	RETURN @VisitID

END
GO

/*
	Create function to return if there are overlaps in a dog's new visit booking and already booked visits


	Returns BIT

	Param:
		@DogID = ID of the dog to check
		@Arrive = arrival date
		@Depart = departure date

*/
CREATE FUNCTION F_Get_Overlap 
(
	-- Add the parameters for the function here
	@DogID int,
	@Arrive date,
	@Depart date
)
RETURNS BIT
AS
BEGIN
	DECLARE @Overlap BIT = 0
	IF EXISTS(
		SELECT VisitID FROM VISIT WHERE dogID = @DogID
		AND (
				(ArrivalDate BETWEEN @Arrive AND @Depart)
				OR (DepartDate BETWEEN @Arrive AND @Depart)
				OR (ArrivalDate <= @Arrive AND DepartDate >= @Arrive)
			)
	)
		BEGIN
			SET @Overlap = 1
		END
	-- Return the result of the function
	RETURN @Overlap

END
GO


/*
	Create function to get available runs

	Returns TABLE of RunID, RunNumber, and RunTypeName

	Param:
		@startDate = start date run should be available
		@endDate = end date run should be available
*/
IF OBJECT_ID (N'dbo.F_Get_Available_Runs') IS NOT NULL
    DROP FUNCTION dbo.F_Get_Available_Runs
GO

CREATE FUNCTION dbo.F_Get_Available_Runs (@startDate DATE, @endDate DATE)
RETURNS @AvailableRuns TABLE
(
    RunNumber VARCHAR(5),
	RunTypeAbrv char(1)
)
AS
BEGIN
    -- Insert available RunIDs into the return table
    INSERT INTO @AvailableRuns (RunNumber, RunTypeAbrv)
    SELECT R.RunNumber, RT.RunTypeAbrv
    FROM RUN R
	LEFT JOIN RUN_TYPE RT ON R.RunTypeID = RT.RunTypeID
    WHERE NOT EXISTS (
        SELECT 1
        FROM VISIT v
        JOIN VISIT_STATUS vs ON v.StatusID = vs.StatusID
        WHERE v.RunID = R.RunID
        AND vs.VisitStatus = 'Scheduled to board'
        AND (
            (v.ArrivalDate BETWEEN @startDate AND @endDate)
            OR (v.DepartDate BETWEEN @startDate AND @endDate)
            OR (v.ArrivalDate <= @startDate AND v.DepartDate >= @endDate)
        )
    );

    RETURN;
END;
GO

