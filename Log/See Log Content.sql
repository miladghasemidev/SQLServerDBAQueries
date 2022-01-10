SELECT * FROM sys.fn_dblog(NULL, NULL)
WHERE PartitionId IN
(
	SELECT partition_id FROM sys.partitions
	WHERE object_id = OBJECT_ID('TB1') -- write your table that want to see it's log
)
GO
SELECT * FROM sys.fn_dblog(NULL, NULL)
	WHERE [Transaction ID]='0000:0000038f' 
GO