connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/create_db/interMedia.log
@ord/im/admin/iminst.sql;
spool off
