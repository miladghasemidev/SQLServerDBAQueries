USE AdventureWorks2019
GO

-- See database recovery model
SELECT 
	database_id,name,recovery_model_desc 
FROM SYS.databases
WHERE name='AdventureWorks2019'
GO

-- set database recovery model to simple
ALTER DATABASE AdventureWorks2019 SET RECOVERY SIMPLE
GO

-- set database recovery model to full
ALTER DATABASE AdventureWorks2019 SET RECOVERY FULL
GO

-- set database recovery model to bulk_logged
ALTER DATABASE AdventureWorks2019 SET RECOVERY BULK_LOGGED
GO