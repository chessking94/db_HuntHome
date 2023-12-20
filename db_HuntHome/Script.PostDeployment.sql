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
