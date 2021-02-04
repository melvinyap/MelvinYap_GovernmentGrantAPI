USE [HouseholdsDb]
GO

/****** Object:  Table [dbo].[Household]    Script Date: 4/2/2021 1:39:42 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Household](
	[HouseholdId] [int] IDENTITY(1,1) NOT NULL,
	[HousingType] [varchar](15) NOT NULL,
 CONSTRAINT [PK_Household] PRIMARY KEY CLUSTERED 
(
	[HouseholdId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FamilyMember]
DROP CONSTRAINT [FK_FamilyMember_ToHousehold];

TRUNCATE TABLE [dbo].[Household];

INSERT INTO [dbo].[Household]
           ([HousingType])
     VALUES
           ('HDB');

INSERT INTO [dbo].[Household]
           ([HousingType])
     VALUES
           ('HDB');

INSERT INTO [dbo].[Household]
           ([HousingType])
     VALUES
           ('HDB');

INSERT INTO [dbo].[Household]
           ([HousingType])
     VALUES
           ('Condominium');

INSERT INTO [dbo].[Household]
           ([HousingType])
     VALUES
           ('Condominium');

INSERT INTO [dbo].[Household]
           ([HousingType])
     VALUES
           ('Landed');

GO

ALTER TABLE [dbo].[FamilyMember]  WITH CHECK ADD  CONSTRAINT [FK_FamilyMember_ToHousehold] FOREIGN KEY([HouseholdId])
REFERENCES [dbo].[Household] ([HouseholdId]);
GO

ALTER TABLE [dbo].[FamilyMember] CHECK CONSTRAINT [FK_FamilyMember_ToHousehold];
GO

SELECT * FROM [dbo].[Household];