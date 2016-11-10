connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/create_db/labelSecurity.log
@rdbms/admin/catols.sql;
connect "SYS"/"&&sysPassword" as SYSDBA
startup 
spool off
