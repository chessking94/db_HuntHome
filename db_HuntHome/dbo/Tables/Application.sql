CREATE TABLE [dbo].[Application]
(
    [ID] SMALLINT IDENTITY(1,1) NOT NULL
    ,[ApplicationTypeID] TINYINT NOT NULL
    ,[Name] VARCHAR(200) NOT NULL
    ,[Description] VARCHAR(1000) NULL
    ,[IsActive] BIT CONSTRAINT [DF_Application_IsActive] DEFAULT (1) NOT NULL
    ,[CreatedDate] DATETIME2(3) CONSTRAINT [DF_Application_CreatedDate] DEFAULT (SYSDATETIME()) NOT NULL
    ,[ModifiedDate] DATETIME2(3) CONSTRAINT [DF_Application_ModifiedDate] DEFAULT (SYSDATETIME()) NOT NULL
    ,CONSTRAINT [PK_Application] PRIMARY KEY CLUSTERED ([ID] ASC)
    ,CONSTRAINT [FK_Application_ApplicationType] FOREIGN KEY ([ApplicationTypeID]) REFERENCES [dbo].[ApplicationType]([ID])
    ,CONSTRAINT [UC_Application_Name] UNIQUE NONCLUSTERED ([Name] ASC)
)
