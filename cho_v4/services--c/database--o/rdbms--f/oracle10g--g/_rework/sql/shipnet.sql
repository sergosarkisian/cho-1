NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252 >> /etc/profile.d/oracle.sh


CREATE TABLESPACE MWS_DATA_01 DATAFILE 
  '/storage/database/oracle/asmsn/MWS_DATA_01_SHIPNET.DBF' SIZE 1048M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

CREATE TABLESPACE MWS_IDX_01 DATAFILE 
  '/storage/database/oracle/asmsn/MWS_IDX_01_SHIPNET.DBF' SIZE 524M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

CREATE TABLESPACE SNACS_DATA DATAFILE 
  '/storage/database/oracle/asmsn/SNACS_DATA01_SHIPNET.DBF' SIZE 530M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


CREATE TABLESPACE SNACS_INDEX DATAFILE 
  '/storage/database/oracle/asmsn/SNACS_INDEX01_SHIPNET.DBF' SIZE 300M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


CREATE TABLESPACE SNAUDIT DATAFILE 
  '/storage/database/oracle/asmsn/SNAUDIT01_SHIPNET.DBF' SIZE 10M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


CREATE TABLESPACE SNIBS_DATA DATAFILE 
  '/storage/database/oracle/asmsn/SNIBS_DATA01_SHIPNET.DBF' SIZE 300M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


CREATE TABLESPACE SNIBS_INDEX DATAFILE 
  '/storage/database/oracle/asmsn/SNIBS_INDEX01_SHIPNET.DBF' SIZE 300M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

CREATE TABLESPACE SNSYS DATAFILE 
  '/storage/database/oracle/asmsn/SNSYS01_SHIPNET.DBF' SIZE 30M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


on source:
export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252
exp SYSTEM full=y compress=no feedback=1000  consistent=yes buffer=2000000 recordlength=64000 file=/storage/database/oracle/export/asmsn.dump log=/storage/database/oracle/export/asmsn.exp.log
expdp SYSTEM full=y directory=export dumpfile=asmsn.dump logfile=asmsn.dump.log

on dest:
export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252
imp SYSTEM full=y feedback=1000  buffer=2000000 recordlength=64000 file=/storage/database/oracle/export/asmsn.dump log=/storage/database/oracle/export/asmsn.imp.data.log  indexes=n constraints=n 
imp SYSTEM full=y feedback=1000  buffer=2000000 recordlength=64000 file=/storage/database/oracle/export/asmsn.dump log=/storage/database/oracle/export/asmsn.imp.const.log indexes=n constraints=y rows=n grants=n
impdp SYSTEM full=y directory=export dumpfile=asmsn_new.dump logfile=asmsn_new.import.log table_exists_action=replace



export NLS_LANG=AMERICAN_AMERICA.WE8MSWIN1252

select * from nls_database_parameters where parameter='NLS_CHARACTERSET'; 
ALTER DATABASE CHARACTER SET INTERNAL_USE WE8MSWIN1252;
ALTER DATABASE CHARACTER SET WE8MSWIN1252;

exp system/12345 file=system.dmp log=system.log
imp system/12345 file=EDSS.dmp log=imp_EDSS.log ignore=y
imp system/12345 file=EDSS.dmp log=imp_EDSS.log ignore=y FULL=y
exp system/12345 file=system_after_sn.dmp log=system_after_sn.log

export HOME="/opt/oracle"
export LD_LIBRARY_PATH="/opt/oracle/product/10g/lib:/opt/oracle/product/10g/ctx/lib"
export ORACLE_BASE="/opt/oracle"
export ORACLE_HOME="/opt/oracle/product/10g"
export ORACLE_SID="asmsn"
export ORA_NLS10="/opt/oracle/product/10g/nls/data"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin:/usr/games:/opt/oracle/product/10g/bin"


rsync --rsync-path="sudo /usr/bin/rsync" --progress -azusS --compress-level=4  /storage/database/export/ edss@IP:/storage/database/export/

 begin dbms_stats.gather_schema_stats ( user ); end;
