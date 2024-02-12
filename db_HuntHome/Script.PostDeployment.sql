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

/* Perform the necessary user/role checks for the pythonuser_dev/pythonuser_prod login */
DECLARE @server varchar(15) = @@SERVERNAME
DECLARE @login_name varchar(25)
DECLARE @xsql nvarchar(500)
DECLARE @login_ct tinyint
DECLARE @user_ct tinyint
DECLARE @role_ct tinyint

--get username for environment and verify it exists on the server
IF @server LIKE '%dev%'
BEGIN
	SET @login_name = 'pythonuser_dev'
END
ELSE
BEGIN
	SET @login_name = 'pythonuser_prod'
END

SET @xsql = 'SELECT @loginctOUT = COUNT(name) FROM sys.server_principals WHERE name = ''' + @login_name + ''' AND type_desc = ''SQL_LOGIN'''
EXEC sp_executesql @xsql, N'@loginctOUT tinyint OUTPUT', @loginctOUT=@login_ct OUTPUT
IF @login_ct = 0
BEGIN
	RAISERROR('The user does not exist', 16, 1)
	RETURN
END

--create user on database if it does not already exist
SET @xsql = 'SELECT @userctOUT = COUNT(name) FROM sys.database_principals WHERE name = ''' + @login_name + ''''
EXEC sp_executesql @xsql, N'@userctOUT tinyint OUTPUT', @userctOUT=@user_ct OUTPUT
IF @user_ct = 0
BEGIN
	SET @xsql = 'CREATE USER [' + @login_name + '] FOR LOGIN [' + @login_name + '] WITH DEFAULT_SCHEMA=[dbo]'
	EXEC sp_executesql @xsql
	PRINT 'User created on database'
END

--the pythonuser_* login should have db_datareader and db_datawriter roles on the database, check if assigned and assign if not
SET @xsql = '
SELECT
@rolectOUT = COUNT(dp2.name)

FROM sys.database_principals AS dp
JOIN sys.database_role_members AS drm ON dp.principal_id = drm.member_principal_id
JOIN sys.database_principals AS dp2 ON drm.role_principal_id = dp2.principal_id

WHERE dp2.name = ''db_datawriter''
AND dp.name = ''' + @login_name + ''''

EXEC sp_executesql @xsql, N'@rolectOUT tinyint OUTPUT', @rolectOUT=@role_ct OUTPUT
IF @role_ct = 0
BEGIN
	--db_datawriter does not exist, add it
	SET @xsql = 'ALTER ROLE [db_datawriter] ADD MEMBER [' + @login_name + ']'
	EXEC sp_executesql @xsql
	PRINT 'Added db_datawriter role to user'
END

SET @xsql = '
SELECT
@rolectOUT = COUNT(dp2.name)

FROM sys.database_principals AS dp
JOIN sys.database_role_members AS drm ON dp.principal_id = drm.member_principal_id
JOIN sys.database_principals AS dp2 ON drm.role_principal_id = dp2.principal_id

WHERE dp2.name = ''db_datareader''
AND dp.name = ''' + @login_name + ''''

EXEC sp_executesql @xsql, N'@rolectOUT tinyint OUTPUT', @rolectOUT=@role_ct OUTPUT
IF @role_ct = 0
BEGIN
	--db_datareader does not exist, add it
	SET @xsql = 'ALTER ROLE [db_datareader] ADD MEMBER [' + @login_name + ']'
	EXEC sp_executesql @xsql
	PRINT 'Added db_datareader role to user'
END


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

