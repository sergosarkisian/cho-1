#!/bin/bash
if ! [[ `id -un` == "oracle" ]]; then echo "Please run as 'oracle' user! Exit."; exit 1; fi

/bin/sh /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/memset_pfile.sh
mkdir -p /media/storage/as/oracle/logs/create_db
. /media/storage/as/oracle/conf/_context/env.sh
cd $ORACLE_HOME

if [[ -z $App_c2dbsysPassword ]]; then
    echo "set an admin password"
    exit 1
fi

if [[ -z $CHARACTERSET ]]; then
    echo "set CHARACTERSET"
    exit 1
fi

bin/sqlplus -s -l "/ as sysdba" <<EOF
set verify off
DEFINE sid = $SID
DEFINE characterset = $CHARACTERSET
DEFINE sysPassword = $App_c2dbsysPassword
DEFINE systemPassword = $App_c2dbsysPassword
host /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g/ee--s/product/10g/bin/orapwd file=/media/storage/as/oracle/data/master/orapw&&sid password=&&sysPassword force=y
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

rm -f /media/storage/as/oracle/data/master/orapwwk10
ln -s /media/storage/as/oracle/data/master/orapwwk10 /media/storage/as/oracle/conf/_generated
