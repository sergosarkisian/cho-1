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
. /media/sysdata/in4/cho/in4_core/internals/helpers/in4func.sh
. /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/func.sh

if [[ -f /media/storage/as/oracle/conf/_context/env.sh ]]; then 
    . /media/storage/as/oracle/conf/_context/env.sh
else
    echo "No Oracle env file - /media/storage/as/oracle/conf/_context/env.sh"
    exit 1
fi


if ! [[ `id -un` == "oracle" ]]; then echo "Please run as 'oracle' user! Exit."; exit 1; fi
#if ! [[ `systemctl is-active in4__oracle10g.service` == "active" ]]; then echo "Please run oracle service - 'systemctl restart in4__oracle10g' "; exit 1; fi ## BUG


Date=`date +%Y_%m_%d_%H-%M-%S`

if [[ -z $App_c2dbTask ]]; then
    DialogMsg="Please specify operation"
    echo $DialogMsg; select App_c2dbTask in c2_minimalDB ECoreImport SchemaImport;  do  break ; done
fi

if [[ -z $App_c2dbFqdnDst ]]; then
    DialogMsg="Please specify Oracle server FQDN/IP (DST)"   
    echo $DialogMsg; select App_c2dbFqdnDst in `hostname -f` manual;  do  break ; done    
    if [[ $App_c2dbFqdnDst == "manual" ]]; then 
        DialogMsg="Please specify Oracle server FQDN/IP (DST) manually: "       
        echo $DialogMsg; read App_c2dbFqdnDst
     fi
fi


if [[ $App_c2dbTask == "ECoreImport" ]] || [[ $App_c2dbTask == "SchemaImport" ]]; then
    if [[ -z $App_c2dbFqdnSrc ]]; then
        DialogMsg="Please specify Source Oracle server FQDN/IP (SRC)"   
        echo $DialogMsg; read App_c2dbFqdnSrc
    fi
    ! ssh-copy-id oracle@$App_c2dbFqdnSrc -p1000
fi


if [[ -z $SID ]]; then
    DialogMsg="Please specify Oracle server SID (DST)"   
    echo $DialogMsg; read SID
fi


case $App_c2dbTask in
    "SchemaImport") 
    
        if [[ -z $App_c2dbSchemeSrc ]]; then
            DialogMsg="Please specify source scheme name (SRC)"   
            echo $DialogMsg; read App_c2dbSchemeSrc
        fi
        App_c2dbSchemeSrc_LC=${App_c2dbSchemeSrc,,}
        App_c2dbSchemeSrc_UC=${App_c2dbSchemeSrc^^}    
    
        if [[ -z $App_c2dbSchemeDst ]]; then
            DialogMsg="Please specify destination scheme name (DST)"   
            echo $DialogMsg; read App_c2dbSchemeDst
        fi
        App_c2dbSchemeDst_LC=${App_c2dbSchemeDst,,}
        App_c2dbSchemeDst_UC=${App_c2dbSchemeDst^^}    
        

        if ! [[ $App_c2dbSchemeDst == $App_c2dbSchemeSrc ]]; then App_c2dbSchemeRemap="Yes"; fi        
    ;;
esac


### PASSWORDS
    if [[ -z $App_c2dbsysPassword ]]; then
        DialogMsg="Please specify sysPassword"   
        echo $DialogMsg; read App_c2dbsysPassword
    fi

    if [[ -z $App_c2dbconePassword ]]; then
        DialogMsg="Please specify conePassword"   
        echo $DialogMsg; read App_c2dbconePassword
    fi

    sysPassword=$App_c2dbsysPassword
    ecorePassword=$App_c2dbconePassword
    exmlPassword=$App_c2dbconePassword
    eschemePassword=$App_c2dbconePassword
###

### EXEC 
case $App_c2dbTask in
    "c2_minimalDB")
    #log_cleaner
        App_c2dbPlatform $App_c2dbFqdnDst
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_pre.sh
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_schema_tbs.sh
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_post.sh
    ;;
    "ECoreImport") 
        App_c2dbSchemeECoreImport="Yes"
        ExpImp
    ;;
    "SchemaImport") 
        ExpImp
    ;;      
esac



### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
