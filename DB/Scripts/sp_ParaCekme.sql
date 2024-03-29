USE [RugratsDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_ParaCekme]    Script Date: 27.10.2019 18:23:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_ParaCekme](
	@receiverAccountNo nvarchar(20),
	@senderAccountNo nvarchar(20),
	@balanceSent money,
	@transferTypeId int,
	@realizationTime nchar(10),
	@status int,
	@statement nvarchar(50)
	)
	AS
INSERT INTO MoneyTransfers(senderAccountNo,receiverAccountNo,balanceSent,transferTypeId,realizationTime,status,statement)
values(@senderAccountNo,@receiverAccountNo,@balanceSent,@transferTypeId,@realizationTime,1,@statement)
UPDATE Accounts SET balance=balance-@balanceSent, netBalance= netBalance-@balanceSent  WHERE accountNo = @receiverAccountNo