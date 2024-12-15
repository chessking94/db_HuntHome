CREATE TABLE [dev].[RelatedRepositories]
(
	[RepoName] VARCHAR(50) NOT NULL,
	[RelatedRepoName] VARCHAR(50) NOT NULL,
	CONSTRAINT PK_RelatedRepositories PRIMARY KEY (RepoName ASC, RelatedRepoName ASC),
	CONSTRAINT FK_RR_RepoName FOREIGN KEY (RepoName) REFERENCES [dev].[Repositories] (RepoName),
	CONSTRAINT FK_RR_RelatedRepoName FOREIGN KEY (RelatedRepoName) REFERENCES [dev].[Repositories] (RepoName)
)
