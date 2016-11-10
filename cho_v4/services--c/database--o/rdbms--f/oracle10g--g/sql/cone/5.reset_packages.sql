connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/cone/5.reset_packages

CREATE OR REPLACE PROCEDURE SYS.RESET_ALL_PACKAGES IS
BEGIN
  DBMS_SESSION.RESET_PACKAGE;
END RESET_ALL_PACKAGES;
/

spool off
