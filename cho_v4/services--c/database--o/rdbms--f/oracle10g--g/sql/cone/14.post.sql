connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/cone/14.post

begin dbms_stats.gather_schema_stats ( ownname          => 'E$&&scheme_uc' ); end;
/

spool off
