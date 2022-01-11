-- Get server roles
EXEC sp_helpsrvrole
GO


-- Get member of server roles 
EXEC sp_helpsrvrolemember 'sysadmin'
EXEC sp_helpsrvrolemember 'diskadmin'
GO

-- Add member to server login
ALTER SERVER ROLE diskadmin ADD MEMBER LoginName
GO

-- Drop login from server role
ALTER SERVER ROLE [sysadmin] DROP MEMBER LoginName
GO
