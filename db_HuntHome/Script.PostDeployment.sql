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
--Schema: sftp
----Table: LoginTypes
SET IDENTITY_INSERT sftp.LoginTypes ON

INSERT INTO sftp.LoginTypes (LoginTypeID, LoginType)
SELECT '1', 'Password'
WHERE NOT EXISTS (SELECT LoginTypeID FROM sftp.LoginTypes WHERE LoginTypeID = '1')

INSERT INTO sftp.LoginTypes (LoginTypeID, LoginType)
SELECT '2', 'Public Key'
WHERE NOT EXISTS (SELECT LoginTypeID FROM sftp.LoginTypes WHERE LoginTypeID = '2')

INSERT INTO sftp.LoginTypes (LoginTypeID, LoginType)
SELECT '3', 'Password or Public Key'
WHERE NOT EXISTS (SELECT LoginTypeID FROM sftp.LoginTypes WHERE LoginTypeID = '3')

INSERT INTO sftp.LoginTypes (LoginTypeID, LoginType)
SELECT '4', 'Password and Public Key'
WHERE NOT EXISTS (SELECT LoginTypeID FROM sftp.LoginTypes WHERE LoginTypeID = '4')

SET IDENTITY_INSERT sftp.LoginTypes OFF


----Table: Directions
INSERT INTO sftp.Directions (Direction, DirectionDescription)
SELECT 'I', 'Incoming'
WHERE NOT EXISTS (SELECT Direction FROM sftp.Directions WHERE Direction = 'I')

INSERT INTO sftp.Directions (Direction, DirectionDescription)
SELECT 'O', 'Outgoing'
WHERE NOT EXISTS (SELECT Direction FROM sftp.Directions WHERE Direction = 'O')


----Table: Directories
SET IDENTITY_INSERT sftp.Directories ON

INSERT INTO sftp.Directories (DirectoryID, DirectoryPath, Direction)
SELECT '1', '/ToHuntHome', 'I'
WHERE NOT EXISTS (SELECT DirectoryID FROM sftp.Directories WHERE DirectoryID = '1')

INSERT INTO sftp.Directories (DirectoryID, DirectoryPath, Direction)
SELECT '2', '/FromHuntHome', 'O'
WHERE NOT EXISTS (SELECT DirectoryID FROM sftp.Directories WHERE DirectoryID = '2')

SET IDENTITY_INSERT sftp.Directories OFF



--Schema: logs
----Table: Levels
SET IDENTITY_INSERT logs.Levels ON

INSERT INTO logs.Levels (LevelID, Level)
SELECT '1', 'DEBUG'
WHERE NOT EXISTS (SELECT LevelID FROM logs.Levels WHERE LevelID = '1')

INSERT INTO logs.Levels (LevelID, Level)
SELECT '2', 'INFO'
WHERE NOT EXISTS (SELECT LevelID FROM logs.Levels WHERE LevelID = '2')

INSERT INTO logs.Levels (LevelID, Level)
SELECT '3', 'WARNING'
WHERE NOT EXISTS (SELECT LevelID FROM logs.Levels WHERE LevelID = '3')

INSERT INTO logs.Levels (LevelID, Level)
SELECT '4', 'ERROR'
WHERE NOT EXISTS (SELECT LevelID FROM logs.Levels WHERE LevelID = '4')

INSERT INTO logs.Levels (LevelID, Level)
SELECT '5', 'CRITICAL'
WHERE NOT EXISTS (SELECT LevelID FROM logs.Levels WHERE LevelID = '5')

SET IDENTITY_INSERT logs.Levels OFF



--Schema: storage
----Table: MachineTypes
SET IDENTITY_INSERT storage.MachineTypes ON

INSERT INTO storage.MachineTypes (MachineTypeID, MachineType)
SELECT '1', 'Host'
WHERE NOT EXISTS (SELECT MachineTypeID FROM storage.MachineTypes WHERE MachineTypeID = '1')

INSERT INTO storage.MachineTypes (MachineTypeID, MachineType)
SELECT '2', 'Virtual'
WHERE NOT EXISTS (SELECT MachineTypeID FROM storage.MachineTypes WHERE MachineTypeID = '2')

SET IDENTITY_INSERT storage.MachineTypes OFF


----Table: Machines
INSERT INTO storage.Machines (MachineID, MachineTypeID, HostMachine)
SELECT 'PCSP-JVBBGB2', 1, NULL
WHERE NOT EXISTS (SELECT MachineID FROM storage.Machines WHERE MachineID = 'PCSP-JVBBGB2')

INSERT INTO storage.Machines (MachineID, MachineTypeID, HostMachine)
SELECT 'HUNT-PC1', 1, NULL
WHERE NOT EXISTS (SELECT MachineID FROM storage.Machines WHERE MachineID = 'HUNT-PC1')

