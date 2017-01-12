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

if  mountpoint -q /media/storage ; then 
    echo "storage disk is in use!!! "
    DialogMsg="Recreate only database part?"   
    echo $DialogMsg; select DataRecreate in No Yes Yes_Recreate;  do  break ; done;    
    if ~ [[ $DataRecreate == "Yes_Recreate" ]]; then
        exit 1
    fi
else
    DialogMsg="!!!   DATA WILL BE DESTROYED ON partition /media/storage !!!!!!!!!!!!!!!!! "   
    echo $DialogMsg; select DataDestroy in No Yes Yes_Destroy;  do  break ; done;
fi

                        
if [[ $DataDestroy == "Yes_Destroy" ]]; then
    mkfs.btrfs -f  -L "storage" /dev/disk/by-label/storage
    rm -rf /dev/disk/by-label/storage/*
    systemctl restart media-storage.mount


    ### AS INIT  ###
    mkdir -p /media/storage/as
    btrfs subvolume create /media/storage/as/oracle
    #data
    mkdir -p /media/storage/as/oracle/data
    btrfs subvolume create /media/storage/as/oracle/data/master
    btrfs subvolume create /media/storage/as/oracle/data/archive
    btrfs subvolume create /media/storage/as/oracle/data/export
    btrfs subvolume create /media/storage/as/oracle/data/import
    #

    #cone
    btrfs subvolume create /media/storage/as/oracle/cone
    mkdir -p /media/storage/as/oracle/cone/plsql_compile
    #

    #logs
    btrfs subvolume create /media/storage/as/oracle/logs
    . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/in4_oracle_init_logs.sh
    #

    #conf
    btrfs subvolume create /media/storage/as/oracle/conf
    mkdir -p /media/storage/as/oracle/conf/_context
    mkdir -p /media/storage/as/oracle/conf/_generated
    #
    
    # misc
    btrfs subvolume create /media/storage/as/oracle/misc/
    mkdir -p /media/storage/as/oracle/misc/flash_recovery_area
    mkdir -p /media/storage/as/oracle/misc/tmp
    #

    mkdir -p /media/storage/as/oracle/home
    
    ##FIX!!!
    setfacl -m g::rx  /media/storage/as/oracle
    setfacl -m o::rx  /media/storage/as/oracle
    setfacl -m g::rx  /media/storage/as
    setfacl -m o::rx  /media/storage/as
    ##
    ###


    ### TS INIT  ###
    mkdir -p /media/storage/ts/services--c/database--o/rdbms--f
    btrfs subvolume create /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw

    mkdir -p /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
    setfacl -R -m u:oracle:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
    setfacl -R -m d:u:oracle:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
    setfacl -R -m g:oinstall:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
    setfacl -R -m d:g:oinstall:rwx /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/

    ##FIX!!
    setfacl -m g::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
    setfacl -m o::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
    setfacl -m g::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw
    setfacl -m o::rx  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw
    setfacl -m g::rx  /media/storage/ts/services--c/database--o/rdbms--f
    setfacl -m o::rx  /media/storage/ts/services--c/database--o/rdbms--f
    setfacl -m g::rx  /media/storage/ts/services--c/database--o
    setfacl -m o::rx  /media/storage/ts/services--c/database--o
    setfacl -m g::rx  /media/storage/ts/services--c/
    setfacl -m o::rx  /media/storage/ts/services--c/
    setfacl -m g::rx  /media/storage/ts
    setfacl -m o::rx  /media/storage/ts
    ##
    ###



    ###  ORACLE USER & PERMS  ###
    chmod 755 /media/storage/as
    chown -R oracle:oinstall /media/storage/as/oracle
    setfacl -R -m u:oracle:rwx /media/storage/as/oracle
    setfacl -R -m d:u:oracle:rwx /media/storage/as/oracle
    setfacl -R -m g:oinstall:rwx /media/storage/as/oracle
    setfacl -R -m d:g:oinstall:rwx /media/storage/as/oracle
    ###


    ### ORACLE DB  ###
    cd  /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
    wget http://public.edss.ee/software/Linux/Oracle/in4_oracle10g--g_ee.tar.gz && tar -xzf ./in4_oracle10g--g_ee.tar.gz
    chown -R oracle:oinstall /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
    ###

    ### CREATE RO SNAPSHOT  ###
    ! btrfs subvolume delete /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g
    btrfs subvolume snapshot -r /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g
    ###

    . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/in4_oracle_init_sshkeys.sh

    
    btrfs quota enable /media/storage    
    
fi


### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
