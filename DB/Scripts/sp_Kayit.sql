USE [RugratsDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_Kayit]    Script Date: 27.10.2019 18:23:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_Kayit](
	@TcKn bigint,
	@userName nvarchar(20),
	@userPassword nvarchar(20),
	@firstName nvarchar(20),
	@surName nvarchar(20),
	@dateofBirth datetime,
	@phoneNumber bigint,
	@eMail nvarchar(30)
)
AS
INSERT INTO Customers(firstname,surname,dateOfBirth,phoneNumber,eMail)
VALUES(@firstName,@surName,@dateOfBirth,@phoneNumber,@eMail)

exec sp_KayitUsers @TcKn,@userName,@userPassword,@customerId=@@IDENTITY