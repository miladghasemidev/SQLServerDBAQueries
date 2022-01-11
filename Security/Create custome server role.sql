USE [master]
GO

-- Create custom server role
CREATE SERVER ROLE [Server role name]
GO

-- Give permission to custome srever role
GRANT CONNECT SQL TO PerformanceTuning
GRANT VIEW ANY DATABASE TO PerformanceTuning
GRANT VIEW ANY DEFINITION TO PerformanceTuning
GRANT VIEW SERVER STATE TO PerformanceTuning
GRANT ALTER ANY EVENT SESSION TO PerformanceTuning
GRANT ALTER TRACE TO PerformanceTuning
GO

-- Add login to custome server role
ALTER SERVER ROLE PerformanceTuning ADD MEMBER [Login Name]
GO

-- Check login in member of specific role
SELECT IS_SRVROLEMEMBER('Server role name','Login Name')
GO
