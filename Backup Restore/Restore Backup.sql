-- Restore full backup
RESTORE DATABASE AdventureWorks2019 FROM  DISK = 'D:\AdventureWorks2019.bak' WITH 
MOVE 'AdventureWorks2019' TO 'D:\Dump\AdventureWorks2019.mdf',
MOVE 'AdventureWorks2019_log' TO 'D:\Dump\AdventureWorks2019_log.ldf',
STATS = 1

RESTORE DATABASE WideWorldImporters FROM  DISK='D:\Dump\WideWorldImporters.bak' WITH 
MOVE 'WideWorldImporters' TO 'D:\Dump\WideWorldImporters.mdf',
MOVE 'WideWorldImporters_log' TO 'D:\Dump\WideWorldImporters_log.ldf',
STATS = 1, FILE = 2

-------------------------------------------------------------------
-- Restore differential backup steps
-- First restore full backup
RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Full.bak' WITH
MOVE 'AdventureWorks2019' TO 'D:\Dump\AdventureWorks2019.mdf',
MOVE 'AdventureWorks2019_log' TO 'D:\Dump\AdventureWorks2019.ldf',
STATS = 1, NORECOVERY
GO 

-- If you want restore several differential backup after this do like below
RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Diff.bak' WITH
STATS = 1, FILE=3, NORECOVERY
GO 

-- After restore last differential backup run below query to terminal backup process
RESTORE DATABASE AdventureWorks2019 WITH RECOVERY

-- But if you want just restore one differential backup there is no need to do the above two steps (query)
RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Diff.bak' 
WITH STATS = 1, RECOVERY
GO 

-- If in media you has many backupset just write it's position like below
RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Diff.bak' WITH
STATS = 1, FILE=3
GO 


-------------------------------------------------------------------
-- Restore Log
-- Method 1 : restore full first and then log
RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Full.bak' WITH
MOVE 'AdventureWorks2019' TO 'D:\Dump\AdventureWorks2019.mdf',
MOVE 'AdventureWorks2019_log' TO 'D:\Dump\AdventureWorks2019_log.ldf',
STATS = 1, NORECOVERY
GO 

RESTORE LOG AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019LogBackup1.trn' WITH
STATS = 1, NORECOVERY
GO 

RESTORE LOG AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019LogBackup2.trn' WITH
STATS = 1, NORECOVERY
GO 

RESTORE LOG AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019LogBackup3.trn' WITH
STATS = 1, RECOVERY 
GO 

-- -- Method 2 : restore full first and then diffrentianl backup and after all restore log backup
RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Full.bak' WITH
MOVE 'AdventureWorks2019' TO 'D:\Dump\AdventureWorks20199.mdf',
MOVE 'AdventureWorks2019_log' TO 'D:\Dump\AdventureWorks2019_log.ldf',
STATS = 1, NORECOVERY
GO 

RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Diff.bak' WITH 
STATS = 1, RECOVERY
GO 

RESTORE LOG AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019LogBackup1.trn' WITH
STATS = 1, NORECOVERY
GO 

RESTORE LOG AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019LogBackup2.trn' WITH
STATS = 1, NORECOVERY
GO 

-- After finishing backup process run below query to terminate restore process
RESTORE DATABASE AdventureWorks2019 WITH RECOVERY
-------------------------------------------------------------------

-- Restore in standby mode
RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Full.bak' WITH
MOVE 'AdventureWorks2019' TO 'D:\Dump\AdventureWorks2019.mdf',
MOVE 'AdventureWorks2019_log' TO 'D:\Dump\AdventureWorks2019_log.ldf',
STATS = 1, STANDBY = 'D:\Dump\AdventureWorks2019Undo.undo'
GO 

RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Diff1.bak'  WITH
STATS = 1, STANDBY = 'D:\Dump\AdventureWorks2019Undo.undo'
GO 

RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Diff2.bak'  WITH
STATS = 1, STANDBY = 'D:\Dump\AdventureWorks2019Undo.undo'
GO 

RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Diff3.bak'  WITH
STATS = 1, STANDBY = 'D:\Dump\AdventureWorks2019Undo.undo'
GO 

RESTORE LOG AdventureWorks2019 FROM DISK='D:\Dump\log8.trn' WITH
STATS = 1, STANDBY = 'D:\Dump\AdventureWorks2019Undo.undo'
GO

RESTORE  DATABASE AdventureWorks2019 WITH  RECOVERY

-------------------------------------------------------------------
-- Restore in point time
RESTORE DATABASE AdventureWorks2019 FROM DISK='D:\Dump\AdventureWorks2019_Full.bak' WITH
MOVE 'AdventureWorks2019' TO 'D:\Dump\AdventureWorks2019.mdf',
MOVE 'AdventureWorks2019_log' TO 'D:\Dump\AdventureWorks2019_log.ldf',
STATS = 1, STANDBY = 'D:\Dump\AdventureWorks2019Undo.undo'
GO 

RESTORE LOG AdventureWorks2019 FROM DISK='D:\Dump\log5.trn' WITH
STATS = 1, STOPAT='2021-03-24 03:44:00', STANDBY = 'D:\Dump\AdventureWorks2019Undo.undo'
GO 

RESTORE DATABASE AdventureWorks2019 FROM DISK = 'D:\Dump\AdventureWorks2019_Full.bak' WITH RECOVERY
GO
