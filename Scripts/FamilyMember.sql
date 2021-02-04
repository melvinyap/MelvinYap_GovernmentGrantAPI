USE [HouseholdsDb]
GO

/****** Object:  Table [dbo].[FamilyMember]    Script Date: 4/2/2021 8:24:48 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE [dbo].[FamilyMember];
GO

CREATE TABLE [dbo].[FamilyMember](
	[MemberId] [int] IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NOT NULL,
	[Gender] [varchar](10) NOT NULL,
	[MaritalStatus] [varchar](10) NOT NULL,
	[SpouseName] [varchar](50) NULL,
	[OccupationType] [varchar](10) NOT NULL,
	[AnnualIncome] [money] NULL,
	[DOB] [date] NOT NULL,
	[HouseholdId] [int] NULL,
 CONSTRAINT [PK_FamilyMember1] PRIMARY KEY CLUSTERED 
(
	[MemberId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('John Tan'
           ,'Male'
           ,'Married'
           ,'Jane Lim'
           ,'Employed'
           ,90000
           ,'1-Feb-1994'
           ,1);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Jane Lim'
           ,'Female'
           ,'Married'
           ,'John Tan'
           ,'Unemployed'
           ,null
           ,'23-Jun-1995'
           ,1);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Caden Tan'
           ,'Male'
           ,'Single'
           , NULL
           ,'Unemployed'
           , NULL
           ,'12-Apr-2020'
           ,1);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Teo Boon Hwee'
           ,'Male'
           ,'Married'
           ,'Chua Ai Ling'
           ,'Employed'
           ,55000
           ,'21-Oct-1983'
           ,2);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Chua Ai Ling'
           ,'Female'
           ,'Married'
           ,'Teo Boon Hwee'
           ,'Employed'
           ,40000
           ,'10-Sep-1987'
           ,2);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Lim Siew Mui'
           ,'Female'
           ,'Widowed'
           ,'Teo Kim Soon'
           ,'Unemployed'
           ,null
           ,'11-Aug-1965'
           ,3);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Justin Ong'
           ,'Male'
           ,'Married'
           ,'Ang Li Peng'
           ,'Employed'
           ,120000
           ,'11-Jan-1990'
           ,3);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Ang Li Peng'
           ,'Feale'
           ,'Married'
           ,'Justin Ong'
           ,'Employed'
           ,98000
           ,'24-Apr-1989'
           ,3);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Clarissa Ong'
           ,'Female'
           ,'Single'
           ,null
           ,'Student'
           ,null
           ,'13-Jan-2014'
           ,3);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Caden Ong'
           ,'Male'
           ,'Single'
           ,null
           ,'Student'
           ,null
           ,'5-Mar-2018'
           ,3);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Kelvin Chew'
           ,'Male'
           ,'Divorced'
           ,'Goh Aileen'
           ,'Employed'
           ,200000
           ,'1-Feb-1971'
           ,4);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Lee Hui Ling'
           ,'Female'
           ,'Single'
           ,null
           ,'Employed'
           ,70000
           ,'10-Sep-1987'
           ,4);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Goh Soon Lee'
           ,'Male'
           ,'Married'
           ,'Judy Chua'
           ,'Employed'
           ,250000
           ,'1-Dec-1969'
           ,5);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Judy Chua'
           ,'Female'
           ,'Married'
           ,'Goh Soon Lee'
           ,'Unemployed'
           ,null
           ,'19-Nov-1972'
           ,5);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Sophie Goh'
           ,'Female'
           ,'Single'
           ,null
           ,'Unemployed'
           ,null
           ,'16-Sep-1999'
           ,5);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Shawn Goh'
           ,'Male'
           ,'Single'
           ,null
           ,'Student'
           ,null
           ,'22-Apr-2004'
           ,5);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Lim Kim Teck'
           ,'Male'
           ,'Married'
           ,'Ong Keng Mui'
           ,'Employed'
           ,300000
           ,'12-Dec-1964'
           ,6);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Ong Keng Mui'
           ,'Female'
           ,'Married'
           ,'Lim Kim Teck'
           ,'Unemployed'
           ,null
           ,'1-Jun-1968'
           ,6);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Darren Lim'
           ,'Male'
           ,'Married'
           ,'Lisa Wong'
           ,'Employed'
           ,190000
           ,'15-Jun-1986'
           ,6);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Lisa Wong'
           ,'Female'
           ,'Married'
           ,'Darren Lim'
           ,'Employed'
           ,105000
           ,'1-Feb-1994'
           ,6);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('David Lim'
           ,'Male'
           ,'Single'
           ,null
           ,'Employed'
           ,290000
           ,'17-May-1990'
           ,6);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Mark Lim'
           ,'Male'
           ,'Single'
           ,null
           ,'Student'
           ,null
           ,'23-Oct-2008'
           ,6);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Joshua Lim'
           ,'Male'
           ,'Single'
           ,null
           ,'Student'
           ,null
           ,'11-Apr-2010'
           ,6);

INSERT INTO [dbo].[FamilyMember]
           ([Name]
           ,[Gender]
           ,[MaritalStatus]
           ,[SpouseName]
           ,[OccupationType]
           ,[AnnualIncome]
           ,[DOB]
           ,[HouseholdId])
     VALUES
           ('Jessica Lim'
           ,'Female'
           ,'Single'
           ,null
           ,'Student'
           ,null
           ,'31-Jul-2012'
           ,6);
GO

SELECT * FROM [dbo].[FamilyMember]
