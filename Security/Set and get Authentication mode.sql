USE master
GO

-- Get authentication mode
DECLARE @AuthenticationMode INT  
EXEC master.dbo.xp_instance_regread N'HKEY_LOCAL_MACHINE', 
N'Software\Microsoft\MSSQLServer\MSSQLServer',   
N'LoginMode', @AuthenticationMode OUTPUT  
SELECT CASE @AuthenticationMode    
	WHEN 1 THEN 'Windows Authentication'   
	WHEN 2 THEN 'Windows and SQL Server Authentication'   
	ELSE 'Unknown'  
END as [Authentication Mode] 
GO

-- Get authentication mode
EXEC master.sys.xp_loginconfig 'login mode'  
GO


-- Set Windows Authentication
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 1
GO
-- Set Mixed Mode
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
GO

-- Get login with authentication mode
SELECT * FROM SYS.dm_exec_sessions
GO
-- when nt_domain and nt_user_name is not null mean login connect with windows authentication mode.