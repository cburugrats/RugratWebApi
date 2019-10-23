USE [RugratsDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_TransferListeleme]    Script Date: 23.10.2019 12:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[sp_TransferListeleme](
	@AccountNo nvarchar(20)
)
AS
SELECT receiverAccountNo, senderAccountNo, transferType, balanceSent, createdDate
From (MoneyTransfers INNER JOIN TransferTypes
ON MoneyTransfers.transferTypeId = TransferTypes.Id)
WHERE receiverAccountNo=@AccountNo OR senderAccountNo=@AccountNo
ORDER BY createdDate