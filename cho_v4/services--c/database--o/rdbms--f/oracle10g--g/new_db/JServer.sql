connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/create_db/JServer.log
@javavm/install/initjvm.sql;
@xdk/admin/initxml.sql;
@xdk/admin/xmlja.sql;
@rdbms/admin/catjava.sql;
@rdbms/admin/catexf.sql;
spool off
