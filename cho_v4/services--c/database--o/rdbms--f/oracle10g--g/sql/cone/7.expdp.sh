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

! expdp SYSTEM/${App_c2dbsysPassword}@App_c2dbSchemeSrc.pool schemas=E\$${App_c2dbSchemeSrc} directory=export dumpfile=e${App_c2dbSchemeSrc}_${Date}.expdp.dump logfile=e${App_c2dbSchemeSrc}_export_${Date}.dump.log
if [[ $App_c2dbSchemeECoreImport == "Yes" ]]; then
    ! expdp SYSTEM/${App_c2dbsysPassword}@App_c2dbSchemeSrc.pool schemas=E\$CORE directory=export dumpfile=ecore_$Date.expdp.dump logfile=ecore_export_$Date.dump.log
fi
