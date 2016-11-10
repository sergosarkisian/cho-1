CREATE SPFILE = '/media/storage/as/oracle/data/master/spfile.ora' FROM PFILE = '/media/storage/as/oracle/conf/_generated/initwk10&&sid.ora';
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool/media/storage/as/oracle/logs/create_db/CreateDB.log
startup nomount pfile="/media/storage/as/oracle/conf/_generated/initwk10.ora";
CREATE DATABASE "&&sid"
MAXINSTANCES 8
MAXLOGHISTORY 1
MAXLOGFILES 16
MAXLOGMEMBERS 3
MAXDATAFILES 100
DATAFILE '/media/storage/as/oracle/data/master/system01.dbf' SIZE 2000M REUSE AUTOEXTEND ON NEXT  100240K MAXSIZE UNLIMITED
EXTENT MANAGEMENT LOCAL
SYSAUX DATAFILE '/media/storage/as/oracle/data/master/sysaux01.dbf' SIZE 120M REUSE AUTOEXTEND ON NEXT  10240K MAXSIZE UNLIMITED
SMALLFILE DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '/media/storage/as/oracle/data/master/temp01.dbf' SIZE 20M REUSE AUTOEXTEND ON NEXT  640K MAXSIZE UNLIMITED
SMALLFILE UNDO TABLESPACE "UNDOTBS1" DATAFILE '/media/storage/as/oracle/data/master/undotbs01.dbf' SIZE 2000M REUSE AUTOEXTEND ON NEXT  50120K MAXSIZE UNLIMITED
CHARACTER SET &&characterset
NATIONAL CHARACTER SET AL16UTF16
LOGFILE GROUP 1 ('/media/storage/as/oracle/data/master/redo01.log') SIZE 51200K,
GROUP 2 ('/media/storage/as/oracle/data/master/redo02.log') SIZE 51200K,
GROUP 3 ('/media/storage/as/oracle/data/master/redo03.log') SIZE 51200K
USER SYS IDENTIFIED BY "&&sysPassword" USER SYSTEM IDENTIFIED BY "&&systemPassword";
spool off
