connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/create_db/spatial.log
@md/admin/mdinst.sql;
spool off
