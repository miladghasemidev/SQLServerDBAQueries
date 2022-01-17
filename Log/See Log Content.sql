SELECT * FROM sys.fn_dblog(NULL, NULL) -- Parameter : start, end
WHERE PartitionId IN
(
	SELECT partition_id FROM sys.partitions
	WHERE object_id = OBJECT_ID('Person.Person') -- Write the name of the table you want to see the log
)
GO

SELECT * FROM sys.fn_dblog(NULL, NULL)
	WHERE [Transaction ID] = '0000:00001749' 
GO

-- View log file space usage
DBCC SQLPERF('LOGSPACE')
GO

SELECT 
	name,
	type_desc,
	physical_name,
	CAST((size*8.0/1024) AS DECIMAL(18,2))AS Size_MB,
	max_size
FROM SYS.database_files
GO

-- Number of log records in log file
SELECT COUNT(*) FROM fn_dblog(NULL,NULL) -- Parameter : start, end
GO


-- View log file status
SELECT 
  [database]      = d.name, 
  [recovery]      = ls.recovery_model, 
  [vlf_count]     = ls.total_vlf_count, 
  [active_vlfs]   = ls.active_vlf_count,
  [vlf_size]      = ls.current_vlf_size_mb,
  [active_log_%]  = CONVERT(decimal(5,2), 
                    100.0*ls.active_log_size_mb/ls.total_log_size_mb)
FROM sys.databases AS d
CROSS APPLY sys.dm_db_log_stats(d.database_id) AS ls
WHERE 
	D.name='AdventureWorks2019'
GO


SELECT 
  [database]      = d.name, 
  [recovery]      = ls.recovery_model, 
  [vlf_count]     = ls.total_vlf_count, 
  [active_vlfs]   = ls.active_vlf_count,
  [vlf_size]      = ls.current_vlf_size_mb,
  [active_log_%]  = CONVERT(decimal(5,2), 
                    100.0*ls.active_log_size_mb/ls.total_log_size_mb)
FROM sys.databases AS d
CROSS APPLY sys.dm_db_log_stats(d.database_id) AS ls
GO


-- See the reason for not backing up the log file
SELECT 
	name ,
	recovery_model_desc ,
	log_reuse_wait_desc
FROM	sys.databases
WHERE	name = 'AdventureWorks2019'
GO

-- View number of VLF in log file (Logical architecture)
SELECT 
	* 
FROM sys.dm_db_log_info(DEFAULT)
GO

-- View number of VLF in log file (Logical architecture)
DBCC LOGINFO
GO
/*
Status	:
	There are 2 possible values 0 and 2. 
	2 means that the VLF cannot be reused and 
	0 means that it is ready for re-use.
Parity	:
	There are 2 possible values 64 and 128.
CreateLSN	:
	This is the LSN when the VLF was created. 
	If the createLSN is 0, it means it was created 
	when the physical transaction log file was created.
*/

/*
If your log file size is < 64 MB there will be 4 VLF in log file (each 1/4 of growth size)
If your log file size is between 64 MB to 2 GH there will be 8 VLF in log file (each 1/8 of growth size)
If your log file size is 1 GB there will be 16 VLF in log file (each 1/16 of growth size)
*/
/*
This is important to be considered as too many VLFs can lead to:

Long recovery time when SQL is starting up
Long time for a restore of a database to complete
Attaching a database runs too slow
Timeout errors when trying to create a new mirroring session
*/

-- Find all database log file that contain more than 100 VLF (100 is an example and you can write your number)
SELECT 
	NAME,COUNT(l.database_id) as 'VLF_Count' 
FROM sys.databases s
CROSS APPLY sys.dm_db_log_info(s.database_id) l
GROUP BY NAME
HAVING COUNT(l.database_id)> 100
GO


-- Find all insert/delete/update  that was submit into log backup file
SELECT
	[Transaction ID], [Current LSN], [Transaction Name], 
	[Operation],  [Context],[AllocUnitName],[Begin Time],
	[End Time], [Transaction SID],[Num Elements] ,
	[RowLog Contents 0],[RowLog Contents 1],
	[RowLog Contents 2],[RowLog Contents 3]
FROM fn_dblog (NULL, NULL)
 WHERE [Transaction ID] IN 
	(
		SELECT 
			[Transaction ID] 
		FROM fn_dblog (null,null) 
		WHERE [Transaction Name] = 'UPDATE'
	)
GO


-- View all log records in the backup log
SELECT  * FROM fn_dump_dblog
(
	NULL,NULL,'DISK',1,'D:\AdventureWorks2019.trn'
	,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL
	,NULL,NULL,NULL,NULL
)
GO