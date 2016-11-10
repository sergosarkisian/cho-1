connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/create_db/xdb_protocol.log
@rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect "SYS"/"&&sysPassword" as SYSDBA
@rdbms/admin/catxdbj.sql;
@rdbms/admin/catrul.sql;
spool off
