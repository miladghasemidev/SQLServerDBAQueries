-- Full backup
BACKUP DATABASE AdventureWorks2019 TO DISK = 'D:\AdventureWorks2019.bak'
	WITH COMPRESSION, FORMAT, STATS = 1,
	NAME = 'Some_Name', DESCRIPTION = 'Some_Description',
	MEDIANAME = 'Some_Name', MEDIADESCRIPTION = 'Some_Description',
	CHECKSUM, Continue_After_Error,
	BUFFERCOUNT = 1500,
	MAXTRANSFERSIZE=419434,
	BLOCKSIZE = 65536

/*
default option after CHECKSUM is STOP_ON_ERROR mean of checksum is not same as page checksum
it give error and backup is cancel but with Continue_After_Error skip error and countinue to
backup
When create backup chechsum of page is compare with page checksum
*/

/*
-- Belows trace flag show additional information about backup and restore in sql server logs
DBCC TRACEON (3605)
DBCC TRACEON (3213)

-- See error logs content
EXEC xp_ReadErrorLog
GO

-- Close current error log file and create new file 
EXEC sp_cycle_errorlog 
GO
*/

BACKUP DATABASE AdventureWorks2019 TO DISK = 'D:\AdventureWorks2019.bak'
	MIRROR TO DISK = 'E:\AdventureWorks2019.bak'
	WITH COMPRESSION, FORMAT, STATS = 1,
	NAME = 'Some_Name', DESCRIPTION = 'Some_Description',
	MEDIANAME = 'Some_Name', MEDIADESCRIPTION = 'Some_Description',
	CHECKSUM, Continue_After_Error,
	BUFFERCOUNT = 1500,
	MAXTRANSFERSIZE=419434,
	BLOCKSIZE = 65536


-- DIFFERENTIAL backup
BACKUP DATABASE AdventureWorks2019 TO DISK = 'D:\AdventureWorks2019.bak'
	WITH COMPRESSION, FORMAT, STATS = 1,
	NAME = 'Some_Name', DESCRIPTION = 'Some_Description',
	MEDIANAME = 'Some_Name', MEDIADESCRIPTION = 'some_description',
	CHECKSUM, Continue_After_Error,
	BUFFERCOUNT = 1500,
	MAXTRANSFERSIZE=419434,
	BLOCKSIZE = 65536,
	DIFFERENTIAL


BACKUP DATABASE AdventureWorks2019 TO DISK = 'D:\AdventureWorks2019.bak'
	MIRROR TO DISK = 'E:\AdventureWorks2019.bak'
	WITH COMPRESSION, FORMAT, STATS = 1,
	NAME = 'Some_Name', DESCRIPTION = 'Some_Description',
	MEDIANAME = 'Some_Name', MEDIADESCRIPTION = 'Some_Description',
	CHECKSUM, Continue_After_Error,
	BUFFERCOUNT = 1500,
	MAXTRANSFERSIZE=419434,
	BLOCKSIZE = 65536,
	DIFFERENTIAL


-- Log backup
BACKUP LOG AdventureWorks2019 TO DISK = 'AdventureWorks2019.bak'
	WITH COMPRESSION, FORMAT, STATS = 1,
	NAME = 'Some_Name', DESCRIPTION = 'Some_Description',
	MEDIANAME = 'Some_Name', MEDIADESCRIPTION = 'Some_Description',
	CHECKSUM, Continue_After_Error,
	BUFFERCOUNT = 1500,
	MAXTRANSFERSIZE=419434,
	BLOCKSIZE = 65536

/*
The lastlsn of full backup is firstlsn of first log backup
this lastlsn of first backup is firstklsn of second log backup and etc
to show that use "RESTORE HEADERONLY FROM"
*/

------------------------------------------------------------------------------------

-- Specifies the number of days that must elapse before this backup media set can be overwritten
BACKUP DATABASE AdventureWorks2019 TO DISK = 'D:\AdventureWorks2019.bak'
WITH RETAINDAYS=1
GO

BACKUP DATABASE AdventureWorks2019 TO DISK = 'D:\AdventureWorks2019.bak'
WITH INIT
GO

-- With skip option backup skip RetainDays
BACKUP DATABASE AdventureWorks2019 TO DISK = 'D:\AdventureWorks2019.bak'
WITH INIT, SKIP
GO

------------------------------------------------------------------------------------

BACKUP DATABASE AdventureWorks2019 TO DISK = 'D:\AdventureWorks2019.bak'
	WITH COPY_ONLY
GO

------------------------------------------------------------------------------------

-- Set to take backup compress always by default
SP_CONFIGURE 'backup compression default', 1
GO

SP_CONFIGURE 'backup compression default', 0
GO

RECONFIGURE
GO

------------------------------------------------------------------------------------
-- Set the number of days that must elapse before this backup media set can be overwritten
EXEC sp_configure 'show advanced options', 1;  
GO 

RECONFIGURE ;  
GO  

EXEC sp_configure 'media retention', 60 ;  
GO  

RECONFIGURE;  
GO

EXEC sp_configure 'show advanced options', 0;  
GO 

RECONFIGURE ;  
GO 