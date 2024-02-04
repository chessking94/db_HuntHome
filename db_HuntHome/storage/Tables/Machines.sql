CREATE TABLE [storage].[Machines]
(
	[MachineID] VARCHAR(20) NOT NULL,
	[MachineTypeID] tinyint NOT NULL,
	[HostMachine] VARCHAR(20),
	CONSTRAINT PK_storageMachines_MachineID PRIMARY KEY (MachineID),
	CONSTRAINT FK_storageMachines_HostMachine FOREIGN KEY (HostMachine) REFERENCES storage.Machines(MachineID)
)
