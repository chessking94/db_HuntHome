CREATE TABLE [sftp].[Directories] (
    [DirectoryID]   TINYINT       IDENTITY (1, 1) NOT NULL,
    [DirectoryPath] VARCHAR (200) NOT NULL,
    [Direction]     CHAR (1)      NOT NULL,
    CONSTRAINT [PK_sftpDirectories_DirectoryID] PRIMARY KEY CLUSTERED ([DirectoryID] ASC),
    CONSTRAINT [FK_sftpDirectories_Direction] FOREIGN KEY ([Direction]) REFERENCES [sftp].[Directions] ([Direction]),
    CONSTRAINT [UC_sftpDirectories_DirectoryPath] UNIQUE NONCLUSTERED ([DirectoryPath] ASC)
);

