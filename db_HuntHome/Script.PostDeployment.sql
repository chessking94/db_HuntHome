/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

USE HuntHome
GO

--set the owner
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'database_owner' AND type_desc = 'SQL_LOGIN')
BEGIN
	RAISERROR('The user "database_owner" does not exist', 16, 1)
	RETURN
END

EXEC sp_changedbowner 'database_owner'

--set permissions for other logins
----automation_user
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'automation_user' AND type_desc = 'SQL_LOGIN')
BEGIN
	RAISERROR('The user "automation_user" does not exist', 16, 1)
	RETURN
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'automation_user')
BEGIN
	CREATE USER [automation_user] FOR LOGIN [automation_user] WITH DEFAULT_SCHEMA = [dbo]
END

ALTER ROLE [db_datareader] ADD MEMBER [automation_user]
ALTER ROLE [db_datawriter] ADD MEMBER [automation_user]
ALTER ROLE [db_executor] ADD MEMBER [automation_user]

----job_owner
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'job_owner' AND type_desc = 'SQL_LOGIN')
BEGIN
	RAISERROR('The user "job_owner" does not exist', 16, 1)
	RETURN
END

IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'job_owner')
BEGIN
	CREATE USER [job_owner] FOR LOGIN [job_owner] WITH DEFAULT_SCHEMA = [dbo]
END

ALTER ROLE [db_datareader] ADD MEMBER [job_owner]
ALTER ROLE [db_datawriter] ADD MEMBER [job_owner]
ALTER ROLE [db_executor] ADD MEMBER [job_owner]
ALTER ROLE [db_ddladmin] ADD MEMBER [job_owner]
ALTER ROLE [db_backupoperator] ADD MEMBER [job_owner]

/* Insert seed data */
--Schema: dbo
----Table: ApplicationType
SET IDENTITY_INSERT dbo.ApplicationType ON

INSERT INTO dbo.ApplicationType (ID, Name, Description, IsActive)
SELECT v.LevelID, v.Level
FROM 
(
    VALUES
        (1, 'Python Script', NULL, 1),
		(2, 'Batch Script', NULL, 1),
		(3, 'Executable', NULL, 1),
		(4, 'SQL Query', NULL, 1)
) AS v (ID, Name, Description, IsActive)
WHERE NOT EXISTS (SELECT 1 FROM dbo.ApplicationType AS a WHERE a.ID = v.ID)

SET IDENTITY_INSERT dbo.ApplicationType OFF

--Schema: logs
----Table: Levels
SET IDENTITY_INSERT logs.Levels ON

INSERT INTO logs.Levels (LevelID, Level)
SELECT v.LevelID, v.Level
FROM 
(
    VALUES
        (1, 'DEBUG'),
		(2, 'INFO'),
		(3, 'WARNING'),
		(4, 'ERROR'),
		(5, 'CRITICAL')
) AS v (LevelID, Level)
WHERE NOT EXISTS (SELECT 1 FROM logs.Levels AS a WHERE a.LevelID = v.LevelID)

SET IDENTITY_INSERT logs.Levels OFF
