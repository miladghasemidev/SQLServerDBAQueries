-- Active show advanced options
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO

-- Active xp_cmdshell
EXEC sp_configure 'xp_cmdshell', 1
GO
RECONFIGURE
GO

-- Add network path to SQL Server
EXEC XP_CMDSHELL 'net use Z: "\\192.168.1.2\D\FullBackup"  WriteAccountPasswordHere /user:WriteAccountNameHere'


-- Delete network path from SQL Server
EXEC XP_CMDSHELL 'net use Z: /delete'


-- Deactive xp_cmdshell
EXEC sp_configure 'xp_cmdshell', 0
GO
RECONFIGURE
GO


-- Deactive show advanced options
EXEC sp_configure 'show advanced options', 0;
GO
RECONFIGURE;
GO

-- Backup example
BACKUP DATABASE [DatabaseName] TO  DISK = N'Z:\BackupName.bak' WITH NOFORMAT, NOINIT,  NAME = N'DatabaseName-Full Database Backup', 
SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 1
GO
