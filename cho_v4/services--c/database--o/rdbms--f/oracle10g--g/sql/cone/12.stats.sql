connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/cone/12.stats.sql

begin dbms_stats.gather_schema_stats ( ownname          => 'E$TOCEAN' ); end;
/


spool off
