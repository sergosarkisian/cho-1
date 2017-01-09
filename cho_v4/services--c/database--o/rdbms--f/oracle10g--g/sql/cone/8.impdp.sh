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

if [[ $App_c2dbSchemeECoreImport == "Yes" ]]; then
  !  impdp SYSTEM/${App_c2dbsysPassword} schemas=E\$CORE directory=import dumpfile=ecore_$Date.expdp.dump logfile=ecore_import_$Date.dump.log EXCLUDE=STATISTICS
fi

if [[ $App_c2dbSchemeRemap == "Yes" ]]; then
    App_c2dbSchemeImport="E\$${App_c2dbSchemeSrc}:E\$${App_c2dbSchemeDst} REMAP_TABLESPACE=E\$${App_c2dbSchemeSrc}:E\$${App_c2dbSchemeDst}"
    else
    App_c2dbSchemeImport=""
fi

! impdp SYSTEM/${App_c2dbsysPassword} schemas=E\$${App_c2dbSchemeSrc} directory=import dumpfile=e${App_c2dbSchemeSrc}_${Date}.expdp.dump logfile=e${App_c2dbSchemeSrc}_import_${Date}.dump.log EXCLUDE=STATISTICS  $App_c2dbSchemeImport


### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
