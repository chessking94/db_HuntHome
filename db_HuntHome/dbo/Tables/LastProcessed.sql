CREATE TABLE [dbo].[LastProcessed]
(
	[Database_Name] NVARCHAR(255) NOT NULL,
	[Schema_Name] NVARCHAR(255) NOT NULL,
	[Table_Name] NVARCHAR(255) NOT NULL,
	[Last_ID] INT CONSTRAINT [DF_LProc_LastID] DEFAULT 0 NOT NULL,
	[Update_Date] DATETIME CONSTRAINT [DF_LProc_UpdateDate] DEFAULT GETDATE() NOT NULL,
	CONSTRAINT [PK_LProc] PRIMARY KEY CLUSTERED ([Database_Name] ASC, [Schema_Name] ASC, [Table_Name] ASC)
);

GO
CREATE TRIGGER [dbo].[TRG_LastProcessed_AfterUpdate] ON [dbo].[LastProcessed]
AFTER UPDATE

AS

IF UPDATE(Last_ID)
BEGIN
	UPDATE lp
	SET lp.Update_Date = GETDATE()

	FROM dbo.LastProcessed lp
	JOIN inserted i ON
		lp.[Database_Name] = i.[Database_Name]
		AND lp.[Schema_Name] = i.[Schema_Name]
		AND lp.[Table_Name] = i.[Table_Name]
END;