CREATE TABLE [dbo].[LastProcessed]
(
	[Schema_Name] nvarchar(255) NOT NULL,
	[Table_Name] nvarchar(255) NOT NULL,
	[Last_ID] int CONSTRAINT [DF_LProc_LastID] DEFAULT 0 NOT NULL,
	[Update_Date] datetime NULL,
	CONSTRAINT [PK_LProc] PRIMARY KEY CLUSTERED ([Schema_Name] ASC, [Table_Name] ASC)
);
