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

 App_c2dbPlatform () {
 
 App_c2dbNaming=$1
 
if [[ $App_c2dbNaming =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    App_c2dbFqdn=`ssh -p1000 oracle@$App_c2dbNaming hostname -f`
else
    App_c2dbFqdn=$App_c2dbNaming
fi
 
 if [[ $App_c2dbFqdn =~ in4.*-suse-l ]]; then
    App_c2dbDstPlatform="in4"
elif [[ $App_c2dbFqdn =~ .*rev4 ]]; then
    App_c2dbDstPlatform="rev4"
else
    App_c2dbDstPlatform="custom"
fi

    case $App_c2dbDstPlatform in
        "in4")
        App_c2dbLogPath="/media/storage/as/oracle/logs/cone"
        App_c2dbDataPath="/media/storage/as/oracle/data/master"
        App_c2dbExportPath="/media/storage/as/oracle/data/export"
        App_c2dbImportPath="/media/storage/as/oracle/data/import"
        App_c2dbTnsPath="/media/storage/as/oracle/conf/_context"
        ;;

        "rev4")
        App_c2dbLogPath="/media/storage/database/oracle/$SID/manage/debug/cone"
        App_c2dbDataPath="/media/storage/database/oracle/$SID/data/main/"
        App_c2dbExportPath="/media/storage/database/oracle/$SID/devel/export"
        App_c2dbImportPath="/media/storage/database/oracle/$SID/devel/import"
        App_c2dbTnsPath="/opt/oracle/product/10g/network/admin/"        
        ;;

        *)
        exit 1
        ;;
    esac
}

SchemaImport () {
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_schema_tbs.sh
        App_c2dbPlatform $App_c2dbFqdnSrc
        expPath=$App_c2dbExportPath
        
        cp $App_c2dbTnsPath/tnsnames.ora $App_c2dbTnsPath/tnsnames.ora.bkp
        TnsName="App_c2dbSchemeSrc.pool" ; HOST="$App_c2dbFqdnSrc" ; PORT="1521" ;
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/tnsnames.ora >> $App_c2dbTnsPath/tnsnames.ora        
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/7.expdp.sh
        App_c2dbPlatform $App_c2dbFqdnDst
        scp -P1000 oracle@${App_c2dbFqdnSrc}:${expPath}/e${App_c2dbSchemeSrc}_${Date}.expdp.dump $App_c2dbImportPath/
        if [[ $App_c2dbSchemeECoreImport == "Yes" ]]; then
            scp -P1000 oracle@${App_c2dbFqdnSrc}:${expPath}/ecore_${Date}.expdp.dump $App_c2dbImportPath/        
        fi
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/8.impdp.sh    
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_cc.sh        
        cp $App_c2dbTnsPath/tnsnames.ora.bkp $App_c2dbTnsPath/tnsnames.ora
        . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/_post.sh
}


        
