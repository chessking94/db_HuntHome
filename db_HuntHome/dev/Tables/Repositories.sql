CREATE TABLE [dev].[Repositories]
(
	[RepoName] VARCHAR(50) NOT NULL,
    [AutomatedDeployment] BIT CONSTRAINT [DF_Repositories_AutomatedDeployment] DEFAULT (0) NOT NULL,
    [DeploymentGroup] TINYINT NOT NULL,
    [ProjectFilePath] VARCHAR(100) NOT NULL,
    [GitBranch] VARCHAR(20) NOT NULL,
    [PublishPath] VARCHAR(100) NULL,
    [PostDeployBatchFile] VARCHAR(100) NULL,
    [DeploymentQueued] BIT CONSTRAINT [DF_Repositories_DeploymentQueued] DEFAULT (0) NOT NULL,
    [LastDeployedDate] DATETIME NULL,
    CONSTRAINT PK_Repositories PRIMARY KEY (RepoName)
)
GO
