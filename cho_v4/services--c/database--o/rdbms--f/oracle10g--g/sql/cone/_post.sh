#!/bin/bash
########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash DSL
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
### IN4 BASH HEADER ###
set -e
PrevDirPath=$CurDirPath; CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="BEGIN -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###

mkdir -p $App_c2dbLogPath

if [[ $App_c2dbSchemeECoreImport == "Yes" ]]; then
sqlplus -s -l "/ as sysdba" <<EOF
set verify off
DEFINE logPath = $App_c2dbLogPath
DEFINE scheme_uc = core
DEFINE sysPassword = $sysPassword
DEFINE ecorePassword = $ecorePassword
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/4.ecore_syn.sql
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/14.post.sql
 exit;
EOF

else

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
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/10.grants.sql
@/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/14.post.sql
 exit;
EOF
fi

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###

