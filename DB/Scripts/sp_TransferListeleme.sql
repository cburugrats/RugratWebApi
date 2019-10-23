USE [RugratsDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_TransferListeleme]    Script Date: 23.10.2019 01:41:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_TransferListeleme]
AS
SELECT receiverAccountNo, senderAccountNo, transferType, balanceSent, createdDate
From (MoneyTransfers INNER JOIN TransferTypes
ON MoneyTransfers.transferTypeId = TransferTypes.Id) 