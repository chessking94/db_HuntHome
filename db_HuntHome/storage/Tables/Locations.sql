CREATE TABLE [storage].[Locations]
(
	[LocationID] SMALLINT IDENTITY(1,1) NOT NULL,
	[MachineID] VARCHAR(20) NOT NULL,
	[RootPath] VARCHAR(50) NOT NULL,
	CONSTRAINT PK_storageLocations_LocationID PRIMARY KEY (LocationID),
	CONSTRAINT FK_storageLocation_MachineID FOREIGN KEY (MachineID) REFERENCES storage.Machines(MachineID),
	CONSTRAINT UC_storageLocations_MachineRoots UNIQUE (MachineID, RootPath)
)
