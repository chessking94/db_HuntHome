CREATE TABLE [logs].[Levels]
(
	[LevelID] TINYINT IDENTITY(1,1) NOT NULL,
    [Level] VARCHAR(8) NOT NULL,
	CONSTRAINT PK_logsLevels_LevelID PRIMARY KEY (LevelID),
	CONSTRAINT UC_logsLevels_Level UNIQUE (Level)
)
GO