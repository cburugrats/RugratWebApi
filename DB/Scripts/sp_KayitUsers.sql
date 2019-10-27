USE [RugratsDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_KayitUsers]    Script Date: 27.10.2019 18:23:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_KayitUsers](
	@Tc bigint,
	@userName nvarchar(20),
	@userPassword nvarchar(20),
	@customerId int
)
as
INSERT INTO Users(TcIdentityKey,customerId,userName,userPassword)
VALUES(@Tc,@customerId,@userName,@userPassword)
