USE [RugratsDb]
GO
/****** Object:  StoredProcedure [dbo].[sp_Bilgi]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Bilgi](
	@customerId int,
	@userName nvarchar(20),
	@userPassword nvarchar(20),
	@firstname nvarchar(20),
	@surname nvarchar(20),
	@dateofBirth bigint,
	@phoneNumber bigint,
	@eMail nvarchar(20)
)
AS
UPDATE Customers
SET firstname=@firstname, surname=@surname, dateofBirth=@dateofBirth, phoneNumber=@phoneNumber, eMail=@eMail WHERE Id=@customerId

UPDATE Users
SET userName=@userName, userPassword=@userPassword WHERE customerId=@customerId



GO
/****** Object:  StoredProcedure [dbo].[sp_Kayit]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Kayit](
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
GO
/****** Object:  StoredProcedure [dbo].[sp_KayitUsers]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_KayitUsers](
	@Tc bigint,
	@userName nvarchar(20),
	@userPassword nvarchar(20),
	@customerId int
)
as
INSERT INTO Users(TcIdentityKey,customerId,userName,userPassword)
VALUES(@Tc,@customerId,@userName,@userPassword)

GO
/****** Object:  StoredProcedure [dbo].[sp_ParaCekme]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_ParaCekme](
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
GO
/****** Object:  StoredProcedure [dbo].[sp_ParaYatirma]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_ParaYatirma](
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
UPDATE Accounts 
SET balance=balance+@balanceSent, netBalance= netBalance+@balanceSent WHERE accountNo = @senderAccountNo
GO
/****** Object:  StoredProcedure [dbo].[sp_Statement]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Statement](
	@id int
)

AS
Select statement
From MoneyTransfers
WHERE Id=@id

GO
/****** Object:  StoredProcedure [dbo].[sp_Transfer]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_Transfer]
	@senderAccountNo nvarchar(20),
	@receiverAccountNo nvarchar(20),
	@balanceSent money,
	@transferTypeId int,
	@realizationTime datetime,
	@statement nvarchar(50)
AS
INSERT INTO MoneyTransfers(senderAccountNo,receiverAccountNo,balanceSent,transferTypeId,realizationTime,status,statement)
values(@senderAccountNo, @receiverAccountNo,@balanceSent,@transferTypeId,@realizationTime,1,@statement)

GO
/****** Object:  StoredProcedure [dbo].[sp_TransferListeleme]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_TransferListeleme](
	@AccountNo nvarchar(20)
)
AS
SELECT receiverAccountNo, senderAccountNo, transferType, balanceSent, realizationTime
From (MoneyTransfers INNER JOIN TransferTypes
ON MoneyTransfers.transferTypeId = TransferTypes.Id)
WHERE receiverAccountNo=@AccountNo OR senderAccountNo=@AccountNo
ORDER BY createdDate
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Accounts](
	[accountNo] [nvarchar](20) NOT NULL,
	[customerId] [int] NOT NULL,
	[balance] [money] NOT NULL,
	[netBalance] [money] NOT NULL,
	[blockageAmount] [money] NOT NULL,
	[status] [bit] NOT NULL,
	[openingDate] [datetime] NOT NULL,
	[lastTransactionDate] [datetime] NOT NULL,
	[createdDate] [datetime] NULL,
	[updatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[accountNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customers]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[firstname] [nvarchar](20) NOT NULL,
	[surname] [nvarchar](20) NOT NULL,
	[dateofBirth] [datetime] NOT NULL,
	[phoneNumber] [bigint] NOT NULL,
	[eMail] [nvarchar](30) NOT NULL,
	[createdDate] [datetime] NULL,
	[updatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[eMail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[phoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MoneyTransfers]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MoneyTransfers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[senderAccountNo] [nvarchar](20) NOT NULL,
	[receiverAccountNo] [nvarchar](20) NOT NULL,
	[balanceSent] [money] NOT NULL,
	[status] [int] NOT NULL,
	[transferTypeId] [int] NOT NULL,
	[createdDate] [datetime] NULL,
	[updatedDate] [datetime] NULL,
	[statement] [nvarchar](50) NULL,
	[realizationTime] [datetime] NOT NULL,
 CONSTRAINT [PK__MoneyTra__3214EC07CEADFD03] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TransferTypes]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransferTypes](
	[Id] [int] NOT NULL,
	[transferType] [nvarchar](15) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 9.11.2019 16:33:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TcIdentityKey] [bigint] NOT NULL,
	[customerId] [int] NOT NULL,
	[userName] [nvarchar](20) NOT NULL,
	[userPassword] [nvarchar](20) NOT NULL,
	[createdDate] [datetime] NULL,
	[updatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[TcIdentityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Accounts] ADD  DEFAULT (getdate()) FOR [createdDate]
GO
ALTER TABLE [dbo].[Accounts] ADD  DEFAULT (getdate()) FOR [updatedDate]
GO
ALTER TABLE [dbo].[Customers] ADD  DEFAULT (getdate()) FOR [createdDate]
GO
ALTER TABLE [dbo].[Customers] ADD  DEFAULT (getdate()) FOR [updatedDate]
GO
ALTER TABLE [dbo].[MoneyTransfers] ADD  CONSTRAINT [DF__MoneyTran__creat__1A14E395]  DEFAULT (getdate()) FOR [createdDate]
GO
ALTER TABLE [dbo].[MoneyTransfers] ADD  CONSTRAINT [DF__MoneyTran__updat__1B0907CE]  DEFAULT (getdate()) FOR [updatedDate]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [createdDate]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [updatedDate]
GO
ALTER TABLE [dbo].[Accounts]  WITH CHECK ADD  CONSTRAINT [FK_Accounts_Customers] FOREIGN KEY([customerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[Accounts] CHECK CONSTRAINT [FK_Accounts_Customers]
GO
ALTER TABLE [dbo].[MoneyTransfers]  WITH CHECK ADD  CONSTRAINT [FK_MoneyTransfers_Accounts] FOREIGN KEY([senderAccountNo])
REFERENCES [dbo].[Accounts] ([accountNo])
GO
ALTER TABLE [dbo].[MoneyTransfers] CHECK CONSTRAINT [FK_MoneyTransfers_Accounts]
GO
ALTER TABLE [dbo].[MoneyTransfers]  WITH CHECK ADD  CONSTRAINT [FK_MoneyTransfers_Accounts1] FOREIGN KEY([receiverAccountNo])
REFERENCES [dbo].[Accounts] ([accountNo])
GO
ALTER TABLE [dbo].[MoneyTransfers] CHECK CONSTRAINT [FK_MoneyTransfers_Accounts1]
GO
ALTER TABLE [dbo].[MoneyTransfers]  WITH CHECK ADD  CONSTRAINT [FK_MoneyTransfers_TransferTypes] FOREIGN KEY([transferTypeId])
REFERENCES [dbo].[TransferTypes] ([Id])
GO
ALTER TABLE [dbo].[MoneyTransfers] CHECK CONSTRAINT [FK_MoneyTransfers_TransferTypes]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Customers] FOREIGN KEY([customerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Customers]
GO
