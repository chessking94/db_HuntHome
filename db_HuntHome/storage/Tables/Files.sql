CREATE TABLE [storage].[Files]
(
	[FileID] BIGINT IDENTITY(1,1) NOT NULL,
	[LocationID] SMALLINT NOT NULL,
	[Path] VARCHAR(500) NOT NULL,
	[Filename] VARCHAR(250) NOT NULL,
	[SizeBytes] BIGINT NOT NULL,
	[LastModified] DATETIME NOT NULL,
	[Hash] VARCHAR(MAX),
	CONSTRAINT PK_storageFiles_FileID PRIMARY KEY (FileID),
	CONSTRAINT FK_storageFiles_LocationID FOREIGN KEY (LocationID) REFERENCES storage.Locations(LocationID),
	CONSTRAINT UC_storageFiles_FullFileName UNIQUE (LocationID, Path, Filename)
);


GO
CREATE NONCLUSTERED INDEX [IDX_storageFiles_LocationID]
    ON [storage].[Files]([LocationID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_storageFiles_PathFilename]
    ON [storage].[Files]([Path] ASC, [Filename] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_storageFiles_LastModified]
	ON [storage].[Files]([LastModified] ASC);
