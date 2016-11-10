connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/storage/as/oracle/logs/cone/1.datafiles_init

ALTER DATABASE DATAFILE '/media/storage/as/oracle/data/master/undotbs01.dbf' RESIZE 10000M;
ALTER DATABASE DATAFILE '/media/storage/as/oracle/data/master/undotbs01.dbf' AUTOEXTEND ON  NEXT 1000M MAXSIZE UNLIMITED;

CREATE TABLESPACE E$CORE DATAFILE 
'/media/storage/as/oracle/data/master/ecore.dbf' SIZE 5000M AUTOEXTEND ON NEXT 100M MAXSIZE 5000M
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

CREATE TABLESPACE E$&&scheme_uc DATAFILE 
'/media/storage/as/oracle/data/master/e&&scheme_lc.dbf' SIZE 2000M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

CREATE ROLE SESSION_MANAGER NOT IDENTIFIED;

CREATE USER CORE
IDENTIFIED BY VALUES '5C05D80DBA3D6FC2'
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
PROFILE DEFAULT
ACCOUNT UNLOCK;


CREATE USER E$CORE
IDENTIFIED BY VALUES '7CD9C72DDA786401'
DEFAULT TABLESPACE E$CORE
TEMPORARY TABLESPACE TEMP
PROFILE DEFAULT
ACCOUNT UNLOCK;
-- 3 Roles for E$CORE 
GRANT DBA TO E$CORE WITH ADMIN OPTION;
GRANT CONNECT TO E$CORE WITH ADMIN OPTION;
GRANT SELECT_CATALOG_ROLE TO E$CORE WITH ADMIN OPTION;
ALTER USER E$CORE DEFAULT ROLE ALL;
-- 10 System Privileges for E$CORE 
GRANT CREATE ANY PROCEDURE TO E$CORE WITH ADMIN OPTION;
GRANT CREATE ANY SYNONYM TO E$CORE WITH ADMIN OPTION;
GRANT EXECUTE ANY PROCEDURE TO E$CORE;
GRANT DROP ANY PROCEDURE TO E$CORE WITH ADMIN OPTION;
GRANT CREATE USER TO E$CORE;
GRANT DROP ANY SYNONYM TO E$CORE WITH ADMIN OPTION;
GRANT ALTER USER TO E$CORE;
GRANT UNLIMITED TABLESPACE TO E$CORE WITH ADMIN OPTION;
GRANT CREATE ANY TABLE TO E$CORE WITH ADMIN OPTION;
GRANT DROP USER TO E$CORE;


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



CREATE USER E$XML
IDENTIFIED BY VALUES '84686A394D1A623F'
DEFAULT TABLESPACE E$CORE
TEMPORARY TABLESPACE TEMP
PROFILE DEFAULT
ACCOUNT UNLOCK;
-- 2 Roles for E$XML 
GRANT RESOURCE TO E$XML;
GRANT DBA TO E$XML;
ALTER USER E$XML DEFAULT ROLE ALL;
-- 3 System Privileges for E$XML 
GRANT UNLIMITED TABLESPACE TO E$XML;
GRANT CREATE ANY TABLE TO E$XML WITH ADMIN OPTION;
GRANT EXECUTE ANY PROCEDURE TO E$XML;



CREATE USER EDI_WEB
IDENTIFIED BY VALUES 'B6C08CD770D872FF'
DEFAULT TABLESPACE E$CORE
TEMPORARY TABLESPACE TEMP
PROFILE DEFAULT
ACCOUNT UNLOCK;
-- 1 Role for EDI_WEB 
GRANT CONNECT TO EDI_WEB;
ALTER USER EDI_WEB DEFAULT ROLE ALL;
-- 1 System Privilege for EDI_WEB 
BEGIN
SYS.DBMS_AQADM.GRANT_SYSTEM_PRIVILEGE (
PRIVILEGE    => 'MANAGE_ANY',
GRANTEE      => 'EDI_WEB',
ADMIN_OPTION => FALSE);
END;
/


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
