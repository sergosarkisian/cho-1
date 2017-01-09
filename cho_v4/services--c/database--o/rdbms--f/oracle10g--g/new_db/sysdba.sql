connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/create_db/sysdba.log
 CREATE USER LOCALADMIN
  IDENTIFIED BY "pi=3.141592"
  DEFAULT TABLESPACE USERS
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
grant all privileges to LOCALADMIN;
grant sysdba to LOCALADMIN;

spool off  
