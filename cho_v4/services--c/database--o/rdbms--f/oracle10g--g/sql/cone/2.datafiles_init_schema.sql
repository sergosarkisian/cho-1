connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/cone/2.datafiles_init_schema


CREATE TABLESPACE E$&&scheme_uc DATAFILE 
'/media/storage/as/oracle/data/master/e&&scheme_lc.dbf' SIZE 2000M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

CREATE USER E$&&scheme_uc
IDENTIFIED BY VALUES 'FC14367310CDEFAE'
DEFAULT TABLESPACE E$&&scheme_uc
TEMPORARY TABLESPACE TEMP
PROFILE DEFAULT
ACCOUNT UNLOCK;
-- 6 Roles for E$&&scheme_uc 
GRANT READ, WRITE ON DIRECTORY import TO E$&&scheme_uc;
GRANT READ, WRITE ON DIRECTORY export TO E$&&scheme_uc;  
GRANT AQ_USER_ROLE TO E$&&scheme_uc WITH ADMIN OPTION;
GRANT CONNECT TO E$&&scheme_uc;
GRANT RESOURCE TO E$&&scheme_uc;
GRANT CTXAPP TO E$&&scheme_uc;
GRANT SESSION_MANAGER TO E$&&scheme_uc;
GRANT AQ_ADMINISTRATOR_ROLE TO E$&&scheme_uc WITH ADMIN OPTION;
ALTER USER E$&&scheme_uc DEFAULT ROLE ALL;
-- 12 System Privileges for E$&&scheme_uc 
GRANT CREATE TYPE TO E$&&scheme_uc;
GRANT SELECT ANY TABLE TO E$&&scheme_uc;
GRANT DEBUG CONNECT SESSION TO E$&&scheme_uc WITH ADMIN OPTION;
BEGIN
SYS.DBMS_AQADM.GRANT_SYSTEM_PRIVILEGE (
PRIVILEGE    => 'MANAGE_ANY',
GRANTEE      => 'E$&&scheme_uc',
ADMIN_OPTION => TRUE);
END;
/
GRANT CREATE ANY VIEW TO E$&&scheme_uc;
GRANT CREATE SEQUENCE TO E$&&scheme_uc;
GRANT CREATE ANY TABLE TO E$&&scheme_uc;
BEGIN
SYS.DBMS_AQADM.GRANT_SYSTEM_PRIVILEGE (
PRIVILEGE    => 'ENQUEUE_ANY',
GRANTEE      => 'E$&&scheme_uc',
ADMIN_OPTION => TRUE);
END;
/
GRANT CREATE PROCEDURE TO E$&&scheme_uc;
GRANT UNLIMITED TABLESPACE TO E$&&scheme_uc;
GRANT CREATE VIEW TO E$&&scheme_uc;
GRANT CREATE DATABASE LINK TO E$&&scheme_uc;
-- 1 Tablespace Quota for E$&&scheme_uc 
ALTER USER E$&&scheme_uc QUOTA UNLIMITED ON E$&&scheme_uc;


alter user E$&&scheme_uc identified by "&&eschemePassword";


-- 3 Roles for E$&&scheme_uc 
GRANT CONNECT TO E$&&scheme_uc;
GRANT EXP_FULL_DATABASE TO E$&&scheme_uc;
GRANT IMP_FULL_DATABASE TO E$&&scheme_uc;
ALTER USER E$&&scheme_uc DEFAULT ROLE ALL;
-- 3 System Privileges for E$&&scheme_uc 
GRANT GRANT ANY PRIVILEGE TO E$&&scheme_uc;
GRANT SELECT ANY TABLE TO E$&&scheme_uc;
GRANT CREATE SESSION TO E$&&scheme_uc;
-- 1 Object Privilege for E$&&scheme_uc 
GRANT READ, WRITE ON DIRECTORY SYS.export TO E$&&scheme_uc;


spool off
