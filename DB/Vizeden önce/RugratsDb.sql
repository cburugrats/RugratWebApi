USE [RugratsDb]
GO
/****** Object:  Table [dbo].[Accounts]    Script Date: 21.10.2019 20:06:39 ******/
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
/****** Object:  Table [dbo].[Customers]    Script Date: 21.10.2019 20:06:39 ******/
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
/****** Object:  Table [dbo].[MoneyTransfers]    Script Date: 21.10.2019 20:06:39 ******/
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
	[realizationTime] [nchar](10) NOT NULL,
	[createdDate] [datetime] NULL,
	[updatedDate] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TransferTypes]    Script Date: 21.10.2019 20:06:39 ******/
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
/****** Object:  Table [dbo].[Users]    Script Date: 21.10.2019 20:06:39 ******/
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
ALTER TABLE [dbo].[MoneyTransfers] ADD  DEFAULT (getdate()) FOR [createdDate]
GO
ALTER TABLE [dbo].[MoneyTransfers] ADD  DEFAULT (getdate()) FOR [updatedDate]
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
