connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/create_db/CreateDBCatalog.log

@rdbms/admin/catalog.sql;
@rdbms/admin/catblock.sql;
@rdbms/admin/catproc.sql;
@rdbms/admin/catoctk.sql;
@rdbms/admin/owminst.plb;
connect "SYSTEM"/"&&systemPassword"
@sqlplus/admin/pupbld.sql;
connect "SYSTEM"/"&&systemPassword"
set echo on
spool /media/storage/as/oracle/logs/create_db/sqlPlusHelp.log

@sqlplus/admin/help/hlpbld.sql helpus.sql;
spool off
spool off
