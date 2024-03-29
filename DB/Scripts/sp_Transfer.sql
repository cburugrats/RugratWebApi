USE [RugratsDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_Transfer]    Script Date: 27.10.2019 18:23:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_Transfer]
	@senderAccountNo nvarchar(20),
	@receiverAccountNo nvarchar(20),
	@balanceSent money,
	@transferTypeId int,
	@realizationTime datetime,
	@statement nvarchar(50)
AS
INSERT INTO MoneyTransfers(senderAccountNo,receiverAccountNo,balanceSent,transferTypeId,realizationTime,status,statement)
values(@senderAccountNo, @receiverAccountNo,@balanceSent,@transferTypeId,@realizationTime,1,@statement)
