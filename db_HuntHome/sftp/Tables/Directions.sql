CREATE TABLE [sftp].[Directions] (
    [Direction]            CHAR (1)     NOT NULL,
    [DirectionDescription] VARCHAR (20) NOT NULL,
    CONSTRAINT [PK_sftpDirections_Direction] PRIMARY KEY CLUSTERED ([Direction] ASC)
);

