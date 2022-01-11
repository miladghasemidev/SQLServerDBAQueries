-- In below code we give access to all objects
GRANT SELECT, UPDATE, INSERT, DELETE, EXECUTE, ALTER TO LoginName;

-- to give access to specific object 
GRANT SELECT ON OBJECT::SchemaName.TableName TO LoginName;

-- or schema
GRANT SELECT ON SCHEMA::SchemaName TO LoginName;

-- Deny access from user
DENY SELECT, UPDATE, INSERT, DELETE, EXECUTE, ALTER TO LoginName;
DENY SELECT ON OBJECT::SchemaName.TableName TO LoginName; 
DENY SELECT ON SCHEMA::SchemaName TO LoginName;

-- Revoke access from user (Revoke is like to reset access)
REVOKE SELECT, UPDATE, INSERT, DELETE, EXECUTE, ALTER TO LoginName;

-- With this access user just can see object definition
GRANT VIEW DEFINITION TO LoginName;

-- all access even create user
GRANT CONTROL TO LoginName;

-- Give access at column level
GRANT SELECT ON OBJECT::SchemaName.TableName(C1,C2) TO LoginName; 
GO

-- can not set deny access to user who has db_owner role
DENY SELECT TO dbo


-- grant with : with this access user can give access to other user according to its own access
-- for example [LoginName] that have select permision on [TableName] just can give select permission to other user just on [TableName]
GRANT SELECT ON OBJECT::SchemaName.TableName TO LoginName WITH GRANT OPTION

-- for deny or revoke user that has 'WITH GRANT OPTION' you should use this syntx:
REVOKE SELECT ON OBJECT::SchemaName.TableName TO LoginName CASCADE