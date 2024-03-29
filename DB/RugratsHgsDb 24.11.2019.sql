USE [rugratshgsdb]
GO
/****** Object:  StoredProcedure [dbo].[sp_HgsParaEkle]    Script Date: 24.11.2019 09:53:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_HgsParaEkle](
	@HgsNo bigint,
	@balance money
)
AS
UPDATE [User]
SET balance=balance+@balance WHERE HgsNo=@HgsNo
GO
/****** Object:  StoredProcedure [dbo].[sp_HgsUserEkle]    Script Date: 24.11.2019 09:53:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[sp_HgsUserEkle](
	@HgsNo bigint,
	@balance money
)
AS
INSERT INTO [User](HgsNo,balance)
VALUES(@HgsNo,@balance)
GO
/****** Object:  Table [dbo].[User]    Script Date: 24.11.2019 09:53:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HgsNo] [bigint] NOT NULL,
	[balance] [money] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
SET IDENTITY_INSERT [dbo].[User] ON 

INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (1, 1000, 12.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (2, 1001, 3359.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (3, 1002, 12.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (4, 1003, 12.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (5, 1004, 1.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (6, 1005, 10.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (7, 1006, 240.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (8, 1007, 290.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (9, 1008, 240.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (10, 1009, 240.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (11, 1010, 467.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (12, 1011, 100.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (13, 1012, 100.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (14, 1013, 100.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (15, 1014, 24.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (16, 1015, 10.0000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (17, 1016, 2432.7000)
INSERT [dbo].[User] ([Id], [HgsNo], [balance]) VALUES (18, 1017, 22.0000)
SET IDENTITY_INSERT [dbo].[User] OFF
/****** Object:  Index [UQ__User__F267E82424B6DD02]    Script Date: 24.11.2019 09:53:38 ******/
ALTER TABLE [dbo].[User] ADD UNIQUE NONCLUSTERED 
(
	[HgsNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
