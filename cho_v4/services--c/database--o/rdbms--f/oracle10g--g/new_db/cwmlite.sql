set echo on
spool /media/storage/as/oracle/logs/create_db/cwmlite.log
connect "SYS"/"&&sysPassword" as SYSDBA
@olap/admin/olap.sql SYSAUX TEMP;
spool off
