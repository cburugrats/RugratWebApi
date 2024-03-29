USE [rugratsdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_Bilgi]    Script Date: 24.11.2019 09:52:35 ******/
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
	@dateofBirth datetime,
	@phoneNumber bigint,
	@eMail nvarchar(20)
)
AS
UPDATE Customers
SET firstname=@firstname, surname=@surname, dateofBirth=@dateofBirth, phoneNumber=@phoneNumber, eMail=@eMail, updatedDate=GETDATE() WHERE Id=@customerId

UPDATE Users
SET userName=@userName, userPassword=@userPassword, updatedDate=GETDATE() WHERE customerId=@customerId

GO
/****** Object:  StoredProcedure [dbo].[sp_Kayit]    Script Date: 24.11.2019 09:52:36 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_KayitUsers]    Script Date: 24.11.2019 09:52:36 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_ParaCekme]    Script Date: 24.11.2019 09:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_ParaCekme](
	@receiverAccountNo nvarchar(20),
	@senderAccountNo nvarchar(20),
	@balanceSent money,
	@transferTypeId int,
	@realizationTime datetime,
	@status int,
	@statement nvarchar(50)
	)
	AS
INSERT INTO MoneyTransfers(senderAccountNo,receiverAccountNo,balanceSent,transferTypeId,realizationTime,status,statement)
values(@senderAccountNo,@receiverAccountNo,@balanceSent,@transferTypeId,@realizationTime,1,@statement)
UPDATE Accounts SET balance=balance-@balanceSent, netBalance= netBalance-@balanceSent  WHERE accountNo = @receiverAccountNo


GO
/****** Object:  StoredProcedure [dbo].[sp_ParaYatirma]    Script Date: 24.11.2019 09:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_ParaYatirma](
	@receiverAccountNo nvarchar(20),
	@senderAccountNo nvarchar(20),
	@balanceSent money,
	@transferTypeId int,
	@realizationTime datetime,
	@status int,
	@statement nvarchar(50)
	)
	AS
INSERT INTO MoneyTransfers(senderAccountNo,receiverAccountNo,balanceSent,transferTypeId,realizationTime,status,statement)
values(@senderAccountNo,@receiverAccountNo,@balanceSent,@transferTypeId,@realizationTime,1,@statement)
UPDATE Accounts 
SET balance=balance+@balanceSent, netBalance= netBalance+@balanceSent WHERE accountNo = @senderAccountNo


GO
/****** Object:  StoredProcedure [dbo].[sp_Statement]    Script Date: 24.11.2019 09:52:36 ******/
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
/****** Object:  StoredProcedure [dbo].[sp_Transfer]    Script Date: 24.11.2019 09:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[sp_Transfer]
	@senderAccountNo nvarchar(20),
	@receiverAccountNo nvarchar(20),
	@amount money,
	@transferTypeId int,
	@realizationTime datetime,
	@statement nvarchar(50)
AS
INSERT INTO MoneyTransfers(senderAccountNo,receiverAccountNo,balanceSent,transferTypeId,realizationTime,status,statement)
values(@senderAccountNo, @receiverAccountNo,@amount,@transferTypeId,@realizationTime,1,@statement)


GO
/****** Object:  StoredProcedure [dbo].[sp_TransferListeleme]    Script Date: 24.11.2019 09:52:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[sp_TransferListeleme](
	@AccountNo nvarchar(20)
)
AS
SELECT receiverAccountNo, senderAccountNo, transferType, balanceSent as 'amount', statement	,realizationTime
From (MoneyTransfers INNER JOIN TransferTypes
ON MoneyTransfers.transferTypeId = TransferTypes.Id)
WHERE receiverAccountNo=@AccountNo OR senderAccountNo=@AccountNo
ORDER BY realizationTime DESC

GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 24.11.2019 09:52:36 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[Customers]    Script Date: 24.11.2019 09:52:36 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[MoneyTransfers]    Script Date: 24.11.2019 09:52:37 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[TransferTypes]    Script Date: 24.11.2019 09:52:38 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[Users]    Script Date: 24.11.2019 09:52:38 ******/
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'111111111111001', 1, 808.3200, 808.3200, 0.0000, 1, CAST(0x0000AB000154D066 AS DateTime), CAST(0x0000AB000154D066 AS DateTime), CAST(0x0000AB000154D066 AS DateTime), CAST(0x0000AB000154D066 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'111111111111002', 1, 248.8000, 248.8000, 0.0000, 1, CAST(0x0000AB000154D543 AS DateTime), CAST(0x0000AB000154D543 AS DateTime), CAST(0x0000AB000154D543 AS DateTime), CAST(0x0000AB000154D543 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'111111111111003', 1, 0.0000, 0.0000, 0.0000, 0, CAST(0x0000AB0100D94432 AS DateTime), CAST(0x0000AB0100D94432 AS DateTime), CAST(0x0000AB0100D94431 AS DateTime), CAST(0x0000AB0100D94432 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'111111111111004', 1, 0.0000, 0.0000, 0.0000, 1, CAST(0x0000AB0500F3BA68 AS DateTime), CAST(0x0000AB0500F3BA68 AS DateTime), CAST(0x0000AB0500F3BA60 AS DateTime), CAST(0x0000AB0500F3BA68 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'111111111111005', 1, 0.0000, 0.0000, 0.0000, 1, CAST(0x0000AB0A01593084 AS DateTime), CAST(0x0000AB0A01593084 AS DateTime), CAST(0x0000AB0A01593083 AS DateTime), CAST(0x0000AB0A01593084 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'113344678991001', 4, 100.0000, 100.0000, 0.0000, 1, CAST(0x0000AB000181DD0D AS DateTime), CAST(0x0000AB000181DD0D AS DateTime), CAST(0x0000AB000181DD0D AS DateTime), CAST(0x0000AB000181DD0D AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'113344678991002', 4, 23.0000, 23.0000, 0.0000, 1, CAST(0x0000AB0001824029 AS DateTime), CAST(0x0000AB0001824029 AS DateTime), CAST(0x0000AB0001824029 AS DateTime), CAST(0x0000AB0001824029 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'123456789001001', 8, 0.0000, 0.0000, 0.0000, 1, CAST(0x0000AB050146F748 AS DateTime), CAST(0x0000AB050146F748 AS DateTime), CAST(0x0000AB050146F748 AS DateTime), CAST(0x0000AB050146F748 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'123456789011001', 19, 18.0000, 18.0000, 0.0000, 1, CAST(0x0000AB0B010F5B4E AS DateTime), CAST(0x0000AB0B010F5B4E AS DateTime), CAST(0x0000AB0B010F5B4E AS DateTime), CAST(0x0000AB0B010F5B4E AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'123456789011002', 19, 30.0000, 30.0000, 0.0000, 1, CAST(0x0000AB0B010F905D AS DateTime), CAST(0x0000AB0B010F905D AS DateTime), CAST(0x0000AB0B010F905D AS DateTime), CAST(0x0000AB0B010F905D AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'367099999991001', 7, 47567.3000, 47567.3000, 0.0000, 1, CAST(0x0000AB04010D758E AS DateTime), CAST(0x0000AB04010D758E AS DateTime), CAST(0x0000AB04010D758E AS DateTime), CAST(0x0000AB04010D758E AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'367099999991002', 7, 0.0000, 0.0000, 0.0000, 1, CAST(0x0000AB04010D77C0 AS DateTime), CAST(0x0000AB04010D77C0 AS DateTime), CAST(0x0000AB04010D77C0 AS DateTime), CAST(0x0000AB04010D77C0 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'367099999991003', 7, 0.0000, 0.0000, 0.0000, 1, CAST(0x0000AB04010D79B5 AS DateTime), CAST(0x0000AB04010D79B5 AS DateTime), CAST(0x0000AB04010D79B5 AS DateTime), CAST(0x0000AB04010D79B5 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'555555555551001', 5, 0.0000, 0.0000, 0.0000, 1, CAST(0x0000AB01005E121E AS DateTime), CAST(0x0000AB01005E121E AS DateTime), CAST(0x0000AB01005E121E AS DateTime), CAST(0x0000AB01005E121E AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'999999999991001', 6, 1518.6600, 1518.6600, 0.0000, 1, CAST(0x0000AB0400DCACF2 AS DateTime), CAST(0x0000AB0400DCACF2 AS DateTime), CAST(0x0000AB0400DCACF2 AS DateTime), CAST(0x0000AB0400DCACF2 AS DateTime))
INSERT [dbo].[Accounts] ([accountNo], [customerId], [balance], [netBalance], [blockageAmount], [status], [openingDate], [lastTransactionDate], [createdDate], [updatedDate]) VALUES (N'999999999991002', 6, 2.4300, 2.4300, 0.0000, 1, CAST(0x0000AB0400DCB139 AS DateTime), CAST(0x0000AB0400DCB139 AS DateTime), CAST(0x0000AB0400DCB139 AS DateTime), CAST(0x0000AB0400DCB139 AS DateTime))
SET IDENTITY_INSERT [dbo].[Customers] ON 

INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (1, N'Muhammet Sait', N'KARABULAK', CAST(0x0000918600000000 AS DateTime), 1111111111, N'sait.krblk@gmail.com', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (2, N'Muhammet', N'KARABULAK', CAST(0x0000915F00000000 AS DateTime), 555226425, N'm.sait.krblk@gmail.com', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (4, N'Muhammet', N'KARABULAK', CAST(0x00008A7400000000 AS DateTime), 555226442, N'm.4sait.krblk@gmail.com', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (5, N'm', N's', CAST(0x00008EB500000000 AS DateTime), 5555555555, N'ssdf@dsf.com', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (6, N'Muhammet Sait', N'KARABULAK', CAST(0x0000914100000000 AS DateTime), 2222222222, N'1@1', NULL, CAST(0x0000AB0400F19523 AS DateTime))
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (7, N'azer', N'1212211', CAST(0x0000914F00000000 AS DateTime), 3343443443, N'azer@gmail.com', NULL, CAST(0x0000AB04010D3D69 AS DateTime))
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (8, N'Bahar', N'Didem ', CAST(0x00008EB600000000 AS DateTime), 1231231234, N'deneme@deneme', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (9, N'Merih', N'Demiral', CAST(0x00008C1100000000 AS DateTime), 5395562485, N'ty@gmail.com', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (10, N'Mer', N'Dfgh', CAST(0x00008C1100000000 AS DateTime), 569854566, N'dghjjs@gmail.com', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (15, N'Mehmett', N'Öz', CAST(0x000088F700000000 AS DateTime), 88888, N'oz@gmail.com', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (16, N'Merih', N'Degh', CAST(0x00008C2700000000 AS DateTime), 5874565489, N'dhdsdf@gmail.com', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (17, N'Johan', N'Cruyff', CAST(0x00008C2600000000 AS DateTime), 856543655, N'johan@gmail.com', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (18, N'Muhammet', N'Ali', CAST(0x0000915700000000 AS DateTime), 5426875662, N'ghegh@c.j', NULL, NULL)
INSERT [dbo].[Customers] ([Id], [firstname], [surname], [dateofBirth], [phoneNumber], [eMail], [createdDate], [updatedDate]) VALUES (19, N'Mehmet', N'Çelik', CAST(0x00006FA300000000 AS DateTime), 5553334422, N'mehmetcelik@gmail.com', NULL, NULL)
SET IDENTITY_INSERT [dbo].[Customers] OFF
SET IDENTITY_INSERT [dbo].[MoneyTransfers] ON 

INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (10, N'111111111111001', N'111111111111001', 12.0000, 1, 2, CAST(0x0000AB000161D1D6 AS DateTime), CAST(0x0000AB000161D1D6 AS DateTime), N'', CAST(0x0000AB0000000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (11, N'111111111111002', N'111111111111001', 63.2000, 1, 4, CAST(0x0000AB000161F0FC AS DateTime), CAST(0x0000AB000161F0FC AS DateTime), N'', CAST(0x0000AB000161F0AC AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (12, N'111111111111002', N'111111111111002', 12.0000, 1, 2, CAST(0x0000AB0001631DC3 AS DateTime), CAST(0x0000AB0001631DC3 AS DateTime), N'', CAST(0x0000AB0000000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (13, N'111111111111002', N'111111111111002', 300.0000, 1, 2, CAST(0x0000AB00016CED0E AS DateTime), CAST(0x0000AB00016CED0E AS DateTime), N'', CAST(0x0000AB0100000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (14, N'113344678991001', N'113344678991001', 123.0000, 1, 2, CAST(0x0000AB0001820AB7 AS DateTime), CAST(0x0000AB0001820AB7 AS DateTime), N'', CAST(0x0000AB0000000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (15, N'113344678991001', N'113344678991002', 23.0000, 1, 4, CAST(0x0000AB00018250AC AS DateTime), CAST(0x0000AB00018250AC AS DateTime), N'33', CAST(0x0000AB0001825063 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (16, N'111111111111001', N'111111111111001', 12.3000, 1, 2, CAST(0x0000AB0100D9727A AS DateTime), CAST(0x0000AB0100D9727A AS DateTime), N'', CAST(0x0000AB0100000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (17, N'111111111111001', N'111111111111001', 1520.0000, 1, 2, CAST(0x0000AB0100DBB5A1 AS DateTime), CAST(0x0000AB0100DBB5A1 AS DateTime), N'', CAST(0x0000AB0100000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (31, N'111111111111001', N'111111111111001', 240.0000, 1, 4, CAST(0x0000AB010111F843 AS DateTime), CAST(0x0000AB010111F843 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB0101436857 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (32, N'111111111111001', N'111111111111001', 240.0000, 1, 5, CAST(0x0000AB0101127807 AS DateTime), CAST(0x0000AB0101127807 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB010143E7FD AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (34, N'111111111111001', N'111111111111001', 1.0000, 1, 5, CAST(0x0000AB0300A662DF AS DateTime), CAST(0x0000AB0300A662DF AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB0300A662D6 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (40, N'111111111111001', N'111111111111001', 240.0000, 1, 5, CAST(0x0000AB03012BAFE5 AS DateTime), CAST(0x0000AB03012BAFE5 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB03015D1FF3 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (41, N'111111111111001', N'111111111111001', 100.0000, 1, 5, CAST(0x0000AB03012C1434 AS DateTime), CAST(0x0000AB03012C1434 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB03015D8450 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (42, N'111111111111001', N'111111111111001', 100.0000, 1, 5, CAST(0x0000AB03012C8F4D AS DateTime), CAST(0x0000AB03012C8F4D AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB03015DFF67 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (45, N'111111111111001', N'111111111111001', 100.0000, 1, 5, CAST(0x0000AB03013B3F6D AS DateTime), CAST(0x0000AB03013B3F6D AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB03013B3F67 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (46, N'111111111111001', N'111111111111001', 3.0000, 1, 5, CAST(0x0000AB03013B8DD2 AS DateTime), CAST(0x0000AB03013B8DD2 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB03013B8DCE AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (47, N'111111111111001', N'111111111111001', 12.0000, 1, 5, CAST(0x0000AB03014E937D AS DateTime), CAST(0x0000AB03014E937D AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB03014E937B AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (48, N'111111111111001', N'111111111111001', 12.0000, 1, 5, CAST(0x0000AB03014E9F16 AS DateTime), CAST(0x0000AB03014E9F16 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB03014E9F12 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (49, N'111111111111001', N'111111111111001', 10.0000, 1, 5, CAST(0x0000AB03014ECFD9 AS DateTime), CAST(0x0000AB03014ECFD9 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB03014ECFD4 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (50, N'111111111111001', N'111111111111003', 12.0000, 1, 4, CAST(0x0000AB0301509BE8 AS DateTime), CAST(0x0000AB0301509BE8 AS DateTime), N'', CAST(0x0000AB0301509BA0 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (51, N'111111111111001', N'111111111111001', 12.0000, 1, 2, CAST(0x0000AB030150A890 AS DateTime), CAST(0x0000AB030150A890 AS DateTime), N'', CAST(0x0000AB0300000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (52, N'111111111111001', N'111111111111001', 12.0000, 1, 1, CAST(0x0000AB030150AD2F AS DateTime), CAST(0x0000AB030150AD2F AS DateTime), N'', CAST(0x0000AB0300000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (53, N'111111111111003', N'111111111111003', 12.0000, 1, 1, CAST(0x0000AB04008B7553 AS DateTime), CAST(0x0000AB04008B7553 AS DateTime), N'', CAST(0x0000AB0400000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (54, N'111111111111002', N'111111111111001', 300.0000, 1, 4, CAST(0x0000AB04008C0A24 AS DateTime), CAST(0x0000AB04008C0A24 AS DateTime), N'', CAST(0x0000AB04008C09F4 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (55, N'111111111111001', N'111111111111001', 50.0000, 1, 5, CAST(0x0000AB04008C34F1 AS DateTime), CAST(0x0000AB04008C34F1 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB04008C34EA AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (56, N'111111111111001', N'111111111111001', 12.0000, 1, 2, CAST(0x0000AB0400C29CB5 AS DateTime), CAST(0x0000AB0400C29CB5 AS DateTime), N'', CAST(0x0000AB0400000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (57, N'111111111111001', N'111111111111001', 0.0100, 1, 2, CAST(0x0000AB0400C6719D AS DateTime), CAST(0x0000AB0400C6719D AS DateTime), N'', CAST(0x0000AB0400000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (58, N'999999999991001', N'999999999991001', 12.0000, 1, 2, CAST(0x0000AB0400DCC0E8 AS DateTime), CAST(0x0000AB0400DCC0E8 AS DateTime), N'', CAST(0x0000AB0400000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (59, N'999999999991001', N'999999999991001', 1.1000, 1, 1, CAST(0x0000AB0400DCF784 AS DateTime), CAST(0x0000AB0400DCF784 AS DateTime), N'', CAST(0x0000AB0400000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (60, N'999999999991001', N'999999999991002', 1.2300, 1, 4, CAST(0x0000AB0400DD7133 AS DateTime), CAST(0x0000AB0400DD7133 AS DateTime), N'Deneme', CAST(0x0000AB0400DD70DD AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (61, N'999999999991001', N'111111111111001', 0.6500, 1, 3, NULL, NULL, N'Deneme', CAST(0x0000AB0400DDABF7 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (62, N'999999999991001', N'999999999991002', 0.2000, 1, 4, CAST(0x0000AB0400DE73B4 AS DateTime), CAST(0x0000AB0400DE73B4 AS DateTime), N'', CAST(0x0000AB0400DE7390 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (63, N'999999999991001', N'111111111111001', 0.1600, 1, 3, NULL, NULL, N'Deneme', CAST(0x0000AB0400DE95D6 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (64, N'999999999991001', N'999999999991001', 1.0000, 1, 2, CAST(0x0000AB0400E291B1 AS DateTime), CAST(0x0000AB0400E291B1 AS DateTime), N'', CAST(0x0000AB0400000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (65, N'999999999991001', N'999999999991002', 1.0000, 1, 4, CAST(0x0000AB0400E2F073 AS DateTime), CAST(0x0000AB0400E2F073 AS DateTime), N'', CAST(0x0000AB0400000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (66, N'999999999991001', N'999999999991001', 1522.0000, 1, 2, CAST(0x0000AB0400F0A936 AS DateTime), CAST(0x0000AB0400F0A936 AS DateTime), N'', CAST(0x0000AB0400F0A926 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (67, N'999999999991001', N'999999999991001', 12.0000, 1, 5, CAST(0x0000AB0400F0C6B3 AS DateTime), CAST(0x0000AB0400F0C6B3 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB0400F0C6B2 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (68, N'367099999991001', N'367099999991001', 50000.0000, 1, 2, CAST(0x0000AB04010D9A67 AS DateTime), CAST(0x0000AB04010D9A67 AS DateTime), N'', CAST(0x0000AB04010D9A63 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (69, N'367099999991001', N'367099999991001', 100.0000, 1, 5, CAST(0x0000AB04010DB836 AS DateTime), CAST(0x0000AB04010DB836 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB04010DB831 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (70, N'367099999991001', N'367099999991001', 2332.7000, 1, 5, CAST(0x0000AB04010DD294 AS DateTime), CAST(0x0000AB04010DD294 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB04010DD293 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (71, N'123456789011001', N'123456789011001', 100.0000, 1, 2, CAST(0x0000AB0B01102E52 AS DateTime), CAST(0x0000AB0B01102E52 AS DateTime), N'', CAST(0x0000AB0B01102E4D AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (72, N'123456789011001', N'123456789011001', 10.0000, 1, 1, CAST(0x0000AB0B01109437 AS DateTime), CAST(0x0000AB0B01109437 AS DateTime), N'', CAST(0x0000AB0B01109423 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (73, N'123456789011001', N'123456789011002', 30.0000, 1, 4, CAST(0x0000AB0B01159455 AS DateTime), CAST(0x0000AB0B01159455 AS DateTime), N'Aktarım', CAST(0x0000AB0B01155DD6 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (74, N'123456789011001', N'111111111111001', 20.0000, 1, 3, NULL, NULL, N'Harçlık', CAST(0x0000AB0B0115E37B AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (75, N'123456789011001', N'123456789011001', 10.0000, 1, 5, CAST(0x0000AB0B011F337F AS DateTime), CAST(0x0000AB0B011F337F AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB0B011F3379 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (76, N'123456789011001', N'123456789011001', 12.0000, 1, 5, CAST(0x0000AB0B011F7661 AS DateTime), CAST(0x0000AB0B011F7661 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB0B011F7661 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (77, N'111111111111001', N'111111111111004', 12.0000, 1, 4, CAST(0x0000AB0C01271188 AS DateTime), CAST(0x0000AB0C01271188 AS DateTime), N'tşk', CAST(0x0000AB0C00000000 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (78, N'111111111111001', N'111111111111001', 20.0000, 1, 1, CAST(0x0000AB0C012736B6 AS DateTime), CAST(0x0000AB0C012736B6 AS DateTime), N'', CAST(0x0000AB0C012736B7 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (79, N'111111111111001', N'111111111111001', 20.0000, 1, 2, CAST(0x0000AB0C012744F9 AS DateTime), CAST(0x0000AB0C012744F9 AS DateTime), N'', CAST(0x0000AB0C012744F5 AS DateTime))
INSERT [dbo].[MoneyTransfers] ([Id], [senderAccountNo], [receiverAccountNo], [balanceSent], [status], [transferTypeId], [createdDate], [updatedDate], [statement], [realizationTime]) VALUES (80, N'111111111111004', N'111111111111004', 12.0000, 1, 5, CAST(0x0000AB0C014745B7 AS DateTime), CAST(0x0000AB0C014745B7 AS DateTime), N'Hgs''ye Para Yatırıldı', CAST(0x0000AB0C014745B3 AS DateTime))
SET IDENTITY_INSERT [dbo].[MoneyTransfers] OFF
INSERT [dbo].[TransferTypes] ([Id], [transferType]) VALUES (1, N'Para Çekme')
INSERT [dbo].[TransferTypes] ([Id], [transferType]) VALUES (2, N'Para Yatirma')
INSERT [dbo].[TransferTypes] ([Id], [transferType]) VALUES (3, N'Havale')
INSERT [dbo].[TransferTypes] ([Id], [transferType]) VALUES (4, N'Virman')
INSERT [dbo].[TransferTypes] ([Id], [transferType]) VALUES (5, N'Hgs')
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (1, 11111111111, 1, N'11111111111', N'1', CAST(0x0000AB000143B596 AS DateTime), CAST(0x0000AB000143B596 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (2, 22222222222, 2, N'22222222222', N'1', CAST(0x0000AB00018134D3 AS DateTime), CAST(0x0000AB00018134D3 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (3, 11334467899, 4, N'11334467899', N'1', CAST(0x0000AB000181A9E6 AS DateTime), CAST(0x0000AB000181A9E6 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (4, 55555555555, 5, N'55555555555', N'Ms', CAST(0x0000AB01005DE078 AS DateTime), CAST(0x0000AB01005DE078 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (5, 99999999999, 6, N'99999999999', N'1', CAST(0x0000AB0400DC8C89 AS DateTime), CAST(0x0000AB0400F19526 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (6, 36709999999, 7, N'36709999999', N'123456', CAST(0x0000AB04010C65CC AS DateTime), CAST(0x0000AB04010D3D6F AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (7, 12345678900, 8, N'12345678900', N'bahar', CAST(0x0000AB050144DE14 AS DateTime), CAST(0x0000AB050144DE14 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (10, 88888888888, 15, N'88888888888', N'1', CAST(0x0000AB0700290D8C AS DateTime), CAST(0x0000AB0700290D91 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (11, 95959595959, 16, N'95959595959', N'12345', CAST(0x0000AB06018376F5 AS DateTime), CAST(0x0000AB06018376F5 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (12, 34343434343, 17, N'34343434343', N'123', CAST(0x0000AB0601847445 AS DateTime), CAST(0x0000AB0601847445 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (13, 27272727272, 18, N'27272727272', N'123', CAST(0x0000AB070158A2F8 AS DateTime), CAST(0x0000AB070158A2F8 AS DateTime))
INSERT [dbo].[Users] ([Id], [TcIdentityKey], [customerId], [userName], [userPassword], [createdDate], [updatedDate]) VALUES (14, 12345678901, 19, N'12345678901', N'mehmehcelik', CAST(0x0000AB0B01047607 AS DateTime), CAST(0x0000AB0B01047607 AS DateTime))
SET IDENTITY_INSERT [dbo].[Users] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UQ__Customer__410EDA2FB2463AB1]    Script Date: 24.11.2019 09:52:42 ******/
ALTER TABLE [dbo].[Customers] ADD UNIQUE NONCLUSTERED 
(
	[eMail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
/****** Object:  Index [UQ__Customer__4849DA010F8B0E75]    Script Date: 24.11.2019 09:52:42 ******/
ALTER TABLE [dbo].[Customers] ADD UNIQUE NONCLUSTERED 
(
	[phoneNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
/****** Object:  Index [UQ__Users__DBD864F42AD62211]    Script Date: 24.11.2019 09:52:42 ******/
ALTER TABLE [dbo].[Users] ADD UNIQUE NONCLUSTERED 
(
	[TcIdentityKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
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
