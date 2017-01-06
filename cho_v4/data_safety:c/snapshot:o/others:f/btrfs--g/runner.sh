#!/bin/bash
########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
### IN4 BASH HEADER ###
set -e
PrevDirPath=$CurDirPath; CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="BEGIN -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###

. /media/sysdata/in4/cho/in4_core/internals/naming/naming.sh os
. /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/func.sh
if [[ -z $SnapMode ]]; then
    DialogMsg="Select snapshot mode"   
    echo $DialogMsg; select SnapMode in simple service svn;  do  break ; done;
fi
                
case $SnapMode in
    "simple")
        if [[ -z $SnapDirPath ]]; then echo "Please specify dir for snap";  read $SnapDirPath;  fi
        SnapSched="no"
        SnapStartTime=`date +%s`
        time . /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap_manager.sh	
        SnapEndTime=`date +%s`
        SnapOk
        ;;

    "svn")                
    for SNAP_TASK in /media/sysdata/in4/_context/conf/snapshots/$Net/$SrvType/$SrvName/*; do
        . $SNAP_TASK
        SnapStartTime=`date +%s`
        time . /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap_manager.sh	
        SnapEndTime=`date +%s`
        SnapOk
    done 
    ;;
esac

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
