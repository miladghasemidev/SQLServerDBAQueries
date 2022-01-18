RESTORE LABELONLY FROM DISK = 'D:\AdventureWorks2019.bak'
GO

RESTORE HEADERONLY FROM DISK = 'D:\AdventureWorks2019.bak'
GO -- Backup type --> 1 : Full, 5 : Diffrential, 2 : Log, 4 : File group


RESTORE FILELISTONLY FROM DISK = 'D:\AdventureWorks2019.bak' WITH FILE = 6
GO

-- IF in media file has multi backupset write position of HEADERONLY ouput in fron of file option
RESTORE FILELISTONLY FROM DISK = 'D:\AdventureWorks2019.bak' WITH FILE = 6
GO

-- Test backup health
RESTORE VERIFYONLY FROM DISK = 'D:\AdventureWorks2019.bak' 
	WITH STATS=1
GO

-- If make backup with checksum option can use below query
RESTORE VERIFYONLY FROM DISK = 'D:\AdventureWorks2019.bak'
	WITH STATS=1, CHECKSUM