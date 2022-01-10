/*
Set to take backup in compression to default behaviour
*/

Exec sp_configure 'backup compression default',1
GO
RECONFIGURE
GO