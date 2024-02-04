CREATE TABLE [storage].[MachineTypes]
(
	[MachineTypeID] TINYINT IDENTITY(1,1) NOT NULL,
	[MachineType] VARCHAR(7) NOT NULL,
	CONSTRAINT PK_storageMachineTypes_MachineTypeID PRIMARY KEY (MachineTypeID)
)
