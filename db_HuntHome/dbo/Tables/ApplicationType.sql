CREATE TABLE [dbo].[ApplicationType] (
    [ID] TINYINT IDENTITY(1,1) NOT NULL
    ,[Name] VARCHAR(100) NOT NULL
    ,[Description] VARCHAR(500) NULL
    ,[IsActive] BIT CONSTRAINT [DF_ApplicationType_IsActive] DEFAULT (1) NOT NULL
    ,CONSTRAINT [PK_ApplicationType] PRIMARY KEY CLUSTERED ([ID] ASC)
    ,CONSTRAINT [UC_ApplicationType_Name] UNIQUE NONCLUSTERED ([Name] ASC )
)
