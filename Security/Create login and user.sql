-- Check for exists login
SELECT * FROM master.dbo.syslogins
	WHERE loginname = 'LoginName'
GO

-- Create sql authentication login
CREATE LOGIN LoginName WITH PASSWORD = 'write your password' MUST_CHANGE,
	DEFAULT_DATABASE = [Database Name],
		CHECK_EXPIRATION = ON,
			CHECK_POLICY = ON,
				DEFAULT_LANGUAGE = ENGLISH;
GO

-- Create windows authentication login
CREATE LOGIN [Write Localwindows\ActiveDirectory account] FROM WINDOWS; 
GO

-- Syntax for SQL Server
/*
CREATE LOGIN login_name { WITH <option_list1> | FROM <sources> }
<option_list1> ::=
    PASSWORD = { 'password' | hashed_password HASHED } [ MUST_CHANGE ]
    [ , <option_list2> [ ,... ] ]
<option_list2> ::=
    SID = sid
    | DEFAULT_DATABASE = database
    | DEFAULT_LANGUAGE = language
    | CHECK_EXPIRATION = { ON | OFF}
    | CHECK_POLICY = { ON | OFF}
    | CREDENTIAL = credential_name
<sources> ::=
    WINDOWS [ WITH <windows_options>[ ,... ] ]
    | CERTIFICATE certname
    | ASYMMETRIC KEY asym_key_name
<windows_options> ::=
    DEFAULT_DATABASE = database
    | DEFAULT_LANGUAGE = language
*/

-- DROP Login
IF EXISTS (SELECT loginname FROM master.dbo.syslogins WHERE loginname='LoginName')
	DROP LOGIN LoginName; 
GO

DROP LOGIN LoginName;
GO

-- Get login sid
SELECT * FROM sys.sql_logins WHERE name = 'sa';
GO

--Unlock Login
ALTER LOGIN LoginName WITH PASSWORD= 'write your password' UNLOCK
GO
ALTER LOGIN LoginName WITH CHECK_POLICY=ON
GO
ALTER LOGIN LoginName WITH CHECK_POLICY=OFF
GO

-- Disable login
ALTER LOGIN LoginName DISABLE
GO


-- Enable login 
ALTER LOGIN LoginName ENABLE
GO


-- Create user and map it to login
CREATE USER UserName FOR LOGIN LoginName; 


-- Delete user
DROP USER UserName;


-- see current user
SELECT CURRENT_USER;


