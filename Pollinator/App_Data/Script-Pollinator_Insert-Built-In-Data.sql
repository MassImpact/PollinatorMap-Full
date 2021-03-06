USE [Pollinator]


GO
/****** Object:  Table [dbo].[Applications]    Script Date: 9/3/2014 3:35:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

GO
INSERT [dbo].[Applications] ([ApplicationName], [ApplicationId], [Description]) VALUES (N'/', N'1c16d1b8-221e-43c1-9f28-505934a64e0a', NULL)
GO
INSERT [dbo].[Country] ([ID], [Name], [SortOder]) VALUES (N'BRA', N'Brazil', 3)
GO
INSERT [dbo].[Country] ([ID], [Name], [SortOder]) VALUES (N'CA', N'Canada', 2)
GO
INSERT [dbo].[Country] ([ID], [Name], [SortOder]) VALUES (N'FR', N'France', 4)
GO
INSERT [dbo].[Country] ([ID], [Name], [SortOder]) VALUES (N'NONE', N'Other', 999)
GO
INSERT [dbo].[Country] ([ID], [Name], [SortOder]) VALUES (N'UK', N'United Kingdom', 5)
GO
INSERT [dbo].[Country] ([ID], [Name], [SortOder]) VALUES (N'USA', N'USA', 1)

GO
SET IDENTITY_INSERT [dbo].[PollinatorSize] ON 

GO
INSERT [dbo].[PollinatorSize] ([ID], [Name]) VALUES (1, N'Small planter or balcony (30 square feet or less)')
GO
INSERT [dbo].[PollinatorSize] ([ID], [Name]) VALUES (2, N'Small garden (30 to 100 square feet)')
GO
INSERT [dbo].[PollinatorSize] ([ID], [Name]) VALUES (3, N'Large garden (100 to 1000 square feet)')
GO
INSERT [dbo].[PollinatorSize] ([ID], [Name]) VALUES (4, N'Small Yard (1000 to 5000 square feet)')
GO
INSERT [dbo].[PollinatorSize] ([ID], [Name]) VALUES (5, N'Medium Yard (1/2 Acre or less)')
GO
INSERT [dbo].[PollinatorSize] ([ID], [Name]) VALUES (6, N'Large Yard (1 Acre or less)')
GO
INSERT [dbo].[PollinatorSize] ([ID], [Name]) VALUES (7, N'Field (1 to 5 Acres)')
GO
INSERT [dbo].[PollinatorSize] ([ID], [Name]) VALUES (8, N'Large Field (5 to 10 Acres)')
GO
INSERT [dbo].[PollinatorSize] ([ID], [Name]) VALUES (9, N'I Dont Know')
GO
SET IDENTITY_INSERT [dbo].[PollinatorSize] OFF
GO
SET IDENTITY_INSERT [dbo].[PollinatorType] ON 

GO
INSERT [dbo].[PollinatorType] ([ID], [Name]) VALUES (1, N'Home Garden')
GO
INSERT [dbo].[PollinatorType] ([ID], [Name]) VALUES (2, N'School')
GO
INSERT [dbo].[PollinatorType] ([ID], [Name]) VALUES (3, N'Farm')
GO
INSERT [dbo].[PollinatorType] ([ID], [Name]) VALUES (4, N'Government')
GO
INSERT [dbo].[PollinatorType] ([ID], [Name]) VALUES (5, N'Rights of Way (ROW)')
GO
INSERT [dbo].[PollinatorType] ([ID], [Name]) VALUES (6, N'Church')
GO
INSERT [dbo].[PollinatorType] ([ID], [Name]) VALUES (7, N'Corporation')
GO
INSERT [dbo].[PollinatorType] ([ID], [Name]) VALUES (8, N'Nonprofit')
GO
INSERT [dbo].[PollinatorType] ([ID], [Name]) VALUES (9, N'Other')
GO
SET IDENTITY_INSERT [dbo].[PollinatorType] OFF
GO

--[dbo].[Roles] 
INSERT [dbo].[Roles] ([ApplicationId], [RoleId], [RoleName], [Description]) VALUES (N'1c16d1b8-221e-43c1-9f28-505934a64e0a', N'b30bff48-a102-4b3d-9d5a-e41fcb47bb56', N'Administrator', NULL)
GO
INSERT [dbo].[Roles] ([ApplicationId], [RoleId], [RoleName], [Description]) VALUES (N'1c16d1b8-221e-43c1-9f28-505934a64e0a', N'30084fff-7a4a-4750-9527-f9a7637a783c', N'Members', NULL)
GO

--[dbo].[Users] for 'Admin' N'abae8056-844f-401c-a207-34bca7a243a4'
GO
INSERT [dbo].[Users] ([ApplicationId], [UserId], [UserName], [IsAnonymous], [LastActivityDate]) VALUES (N'1c16d1b8-221e-43c1-9f28-505934a64e0a', N'abae8056-844f-401c-a207-34bca7a243a4', N'admin', 0, CAST(0x0000A39600B4BDA4 AS DateTime))

--[dbo].[UsersInRoles] - for Adimin
GO
INSERT [dbo].[UsersInRoles] ([UserId], [RoleId]) VALUES (N'abae8056-844f-401c-a207-34bca7a243a4', N'b30bff48-a102-4b3d-9d5a-e41fcb47bb56')
Go

-- [dbo].[Memberships] for Admin
INSERT [dbo].[Memberships] ([ApplicationId], [UserId], [Password], [PasswordFormat], [PasswordSalt], [Email], [PasswordQuestion], [PasswordAnswer], [IsApproved], [IsLockedOut], [CreateDate], [LastLoginDate], [LastPasswordChangedDate], [LastLockoutDate], [FailedPasswordAttemptCount], [FailedPasswordAttemptWindowStart], [FailedPasswordAnswerAttemptCount], [FailedPasswordAnswerAttemptWindowsStart], [Comment]) VALUES (N'1c16d1b8-221e-43c1-9f28-505934a64e0a', N'abae8056-844f-401c-a207-34bca7a243a4', N'ljvFlt/hWmebtL7JNvqxdQHmeQeRrAb7Kq2XHmk4EE8=', 1, N'8kvwmBlViZ6gi8u3t+HxiA==', N'vinh.ngo@evizi.com', N'Question', N'WFDRHWQR7diUKRGzvLnvu+1qt5ZhAzf0BfH/Yq/CVok=', 1, 0, CAST(0x0000A3420052067C AS DateTime), CAST(0x0000A39600B4BDA4 AS DateTime), CAST(0x0000A3420052067C AS DateTime), CAST(0xFFFF2FB300000000 AS DateTime), 0, CAST(0xFFFF2FB300000000 AS DateTime), 0, CAST(0xFFFF2FB300000000 AS DateTime), NULL)

GO
