CREATE TABLE [logs].[Entries]
(
	[LogID] INT IDENTITY(1,1) NOT NULL, 
    [DateAdded] DATETIME CONSTRAINT [DF_logsEntries_DateAdded] DEFAULT (GETDATE()) NOT NULL,
    [ScriptName] VARCHAR(50) NOT NULL,
    [FileDate] DATETIME2(0) NOT NULL,
    [ScriptType] VARCHAR(10) NOT NULL,
    [LogDate] DATE NOT NULL, 
    [LogTime] TIME(3) NOT NULL,
    [Function] VARCHAR(50) NULL, 
    [LevelID] TINYINT NOT NULL, 
    [Message] VARCHAR(MAX) NOT NULL,
    CONSTRAINT PK_logsEntries_LogID PRIMARY KEY (LogID),
    CONSTRAINT FK_logsEntries_LevelID FOREIGN KEY (LevelID) REFERENCES logs.Levels(LevelID)
)
GO
