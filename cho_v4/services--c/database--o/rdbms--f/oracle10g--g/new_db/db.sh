#!/bin/bash
########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash DSL, profiles
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
### IN4 BASH HEADER ###
set -e
PrevDirPath=$CurDirPath; CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="BEGIN -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###

if ! [[ `id -un` == "oracle" ]]; then echo "Please run as 'oracle' user! Exit."; exit 1; fi

EnvFile="/media/storage/as/oracle/conf/_context/env.sh"
! . $EnvFile

if [[ -z $SID ]]; then
    DialogMsg="Please specify SID"
    echo $DialogMsg; read SID
    echo "SID=\"$SID\"" >> $EnvFile
fi

if [[ -z $CHARACTERSET ]]; then
    DialogMsg="Please specify CHARACTERSET"
    echo $DialogMsg; select CHARACTERSET in AL32UTF8 ;  do  break ; done
    echo "CHARACTERSET=\"$CHARACTERSET\"" >> $EnvFile    
fi

if [[ -z $App_c2dbsysPassword ]]; then
    DialogMsg="Please specify Oracle admin password"
    echo $DialogMsg; read App_c2dbsysPassword
    echo "App_c2dbsysPassword=\"$App_c2dbsysPassword\"" >> $EnvFile    
fi

if [[ -z $App_c2dbconePassword ]]; then
    DialogMsg="Please specify  Oracle cone password"
    echo $DialogMsg; read App_c2dbconePassword
    echo "App_c2dbconePassword=\"$App_c2dbconePassword\"" >> $EnvFile    
fi

 . $EnvFile

SID="wk10"
CHARACTERSET=""
App_c2dbsysPassword="qwe123"
App_c2dbconePassword="3edc4rfv"

/bin/sh /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/memset_pfile.sh
mkdir -p /media/storage/as/oracle/logs/create_db
cd $ORACLE_HOME


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
shutdown immediate
exit;
EOF

rm -f /media/storage/as/oracle/data/master/orapwwk10
ln -s /media/storage/as/oracle/conf/_generated/orapwwk10 /media/storage/as/oracle/data/master/    

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
