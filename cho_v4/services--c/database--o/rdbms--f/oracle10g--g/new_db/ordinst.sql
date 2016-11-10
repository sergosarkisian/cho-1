connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/create_db/ordinst.log
@ord/admin/ordinst.sql SYSAUX SYSAUX;
spool off
