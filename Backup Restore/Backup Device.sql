-- Create backup device
EXEC sp_addumpdevice  'disk', 'WriteBackupDeviceName ForExample DiskDump', 'D:\dump.bak'
GO -- When execute it we do not have backup file with first backup in this device the bak file is show

-- Create backup device on tape
EXEC sp_addumpdevice 'tape', 'WriteBackupDeviceName ForExample TapeDump', '\\.\tape0'
GO

EXEC sp_addumpdevice 'disk', 'WriteBackupDeviceName ForExample NetworkDump',
    '\\192.168.1.2\Backup\DumpBackup.bak'
GO

-- Get informatio about backup device
SP_HELPDEVICE
GO

SP_HELPDEVICE 'diskdump'
GO

SELECT * FROM SYS.backup_devices
GO

-- Delete backup device without file
EXEC sp_dropdevice   'diskdump'
GO

-- Delete backup device with file
EXEC sp_dropdevice   'diskdump', 'DELFILE'
GO

BACKUP DATABASE AdventureWorks2019 TO diskdump