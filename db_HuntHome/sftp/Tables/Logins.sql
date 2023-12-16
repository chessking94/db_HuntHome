CREATE TABLE [sftp].[Logins] (
    [Username]       VARCHAR (30)  NOT NULL,
    [Active]         BIT           CONSTRAINT [DF_sftpLogins_Active] DEFAULT ((1)) NOT NULL,
    [FirstName]      VARCHAR (20)  NULL,
    [LastName]       VARCHAR (30)  NULL,
    [LoginTypeID]    TINYINT       NOT NULL,
    [HomeDirectory]  VARCHAR (100) NULL,
    [TelegramChatID] VARCHAR (20)  NULL,
    CONSTRAINT [PK_sftpLogins_Username] PRIMARY KEY CLUSTERED ([Username] ASC),
    CONSTRAINT [FK_sftpLogins_SftpLoginTypes] FOREIGN KEY ([LoginTypeID]) REFERENCES [sftp].[LoginTypes] ([LoginTypeID])
);

