/******************************
** File:	views.sql
** Desc:	Create views for KenKennel to use in KenKennelMangement software
** Author:	Kendall Levy
** Date:	6/15/24
**********************
** Change History
**********************
** PR	Date		Author		Description
** 1	6/15/2024	Kendall		Created V_Get_Dogs view for KenKennel
** 2	6/18/2024	Kendall		Created V_Get_Cust view for KenKennel
** 3	6/19/2024	Kendall		Adjusted V_Get_Dogs to show more information, may change later.
******************************/

use KenKennel;


/* Get all dogs and important information regarding dog */
DROP VIEW IF Exists dbo.V_Get_Dogs
GO

CREATE VIEW dbo.V_Get_Dogs AS
SELECT D.[Name] as [First name], C.LName as [Last name], S.SexAbrv AS Sex, D.Age, D.[Weight], D.Color, T.TagDescr, V.VaXName, DV.VaxDate
FROM DOG D
	JOIN CUSTOMER C ON D.CustID = C.CustID
	JOIN BREED B ON B.BreedID = D.BreedID
	JOIN SEX S ON S.SexID = D.SexID
	JOIN DOG_TAG DT ON D.DogID = DT.DogID
	JOIN TAG T ON DT.TagID = T.TagID
	JOIN DOG_VAX DV ON DV.DogID = D.DogID
	JOIN VACCINATION V ON V.VaxID = DV.VaxID
GO


/* Get all Customers and contact information */
DROP VIEW IF Exists dbo.V_Get_Cust
GO

CREATE VIEW dbo.V_Get_Cust AS
SELECT C.FName, C.LName, C.Email, P.Num, A.AddressLine1, A.AddressLine2, S.StateName, A.City, A.Zip
FROM CUSTOMER C
	JOIN PHONE_NUM P ON P.CustID = C.CustID
	JOIN [ADDRESS] A ON A.CustID = C.CustID
	JOIN [STATE] S ON S.StateID = A.StateID
GO
