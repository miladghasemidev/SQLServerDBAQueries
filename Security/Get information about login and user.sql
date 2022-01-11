SELECT * FROM SYS.server_principals

SELECT * FROM SYS.database_principals

----------------------------------------------------------------------------------------------------------------------------------------
-- Who is sysadmin
SELECT  p.name AS [loginname] ,
        p.type ,
        p.type_desc ,
        p.is_disabled,
        CONVERT(VARCHAR(10),p.create_date ,101) AS [created],
        CONVERT(VARCHAR(10),p.modify_date , 101) AS [update]
FROM    sys.server_principals p
        JOIN sys.syslogins s ON p.sid = s.sid
WHERE   p.type_desc IN ('SQL_LOGIN', 'WINDOWS_LOGIN', 'WINDOWS_GROUP')
        -- Logins that are not process logins
        AND p.name NOT LIKE '##%'
        -- Logins that are sysadmins
        AND s.sysadmin = 1
GO

EXEC SP_HELPSRVROLEMEMBER 'sysadmin'
GO

----------------------------------------------------------------------------------------------------------------------------------------
-- Get know all user was in which role
SELECT
    spU.name
    ,MAX(CASE WHEN srm.role_principal_id = 3 THEN 1 END) AS sysadmin
    ,MAX(CASE WHEN srm.role_principal_id = 4 THEN 1 END) AS securityadmin
    ,MAX(CASE WHEN srm.role_principal_id = 5 THEN 1 END) AS serveradmin
    ,MAX(CASE WHEN srm.role_principal_id = 6 THEN 1 END) AS setupadmin
    ,MAX(CASE WHEN srm.role_principal_id = 7 THEN 1 END) AS processadmin
    ,MAX(CASE WHEN srm.role_principal_id = 8 THEN 1 END) AS diskadmin
    ,MAX(CASE WHEN srm.role_principal_id = 9 THEN 1 END) AS dbcreator
    ,MAX(CASE WHEN srm.role_principal_id = 10 THEN 1 END) AS bulkadmin
FROM
    sys.server_principals AS spR
JOIN
    sys.server_role_members AS srm
ON
    spR.principal_id = srm.role_principal_id
JOIN
    sys.server_principals AS spU
ON
    srm.member_principal_id = spU.principal_id
WHERE
    spR.[type] = 'R'
GROUP BY
    spU.name
GO




-- login and their role
WITH cte_srm (principal_id, sysadmin, securityadmin, serveradmin, setupadmin, processadmin, diskadmin, dbcreator, bulkadmin) AS
    (
        SELECT
            srm.member_principal_id
            ,MAX(CASE WHEN srm.role_principal_id = 3 THEN 1 END) AS sysadmin
            ,MAX(CASE WHEN srm.role_principal_id = 4 THEN 1 END) AS securityadmin
            ,MAX(CASE WHEN srm.role_principal_id = 5 THEN 1 END) AS serveradmin
            ,MAX(CASE WHEN srm.role_principal_id = 6 THEN 1 END) AS setupadmin
            ,MAX(CASE WHEN srm.role_principal_id = 7 THEN 1 END) AS processadmin
            ,MAX(CASE WHEN srm.role_principal_id = 8 THEN 1 END) AS diskadmin
            ,MAX(CASE WHEN srm.role_principal_id = 9 THEN 1 END) AS dbcreator
            ,MAX(CASE WHEN srm.role_principal_id = 10 THEN 1 END) AS bulkadmin
        FROM
            sys.server_principals AS sp
        JOIN
            sys.server_role_members AS srm
        ON
            sp.principal_id = srm.role_principal_id
        WHERE
            sp.[type] = 'R'
        GROUP BY
            srm.member_principal_id
    )
SELECT
    pr.[sid]
    ,CAST(NULL AS SMALLINT) AS [status]
    ,pr.create_date
    ,pr.modify_date AS updatedate
    ,pr.create_date AS accdate
    ,0 AS totcpu
    ,0 AS totio
    ,0 AS spacelimit
    ,0 AS timelimit
    ,0 AS resultlimit
    ,pr.[name]
    ,pr.default_database_name AS dbname
    ,CAST(NULL AS SYSNAME) [password]
    ,pr.default_language_name AS [language]
    ,CAST(CASE WHEN pe.state = 'D' THEN 1 ELSE 0 END AS INT) AS denylogin
    ,CAST(CASE WHEN pe.state = 'G' THEN 1 ELSE 0 END AS INT) AS hasaccess
    ,CAST(CASE WHEN pr.[type] in ('U','G') THEN 1 ELSE 0 END AS INT) AS isntname
    ,CAST(CASE WHEN pr.[type] = 'G' THEN 1 ELSE 0 END AS INT) AS isntgroup
    ,CAST(CASE WHEN pr.[type] = 'U' THEN 1 ELSE 0 END AS INT) AS isntuser
    ,ISNULL(cte_srm.sysadmin, 0) AS sysadmin
    ,ISNULL(cte_srm.securityadmin, 0) AS securityadmin
    ,ISNULL(cte_srm.serveradmin, 0) AS serveradmin
    ,ISNULL(cte_srm.setupadmin, 0) AS setupadmin
    ,ISNULL(cte_srm.processadmin, 0) AS processadmin
    ,ISNULL(cte_srm.diskadmin, 0) AS diskadmin
    ,ISNULL(cte_srm.dbcreator, 0) AS dbcreator
    ,ISNULL(cte_srm.bulkadmin, 0) AS bulkadmin
    ,pr.[name] AS loginname
FROM
    sys.server_principals AS pr
LEFT OUTER JOIN
    sys.server_permissions AS pe
ON
    pr.principal_id = pe.grantee_principal_id
AND
    pe.[type] = 'COSQ'
LEFT OUTER JOIN
    cte_srm
ON
    pr.principal_id = cte_srm.principal_id
WHERE
    pr.[type] <> 'R'
GO

----------------------------------------------------------------------------------------------------------------------------------------
 -- Is login was in this role?
SELECT IS_SRVROLEMEMBER('sysadmin','SA')
SELECT IS_SRVROLEMEMBER('sysadmin','LoginName')

----------------------------------------------------------------------------------------------------------------------------------------
-- Get information about login
SELECT      
	LOGINPROPERTY('LoginName','badpasswordcount')AS 'BadPasswordCount', --BadPasswordCount mean how many time user enter wrong password
	LOGINPROPERTY('LoginName','badpasswordtime') AS 'BadPasswordTime', --badpasswordtime mean the last time that wrong password is entered
	LOGINPROPERTY('LoginName','daysuntilexpiration') AS 'DaysUntilExpiration', -- How many day remaine to expire login password
	LOGINPROPERTY('LoginName','defaultdatabase') AS 'DefaultDatabase',
	LOGINPROPERTY('LoginName','iSexpired') AS 'IsExpired',
	LOGINPROPERTY('LoginName','iSlocked') AS 'IsLocked'
GO

IF OBJECT_ID('dbo.ufn_login_properties') >0
	DROP FUNCTION dbo.ufn_login_properties;
GO


CREATE FUNCTION dbo.ufn_login_properties(@login_name NVARCHAR(MAX))
RETURNS TABLE
AS
RETURN SELECT
	LOGINPROPERTY(@login_name,'BadPasswordCount') AS [BadPasswordCount],
	LOGINPROPERTY(@login_name,'BadPasswordTime') AS [BadPasswordTime],
	LOGINPROPERTY(@login_name,'DaysUntilExpiration') AS [DaysUntilExpiration],
	LOGINPROPERTY(@login_name,'DefaultDatabase') AS [DefaultDatabase],
	LOGINPROPERTY(@login_name,'DefaultLanguage') AS [DefaultLanguage],
	LOGINPROPERTY(@login_name,'HistoryLength') AS [HistoryLength],
	LOGINPROPERTY(@login_name,'IsExpired') AS [IsExpired],
	LOGINPROPERTY(@login_name,'IsLocked') AS [IsLocked],
	LOGINPROPERTY(@login_name,'IsMustChange') AS [IsMustChange],
	LOGINPROPERTY(@login_name,'LockoutTime') AS [LockoutTime],
	LOGINPROPERTY(@login_name,'PasswordHash') AS [PasswordHash],
	LOGINPROPERTY(@login_name,'PasswordLastSetTime') AS [PasswordLastSetTime],
	LOGINPROPERTY(@login_name,'PasswordHashAlgorithm') AS [PasswordHashAlgorithm];
GO


SELECT * FROM dbo.ufn_login_properties('LoginName')
GO

SELECT 
	SL.name,LP.*
FROM sys.sql_logins AS SL
CROSS APPLY dbo.ufn_login_properties(SL.name) AS LP
GO

----------------------------------------------------------------------------------------------------------------------------------------
-- Get all login create script
SELECT 
	'CREATE LOGIN '+name+ ' WITH PASSWORD = ' +
     CONVERT(varchar(max), LOGINPROPERTY(name, 'PasswordHash'),1 ) + 
     ' HASHED'
FROM sys.server_principals
--WHERE name in ('LoginName','SA')
WHERE type = 'S'
GO

----------------------------------------------------------------------------------------------------------------------------------------
-- do I have SELECT permissions on the schema 'dbo' ?
SELECT HAS_PERMS_BY_NAME('dbo', 'SCHEMA', 'SELECT');


-- to check server level permissions :
SELECT HAS_PERMS_BY_NAME(null, null, 'VIEW SERVER STATE');

