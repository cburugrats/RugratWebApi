USE [RugratsDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_Statement]    Script Date: 23.10.2019 11:00:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_Statement](
	@id int
)

AS
Select statement
From MoneyTransfers
WHERE Id=@id
