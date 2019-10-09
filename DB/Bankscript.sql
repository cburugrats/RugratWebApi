USE [RugratsDb]
GO
/****** Object:  Table [dbo].[Acconunts]    Script Date: 9.10.2019 13:24:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Acconunts](
	[Id] [int] NOT NULL,
	[customerId] [int] NOT NULL,
	[accountId] [int] NOT NULL,
	[balance] [money] NOT NULL,
	[blockageAmount] [money] NOT NULL,
	[netBalance] [money] NOT NULL,
	[openingDate] [datetime] NOT NULL,
	[lastTransactionDate] [datetime] NOT NULL,
	[status] [bit] NOT NULL,
	[createdDate] [datetime] NOT NULL,
	[uploadedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Acconunts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Customers]    Script Date: 9.10.2019 13:24:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customers](
	[Id] [int] NOT NULL,
	[userId] [int] NOT NULL,
	[firstname] [nvarchar](50) NOT NULL,
	[surname] [nvarchar](50) NOT NULL,
	[dateofBirth] [datetime] NOT NULL,
	[phoneNumber] [bigint] NOT NULL,
	[createdDate] [datetime] NOT NULL,
	[uploadedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Money Transfers]    Script Date: 9.10.2019 13:24:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Money Transfers](
	[Id] [int] NOT NULL,
	[senderAccountId] [int] NOT NULL,
	[balanceSent] [money] NOT NULL,
	[receiverAccountId] [int] NOT NULL,
	[realizationTime] [nchar](10) NOT NULL,
	[status] [bit] NOT NULL,
	[createdDate] [datetime] NOT NULL,
	[uploadedDate] [datetime] NOT NULL,
	[transferType] [bit] NULL,
 CONSTRAINT [PK_Money Transfers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 9.10.2019 13:24:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] NOT NULL,
	[TcIdentityKey] [bigint] NOT NULL,
	[userName] [nvarchar](20) NOT NULL,
	[userPassword] [nvarchar](20) NOT NULL,
	[createdDate] [datetime] NOT NULL,
	[uploadedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Acconunts]  WITH CHECK ADD  CONSTRAINT [FK_Acconunts_Customers] FOREIGN KEY([customerId])
REFERENCES [dbo].[Customers] ([Id])
GO
ALTER TABLE [dbo].[Acconunts] CHECK CONSTRAINT [FK_Acconunts_Customers]
GO
ALTER TABLE [dbo].[Customers]  WITH CHECK ADD  CONSTRAINT [FK_Customers_Users] FOREIGN KEY([userId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Customers] CHECK CONSTRAINT [FK_Customers_Users]
GO
ALTER TABLE [dbo].[Money Transfers]  WITH CHECK ADD  CONSTRAINT [FK_Money Transfers_Acconunts] FOREIGN KEY([senderAccountId])
REFERENCES [dbo].[Acconunts] ([Id])
GO
ALTER TABLE [dbo].[Money Transfers] CHECK CONSTRAINT [FK_Money Transfers_Acconunts]
GO
ALTER TABLE [dbo].[Money Transfers]  WITH CHECK ADD  CONSTRAINT [FK_Money Transfers_Acconunts1] FOREIGN KEY([receiverAccountId])
REFERENCES [dbo].[Acconunts] ([Id])
GO
ALTER TABLE [dbo].[Money Transfers] CHECK CONSTRAINT [FK_Money Transfers_Acconunts1]
GO
