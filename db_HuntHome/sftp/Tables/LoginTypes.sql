CREATE TABLE [sftp].[LoginTypes] (
    [LoginTypeID] TINYINT      IDENTITY (1, 1) NOT NULL,
    [LoginType]   VARCHAR (25) NOT NULL,
    CONSTRAINT [PK_sftpLoginTypes_LoginTypeID] PRIMARY KEY CLUSTERED ([LoginTypeID] ASC)
);

