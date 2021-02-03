USE [HouseholdsDb]
GO

ALTER TABLE [dbo].[FamilyMember]
DROP CONSTRAINT [FK_FamilyMember_ToHousehold];

TRUNCATE TABLE [dbo].[Household]

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