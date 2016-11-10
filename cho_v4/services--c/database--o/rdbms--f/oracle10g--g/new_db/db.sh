#!/bin/bash
mkdir -p /media/storage/as/oracle/logs/create_db
. /media/storage/as/oracle/conf/_context/env.sh
cd $ORACLE_HOME

bin/sqlplus -s -l "/ as sysdba" <<EOF
set verify off
DEFINE sid = $SID
DEFINE characterset = $CHARACTERSET
DEFINE sysPassword = $sysPassword
DEFINE systemPassword = $sysPassword
host bin/orapwd file=/media/storage/as/oracle/data/master/orapw&&sid password=&&sysPassword force=y
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/CreateDB.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/CreateDBFiles.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/CreateDBCatalog.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/JServer.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/odm.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/context.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/xdb_protocol.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/ordinst.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/interMedia.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/cwmlite.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/labelSecurity.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/postDBCreation.sql;
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/zabbix.sql;
@rdbms/admin/catbundle.sql psu apply;
@rdbms/admin/utlrp.sql;
@rdbms/admin/tracetab.sql;
exit;
EOF
