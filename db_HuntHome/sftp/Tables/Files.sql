CREATE TABLE [sftp].[Files] (
    [SftpID]      INT           IDENTITY (1, 1) NOT NULL,
    [CreateDate]  DATETIME      CONSTRAINT [DF_sftpFiles_CreateDate] DEFAULT (getdate()) NOT NULL,
    [Username]    VARCHAR (30)  NOT NULL,
    [DirectoryID] TINYINT       NOT NULL,
    [Filename]    VARCHAR (100) NOT NULL,
    CONSTRAINT [PK_sftpFiles_SftpID] PRIMARY KEY CLUSTERED ([SftpID] ASC),
    CONSTRAINT [FK_sftpFiles_SftpDirectories] FOREIGN KEY ([DirectoryID]) REFERENCES [sftp].[Directories] ([DirectoryID]),
    CONSTRAINT [FK_sftpFiles_SftpLogins] FOREIGN KEY ([Username]) REFERENCES [sftp].[Logins] ([Username])
);

