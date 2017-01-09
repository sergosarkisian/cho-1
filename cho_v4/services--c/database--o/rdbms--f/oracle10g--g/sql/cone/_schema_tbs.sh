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

if [[ -f $App_c2dbDataPath/e${App_c2dbSchemeDst_LC}.dbf ]]; then
    if [[ -z $App_c2dbDstSchemaForceCreation ]]; then
        DialogMsg="Oracle database already exists! Recreate?"
        echo $DialogMsg; select App_c2dbDstSchemaForceCreation in Yes No;  do  break ; done;
    fi
else
    App_c2dbDstSchemaForceCreation="Yes"
fi
   
if [[ $App_c2dbDstSchemaForceCreation == "Yes" ]]; then
        mkdir -p $App_c2dbLogPath

sqlplus -s -l "/ as sysdba" <<EOF
set verify off
DEFINE scheme_uc = $App_c2dbSchemeDst_UC
ALTER SYSTEM SET UNDO_RETENTION = 10;
ALTER SYSTEM SET UNDO_RETENTION = 100000;
ALTER SYSTEM SET UNDO_RETENTION = 10;

DROP TABLESPACE E$&&scheme_uc INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;
DROP USER E$&&scheme_uc CASCADE; 
exit;
EOF

sqlplus -s -l "/ as sysdba" <<EOF
set verify off
DEFINE logPath = $App_c2dbLogPath
DEFINE dataPath = $App_c2dbDataPath
DEFINE scheme_lc = $App_c2dbSchemeDst_LC
DEFINE scheme_uc = $App_c2dbSchemeDst_UC
DEFINE sysPassword = $sysPassword
DEFINE systemPassword = $sysPassword
DEFINE ecorePassword = $ecorePassword
DEFINE exmlPassword = $exmlPassword
DEFINE eschemePassword = $eschemePassword
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/6.datafiles_init_schema.sql
exit;
EOF
else
    exit 1
fi

