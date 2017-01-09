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
. /media/storage/as/oracle/conf/_context/env.sh
. /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/func.sh


if ! [[ `id -un` == "oracle" ]]; then echo "Please run as 'oracle' user! Exit."; exit 1; fi

Date=`date +%Y_%m_%d_%H-%M-%S`

if [[ -z $App_c2dbTask ]]; then
    DialogMsg="Please specify operation"
    echo $DialogMsg; select App_c2dbTask in OraInit OraInitWithSchemaImport SchemaImport;  do  break ; done
fi

if [[ -z $App_c2dbFqdnDst ]]; then
    DialogMsg="Please specify Oracle server FQDN/IP (DST)"   
    echo $DialogMsg; read App_c2dbFqdnDst
fi

if [[ -z $SID ]]; then
    DialogMsg="Please specify Oracle server SID (DST)"   
    echo $DialogMsg; read SID
fi

if [[ -z $App_c2dbSchemeDst ]]; then
    DialogMsg="Please specify scheme name (DST)"   
    echo $DialogMsg; read App_c2dbSchemeDst
fi
App_c2dbSchemeDst_LC=${App_c2dbSchemeDst,,}
App_c2dbSchemeDst_UC=${App_c2dbSchemeDst^^}

if [[ $App_c2dbTask == "OraInitWithSchemaImport" ]] || [[ $App_c2dbTask == "SchemaImport" ]]; then

    if [[ -z $App_c2dbFqdnSrc ]]; then
        DialogMsg="Please specify Source Oracle server FQDN/IP (SRC)"   
        echo $DialogMsg; read App_c2dbFqdnSrc
    fi

    if [[ -z $App_c2dbSchemeSrc ]]; then
        DialogMsg="Please specify source scheme name (SRC)"   
        echo $DialogMsg; read App_c2dbSchemeSrc
    fi
    App_c2dbSchemeSrc_LC=${App_c2dbSchemeSrc,,}
    App_c2dbSchemeSrc_UC=${App_c2dbSchemeSrc^^}
    
    if ! [[ $App_c2dbSchemeDst == $App_c2dbSchemeSrc ]]; then App_c2dbSchemeRemap="Yes"; fi
fi

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
    ecorePassword=$conePassword
    exmlPassword=$conePassword
    eschemePassword=$conePassword
###

### EXEC 

ssh  - login/pass/port
expect


case $App_c2dbTask in
    "OraInit")
    App_c2dbPlatform $App_c2dbFqdnDst
    . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_pre.sh
    . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_schema_tbs.sh
    . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_post.sh
    . /post
    ;;
    "OraInitWithSchemaImport") 
        $App_c2dbSchemeECoreImport="Yes"
        App_c2dbPlatform $App_c2dbFqdnDst
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/pre.sh
        SchemaImport

    ;;
    "SchemaImport") 
        App_c2dbPlatform $App_c2dbFqdnDst    
        SchemaImport
    ;;    
esac

SchemaImport () {
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_schema_tbs.sh
        App_c2dbPlatform $App_c2dbFqdnSrc
        
        echo "App_c2dbSchemeSrc=$App_c2dbSchemeSrc" > /tmp/expdp.env
        echo "Date=$Date" >> /tmp/expdp.env
        echo "App_c2dbSchemeECoreImport=$App_c2dbSchemeECoreImport" >> /tmp/expdp.env
        scp /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/7.expdp.sh oracle@$App_c2dbFqdnSrc:/tmp/7.expdp.sh
        ssh oracle@$App_c2dbFqdnSrc export /tmp/expdp.env; sh -x /tmp/7.expdp.sh
        
        expPath=$App_c2dbExportPath
        App_c2dbPlatform $App_c2dbFqdnDst
        scp oracle@$App_c2dbFqdnSrc:$expPath/e$App_c2dbSchemeSrc_$Date.expdp.dump $App_c2dbImportPath/
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/8.impdp.sh    
        cp $App_c2dbTnsPath/tnsnames.ora $App_c2dbTnsPath/tnsnames.ora.bkp
        TnsName="cc_dst2src.pool" ; HOST="$App_c2dbFqdnSrc" ; PORT="1521" ;
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/tnsnames.ora > $App_c2dbTnsPath/tnsnames.ora
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_cc.sh        
        cp $App_c2dbTnsPath/tnsnames.ora.bkp $App_c2dbTnsPath/tnsnames.ora
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_post.sh
}

###
