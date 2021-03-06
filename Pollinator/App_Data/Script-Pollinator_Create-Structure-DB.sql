USE [Pollinator]

GO
IF  EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'UserDetail', N'COLUMN',N'MembershipLevel'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserDetail', @level2type=N'COLUMN',@level2name=N'MembershipLevel'

GO
IF  EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'TempUserPayment', N'COLUMN',N'MembershipLevel'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TempUserPayment', @level2type=N'COLUMN',@level2name=N'MembershipLevel'

GO
IF  EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'PolinatorInformation', N'COLUMN',N'IsPaid'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PolinatorInformation', @level2type=N'COLUMN',@level2name=N'IsPaid'

GO
IF  EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'PolinatorInformation', N'COLUMN',N'IsApproved'))
EXEC sys.sp_dropextendedproperty @name=N'MS_Description' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PolinatorInformation', @level2type=N'COLUMN',@level2name=N'IsApproved'

GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[OpenAuthAccount_UserData]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersOpenAuthAccounts]'))
ALTER TABLE [dbo].[UsersOpenAuthAccounts] DROP CONSTRAINT [OpenAuthAccount_UserData]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UsersInRoleUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersInRoles]'))
ALTER TABLE [dbo].[UsersInRoles] DROP CONSTRAINT [UsersInRoleUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UsersInRoleRole]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersInRoles]'))
ALTER TABLE [dbo].[UsersInRoles] DROP CONSTRAINT [UsersInRoleRole]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UserApplication]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users] DROP CONSTRAINT [UserApplication]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[RoleApplication]') AND parent_object_id = OBJECT_ID(N'[dbo].[Roles]'))
ALTER TABLE [dbo].[Roles] DROP CONSTRAINT [RoleApplication]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UserProfile]') AND parent_object_id = OBJECT_ID(N'[dbo].[Profiles]'))
ALTER TABLE [dbo].[Profiles] DROP CONSTRAINT [UserProfile]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PolinatorInformation_PollinatorSize]') AND parent_object_id = OBJECT_ID(N'[dbo].[PolinatorInformation]'))
ALTER TABLE [dbo].[PolinatorInformation] DROP CONSTRAINT [FK_PolinatorInformation_PollinatorSize]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[MembershipUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[Memberships]'))
ALTER TABLE [dbo].[Memberships] DROP CONSTRAINT [MembershipUser]
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[MembershipApplication]') AND parent_object_id = OBJECT_ID(N'[dbo].[Memberships]'))
ALTER TABLE [dbo].[Memberships] DROP CONSTRAINT [MembershipApplication]
GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserDetails_LevelUser]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserDetail] DROP CONSTRAINT [DF_UserDetails_LevelUser]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_TempUserPayment_MembershipLevel]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TempUserPayment] DROP CONSTRAINT [DF_TempUserPayment_MembershipLevel]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PolinatorInformation_LastUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PolinatorInformation] DROP CONSTRAINT [DF_PolinatorInformation_LastUpdated]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PolinatorInformation_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PolinatorInformation] DROP CONSTRAINT [DF_PolinatorInformation_CreatedDate]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PolinatorInformation_IsNew_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PolinatorInformation] DROP CONSTRAINT [DF_PolinatorInformation_IsNew_1]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PolinatorInformation_IsApproved]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PolinatorInformation] DROP CONSTRAINT [DF_PolinatorInformation_IsApproved]
END

GO
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentInformation_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentInformation] DROP CONSTRAINT [DF_PaymentInformation_CreateDate]
END

GO
/****** Object:  Table [dbo].[UsersOpenAuthData]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsersOpenAuthData]') AND type in (N'U'))
DROP TABLE [dbo].[UsersOpenAuthData]
GO
/****** Object:  Table [dbo].[UsersOpenAuthAccounts]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsersOpenAuthAccounts]') AND type in (N'U'))
DROP TABLE [dbo].[UsersOpenAuthAccounts]
GO
/****** Object:  Table [dbo].[UsersInRoles]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsersInRoles]') AND type in (N'U'))
DROP TABLE [dbo].[UsersInRoles]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
DROP TABLE [dbo].[Users]
GO
/****** Object:  Table [dbo].[UserDetail]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserDetail]') AND type in (N'U'))
DROP TABLE [dbo].[UserDetail]
GO
/****** Object:  Table [dbo].[TempUserPayment]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempUserPayment]') AND type in (N'U'))
DROP TABLE [dbo].[TempUserPayment]
GO
/****** Object:  Table [dbo].[Sponsor]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sponsor]') AND type in (N'U'))
DROP TABLE [dbo].[Sponsor]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Roles]') AND type in (N'U'))
DROP TABLE [dbo].[Roles]
GO
/****** Object:  Table [dbo].[Profiles]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Profiles]') AND type in (N'U'))
DROP TABLE [dbo].[Profiles]
GO
/****** Object:  Table [dbo].[PollinatorType]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PollinatorType]') AND type in (N'U'))
DROP TABLE [dbo].[PollinatorType]
GO
/****** Object:  Table [dbo].[PollinatorSize]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PollinatorSize]') AND type in (N'U'))
DROP TABLE [dbo].[PollinatorSize]
GO
/****** Object:  Table [dbo].[PolinatorInformation]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PolinatorInformation]') AND type in (N'U'))
DROP TABLE [dbo].[PolinatorInformation]
GO
/****** Object:  Table [dbo].[PaymentInformation]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentInformation]') AND type in (N'U'))
DROP TABLE [dbo].[PaymentInformation]
GO
/****** Object:  Table [dbo].[Memberships]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Memberships]') AND type in (N'U'))
DROP TABLE [dbo].[Memberships]
GO
/****** Object:  Table [dbo].[Log]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Log]') AND type in (N'U'))
DROP TABLE [dbo].[Log]
GO
/****** Object:  Table [dbo].[Country]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
DROP TABLE [dbo].[Country]
GO
/****** Object:  Table [dbo].[Applications]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Applications]') AND type in (N'U'))
DROP TABLE [dbo].[Applications]
GO
/****** Object:  StoredProcedure [dbo].[sp_Log4Net_Insert_Log]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_Log4Net_Insert_Log]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_Log4Net_Insert_Log]
GO
/****** Object:  User [pollinatorsql]    Script Date: 9/3/2014 4:52:23 PM ******/
IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'pollinatorsql')
DROP USER [pollinatorsql]
GO
/****** Object:  User [pollinatorsql]    Script Date: 9/3/2014 4:52:23 PM ******/
--IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'pollinatorsql')
--CREATE USER [pollinatorsql] FOR LOGIN [pollinatorsql] WITH DEFAULT_SCHEMA=[dbo]
--GO
--ALTER ROLE [db_owner] ADD MEMBER [pollinatorsql]
--GO
--ALTER ROLE [db_accessadmin] ADD MEMBER [pollinatorsql]
--GO
--ALTER ROLE [db_securityadmin] ADD MEMBER [pollinatorsql]
--GO
--ALTER ROLE [db_ddladmin] ADD MEMBER [pollinatorsql]
--GO
--ALTER ROLE [db_backupoperator] ADD MEMBER [pollinatorsql]
--GO
--ALTER ROLE [db_datareader] ADD MEMBER [pollinatorsql]
--GO
--ALTER ROLE [db_datawriter] ADD MEMBER [pollinatorsql]
--GO
--ALTER ROLE [db_denydatareader] ADD MEMBER [pollinatorsql]
--GO
--ALTER ROLE [db_denydatawriter] ADD MEMBER [pollinatorsql]
--GO
--/****** Object:  StoredProcedure [dbo].[sp_Log4Net_Insert_Log]    Script Date: 9/3/2014 4:52:23 PM ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_Log4Net_Insert_Log]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[sp_Log4Net_Insert_Log]
	-- Add the parameters for the stored procedure here
	@LogDate datetime,
	@Thread nvarchar(255),
	@LogLevel nvarchar(50),
	@Logger nvarchar(255),
    @User varchar(50),
	@LogMessage nvarchar(max),
	@Exception nvarchar(max),
	@Application nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	INSERT INTO [Log]
		(
			 LogDate
			,Thread
			,LogLevel
			,Logger
			,[User]
			,LogMessage
			,Exception
			,[Application]
		)
	VALUES
		(
			 @LogDate
			,@Thread
			,@LogLevel
			,@Logger
			,@User
			,@LogMessage
			,@Exception
			,@Application
		)
END
' 
END
GO
/****** Object:  Table [dbo].[Applications]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Applications]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Applications](
	[ApplicationName] [nvarchar](235) NOT NULL,
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[ApplicationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Country]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Country](
	[ID] [varchar](5) NOT NULL,
	[Name] [nvarchar](100) NULL,
	[SortOder] [int] NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Log]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Log]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Log](
	[LogId] [int] IDENTITY(1,1) NOT NULL,
	[LogDate] [datetime] NOT NULL,
	[Thread] [varchar](255) NOT NULL,
	[LogLevel] [varchar](50) NOT NULL,
	[Logger] [varchar](255) NOT NULL,
	[User] [varchar](50) NULL,
	[LogMessage] [varchar](4000) NOT NULL,
	[Exception] [varchar](2000) NULL,
	[Application] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Log4Net] PRIMARY KEY CLUSTERED 
(
	[LogId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Memberships]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Memberships]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Memberships](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Password] [nvarchar](128) NOT NULL,
	[PasswordFormat] [int] NOT NULL,
	[PasswordSalt] [nvarchar](128) NOT NULL,
	[Email] [nvarchar](256) NULL,
	[PasswordQuestion] [nvarchar](256) NULL,
	[PasswordAnswer] [nvarchar](128) NULL,
	[IsApproved] [bit] NOT NULL,
	[IsLockedOut] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastLoginDate] [datetime] NOT NULL,
	[LastPasswordChangedDate] [datetime] NOT NULL,
	[LastLockoutDate] [datetime] NOT NULL,
	[FailedPasswordAttemptCount] [int] NOT NULL,
	[FailedPasswordAttemptWindowStart] [datetime] NOT NULL,
	[FailedPasswordAnswerAttemptCount] [int] NOT NULL,
	[FailedPasswordAnswerAttemptWindowsStart] [datetime] NOT NULL,
	[Comment] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[PaymentInformation]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaymentInformation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaymentInformation](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[txn_id] [varchar](50) NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[pay_stat] [varchar](50) NULL,
	[user_email] [varchar](256) NULL,
	[custom] [varchar](max) NULL,
	[InitialInfoSentByPayPal] [varchar](max) NULL,
	[StrResponse] [varchar](255) NULL,
	[CreateDate] [datetime] NULL,
 CONSTRAINT [PK_PaymentInformation] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PolinatorInformation]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PolinatorInformation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PolinatorInformation](
	[UserId] [uniqueidentifier] NOT NULL,
	[IsApproved] [bit] NULL,
	[IsPaid] [bit] NULL,
	[IsNew] [bit] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[LastUpdated] [datetime] NULL,
	[PaidDate] [datetime] NULL,
	[ExpireDate] [datetime] NULL,
	[OrganizationName] [nvarchar](100) NULL,
	[PollinatorSize] [int] NOT NULL,
	[LandscapeStreet] [nvarchar](100) NOT NULL,
	[LandscapeCity] [nvarchar](50) NOT NULL,
	[LandscapeState] [nvarchar](50) NOT NULL,
	[LandscapeZipcode] [varchar](15) NOT NULL,
	[LandscapeCountry] [nvarchar](50) NULL,
	[PhotoUrl] [nvarchar](max) NULL,
	[YoutubeUrl] [nvarchar](max) NULL,
	[Website] [varchar](255) NULL,
	[PollinatorType] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[BillingAddress] [nvarchar](100) NULL,
	[BillingCity] [nvarchar](50) NULL,
	[BillingState] [nvarchar](50) NULL,
	[BillingZipcode] [varchar](10) NULL,
	[PaymentFullName] [nvarchar](255) NULL,
	[PaymentAddress] [nvarchar](130) NULL,
	[PaymentState] [nvarchar](50) NULL,
	[PaymentCardNumber] [varchar](10) NULL,
	[Latitude] [numeric](18, 15) NULL,
	[Longitude] [numeric](18, 15) NULL,
	[UserFolder] [varchar](50) NULL,
	[FuzyLocation] [bit] NULL,
	[SourceData] [varchar](20) NULL,
 CONSTRAINT [PK_PolinatorInformation] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PollinatorSize]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PollinatorSize]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PollinatorSize](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](60) NULL,
 CONSTRAINT [PK_PollinatorSize] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PollinatorType]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PollinatorType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PollinatorType](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](30) NULL,
 CONSTRAINT [PK_PollinatorType] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Profiles]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Profiles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Profiles](
	[UserId] [uniqueidentifier] NOT NULL,
	[PropertyNames] [nvarchar](4000) NOT NULL,
	[PropertyValueStrings] [nvarchar](4000) NOT NULL,
	[PropertyValueBinary] [image] NOT NULL,
	[LastUpdatedDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Roles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Roles](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](256) NOT NULL,
	[Description] [nvarchar](256) NULL,
PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[Sponsor]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Sponsor]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Sponsor](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](255) NULL,
	[PhotoUrl] [varchar](255) NULL,
	[Website] [varchar](255) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Sponsor] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TempUserPayment]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TempUserPayment]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TempUserPayment](
	[UserId] [uniqueidentifier] NOT NULL,
	[Email] [nvarchar](256) NULL,
	[MembershipLevel] [tinyint] NOT NULL,
	[FirstName] [nvarchar](60) NOT NULL,
	[LastName] [nvarchar](60) NULL,
	[PhoneNumber] [varchar](24) NULL,
	[OrganizationName] [nvarchar](100) NULL,
	[OrganizationName_PollinatorInfomation] [nvarchar](100) NULL,
	[PollinatorSize] [int] NOT NULL,
	[LandscapeStreet] [nvarchar](100) NOT NULL,
	[LandscapeCity] [nvarchar](50) NOT NULL,
	[LandscapeState] [varchar](30) NOT NULL,
	[LandscapeZipcode] [varchar](15) NOT NULL,
	[LandscapeCountry] [nvarchar](50) NULL,
	[PhotoUrl] [nvarchar](max) NULL,
	[YoutubeUrl] [nvarchar](max) NULL,
	[Website] [varchar](255) NULL,
	[PollinatorType] [int] NOT NULL,
	[Description] [nvarchar](max) NULL,
	[BillingAddress] [nvarchar](100) NULL,
	[BillingCity] [nvarchar](50) NULL,
	[BillingState] [nvarchar](50) NULL,
	[BillingZipcode] [varchar](15) NULL,
	[PaymentFullName] [nvarchar](255) NULL,
	[PaymentAddress] [nvarchar](130) NULL,
	[PaymentState] [nvarchar](50) NULL,
	[PaymentCardNumber] [varchar](24) NULL,
	[Latitude] [numeric](18, 15) NULL,
	[Longitude] [numeric](18, 15) NULL,
	[UserFolder] [varchar](50) NULL,
	[CreateDate] [datetime] NULL,
	[CreateProcess] [int] NULL,
	[PaypalFormHtmlStr] [nvarchar](max) NULL,
 CONSTRAINT [PK_TempUserPayment] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserDetail]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UserDetail]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UserDetail](
	[UserId] [uniqueidentifier] NOT NULL,
	[MembershipLevel] [tinyint] NULL,
	[FirstName] [varchar](100) NOT NULL,
	[LastName] [varchar](60) NULL,
	[PhoneNumber] [varchar](24) NULL,
	[OrganizationName] [varchar](100) NULL,
 CONSTRAINT [PK_UserDetails] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Users]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Users](
	[ApplicationId] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[IsAnonymous] [bit] NOT NULL,
	[LastActivityDate] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[UsersInRoles]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsersInRoles]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UsersInRoles](
	[UserId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[UsersOpenAuthAccounts]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsersOpenAuthAccounts]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UsersOpenAuthAccounts](
	[ApplicationName] [nvarchar](128) NOT NULL,
	[ProviderName] [nvarchar](128) NOT NULL,
	[ProviderUserId] [nvarchar](128) NOT NULL,
	[ProviderUserName] [nvarchar](max) NOT NULL,
	[MembershipUserName] [nvarchar](128) NOT NULL,
	[LastUsedUtc] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ApplicationName] ASC,
	[ProviderName] ASC,
	[ProviderUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[UsersOpenAuthData]    Script Date: 9/3/2014 4:52:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[UsersOpenAuthData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[UsersOpenAuthData](
	[ApplicationName] [nvarchar](128) NOT NULL,
	[MembershipUserName] [nvarchar](128) NOT NULL,
	[HasLocalPassword] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ApplicationName] ASC,
	[MembershipUserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PaymentInformation_CreateDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PaymentInformation] ADD  CONSTRAINT [DF_PaymentInformation_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PolinatorInformation_IsApproved]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PolinatorInformation] ADD  CONSTRAINT [DF_PolinatorInformation_IsApproved]  DEFAULT ((0)) FOR [IsApproved]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PolinatorInformation_IsNew_1]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PolinatorInformation] ADD  CONSTRAINT [DF_PolinatorInformation_IsNew_1]  DEFAULT ((1)) FOR [IsNew]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PolinatorInformation_CreatedDate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PolinatorInformation] ADD  CONSTRAINT [DF_PolinatorInformation_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_PolinatorInformation_LastUpdated]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[PolinatorInformation] ADD  CONSTRAINT [DF_PolinatorInformation_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_TempUserPayment_MembershipLevel]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[TempUserPayment] ADD  CONSTRAINT [DF_TempUserPayment_MembershipLevel]  DEFAULT ((0)) FOR [MembershipLevel]
END

GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[DF_UserDetails_LevelUser]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[UserDetail] ADD  CONSTRAINT [DF_UserDetails_LevelUser]  DEFAULT ((0)) FOR [MembershipLevel]
END

GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[MembershipApplication]') AND parent_object_id = OBJECT_ID(N'[dbo].[Memberships]'))
ALTER TABLE [dbo].[Memberships]  WITH CHECK ADD  CONSTRAINT [MembershipApplication] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[MembershipApplication]') AND parent_object_id = OBJECT_ID(N'[dbo].[Memberships]'))
ALTER TABLE [dbo].[Memberships] CHECK CONSTRAINT [MembershipApplication]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[MembershipUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[Memberships]'))
ALTER TABLE [dbo].[Memberships]  WITH CHECK ADD  CONSTRAINT [MembershipUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[MembershipUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[Memberships]'))
ALTER TABLE [dbo].[Memberships] CHECK CONSTRAINT [MembershipUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PolinatorInformation_PollinatorSize]') AND parent_object_id = OBJECT_ID(N'[dbo].[PolinatorInformation]'))
ALTER TABLE [dbo].[PolinatorInformation]  WITH CHECK ADD  CONSTRAINT [FK_PolinatorInformation_PollinatorSize] FOREIGN KEY([PollinatorSize])
REFERENCES [dbo].[PollinatorSize] ([ID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PolinatorInformation_PollinatorSize]') AND parent_object_id = OBJECT_ID(N'[dbo].[PolinatorInformation]'))
ALTER TABLE [dbo].[PolinatorInformation] CHECK CONSTRAINT [FK_PolinatorInformation_PollinatorSize]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UserProfile]') AND parent_object_id = OBJECT_ID(N'[dbo].[Profiles]'))
ALTER TABLE [dbo].[Profiles]  WITH CHECK ADD  CONSTRAINT [UserProfile] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UserProfile]') AND parent_object_id = OBJECT_ID(N'[dbo].[Profiles]'))
ALTER TABLE [dbo].[Profiles] CHECK CONSTRAINT [UserProfile]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[RoleApplication]') AND parent_object_id = OBJECT_ID(N'[dbo].[Roles]'))
ALTER TABLE [dbo].[Roles]  WITH CHECK ADD  CONSTRAINT [RoleApplication] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[RoleApplication]') AND parent_object_id = OBJECT_ID(N'[dbo].[Roles]'))
ALTER TABLE [dbo].[Roles] CHECK CONSTRAINT [RoleApplication]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UserApplication]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [UserApplication] FOREIGN KEY([ApplicationId])
REFERENCES [dbo].[Applications] ([ApplicationId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UserApplication]') AND parent_object_id = OBJECT_ID(N'[dbo].[Users]'))
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [UserApplication]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UsersInRoleRole]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersInRoles]'))
ALTER TABLE [dbo].[UsersInRoles]  WITH CHECK ADD  CONSTRAINT [UsersInRoleRole] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([RoleId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UsersInRoleRole]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersInRoles]'))
ALTER TABLE [dbo].[UsersInRoles] CHECK CONSTRAINT [UsersInRoleRole]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UsersInRoleUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersInRoles]'))
ALTER TABLE [dbo].[UsersInRoles]  WITH CHECK ADD  CONSTRAINT [UsersInRoleUser] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([UserId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[UsersInRoleUser]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersInRoles]'))
ALTER TABLE [dbo].[UsersInRoles] CHECK CONSTRAINT [UsersInRoleUser]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[OpenAuthAccount_UserData]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersOpenAuthAccounts]'))
ALTER TABLE [dbo].[UsersOpenAuthAccounts]  WITH CHECK ADD  CONSTRAINT [OpenAuthAccount_UserData] FOREIGN KEY([ApplicationName], [MembershipUserName])
REFERENCES [dbo].[UsersOpenAuthData] ([ApplicationName], [MembershipUserName])
ON DELETE CASCADE
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[OpenAuthAccount_UserData]') AND parent_object_id = OBJECT_ID(N'[dbo].[UsersOpenAuthAccounts]'))
ALTER TABLE [dbo].[UsersOpenAuthAccounts] CHECK CONSTRAINT [OpenAuthAccount_UserData]
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'PolinatorInformation', N'COLUMN',N'IsApproved'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'is Approved ?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PolinatorInformation', @level2type=N'COLUMN',@level2name=N'IsApproved'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'PolinatorInformation', N'COLUMN',N'IsPaid'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'is paid ?' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PolinatorInformation', @level2type=N'COLUMN',@level2name=N'IsPaid'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'TempUserPayment', N'COLUMN',N'MembershipLevel'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'have 4 level: 0 is free; 1 is premium level 1; 2 is premium level 2; 3 is premium level 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TempUserPayment', @level2type=N'COLUMN',@level2name=N'MembershipLevel'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'UserDetail', N'COLUMN',N'MembershipLevel'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'have 4 level: 0 is free; 1 is premium level 1; 2 is premium level 2; 3 is premium level 3' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'UserDetail', @level2type=N'COLUMN',@level2name=N'MembershipLevel'
GO
