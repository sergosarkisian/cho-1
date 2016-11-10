connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/cone/12.stats.sql

EXECUTE UTL_RECOMP.RECOMP_PARALLEL(NULL, 'E$&&scheme_uc');

begin dbms_stats.gather_schema_stats ( ownname          => 'E$TOCEAN' ); end;
/


spool off
