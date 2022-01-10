-- Make table with compression option
CREATE TABLE Row_Level_Compression
( 
	Code   INT IDENTITY PRIMARY KEY,
	Family NVARCHAR(700),
	Name   NVARCHAR(700)
)WITH (DATA_COMPRESSION = ROW)
GO

CREATE TABLE Page_Level_Compression
( 
	Code   INT IDENTITY PRIMARY KEY,
	Family NVARCHAR(700),
	Name   NVARCHAR(700)
)WITH (DATA_COMPRESSION = PAGE)
GO

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Add compression to table 
ALTER TABLE Row_Level_Compression REBUILD WITH (DATA_COMPRESSION = ROW)
GO

ALTER TABLE Page_Level_Compression REBUILD WITH (DATA_COMPRESSION = PAGE)
GO

ALTER TABLE [No_Compression] REBUILD WITH (DATA_COMPRESSION = NONE)
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------
-- Make sp to get report about table compression
CREATE PROCEDURE usp_Tables_Compress_Report (@compress_method char(4))
AS 
SET NOCOUNT ON
BEGIN
	DECLARE @schema_name sysname, @table_name sysname
	CREATE TABLE #compress_report_tb 
	(ObjName sysname,
	schemaName sysname,
	indx_ID int,
	partit_number int,
	size_with_current_compression_setting bigint,
	size_with_requested_compression_setting bigint,
	sample_size_with_current_compression_setting bigint,
	sample_size_with_requested_compression_setting bigint)
	DECLARE c_sch_tb_crs cursor for 
	SELECT TABLE_SCHEMA,TABLE_NAME
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_TYPE LIKE 'BASE%' 
	AND TABLE_CATALOG = upper(db_name())
	OPEN c_sch_tb_crs
	FETCH NEXT FROM c_sch_tb_crs INTO @schema_name, @table_name
	WHILE @@Fetch_Status = 0 
	BEGIN
	INSERT INTO #compress_report_tb
	EXEC sp_estimate_DATA_COMPRESSION_savings
	@schema_name = @schema_name,
	@object_name = @table_name,
	@index_id = NULL,
	@partition_number = NULL,
	@DATA_COMPRESSION = @compress_method 
	FETCH NEXT FROM c_sch_tb_crs INTO @schema_name, @table_name
	END
	CLOSE c_sch_tb_crs 
	DEALLOCATE c_sch_tb_crs
	SELECT schemaName AS [schema_name]
	, ObjName AS [table_name]
	, avg(size_with_current_compression_setting) as avg_size_with_current_compression_setting
	, avg(size_with_requested_compression_setting) as avg_size_with_requested_compression_setting
	, avg(size_with_current_compression_setting - size_with_requested_compression_setting) AS avg_size_saving
	FROM #compress_report_tb
	GROUP BY schemaName,ObjName
	ORDER BY schemaName ASC, avg_size_saving DESC 
	DROP TABLE #compress_report_tb
END
SET NOCOUNT OFF
GO


EXEC usp_tables_compress_report @compress_method = 'PAGE'

