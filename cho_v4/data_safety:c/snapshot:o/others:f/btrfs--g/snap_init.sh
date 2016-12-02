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

if [[ -z $DIR_PATH ]]; then
    echo "Please specify dir for snap"
    if [[ -z $1 ]]; then exit 1; else DIR_PATH=$1; fi
fi

SNAP_PATH="${DIR_PATH}_snap"
BTRFS_LABEL=`btrfs filesystem label $DIR_PATH`
#
TMP_QGROUP_LIST="/tmp/btrfs_${BTRFS_LABEL}_qgroup_all"
TMP_SUB_LIST="/tmp/btrfs_${BTRFS_LABEL}_sub_all"
#
BTRFS_DEV=`btrfs filesystem show $BTRFS_LABEL|grep "/dev/"|awk '{print $8}'`
BTRFS_MOUNT=`mount|grep $BTRFS_DEV -m1|awk '{print $3"/"}'`
if [[ $BTRFS_MOUNT == "//" ]]; then  BTRFS_MOUNT="/";  fi
BTRFS_SNAP_PATH_REL=${SNAP_PATH#"$BTRFS_MOUNT"}
QGROUP_ALL=`btrfs qgroup show $BTRFS_MOUNT -re > $TMP_QGROUP_LIST` 
DATE=`date +%d.%m.%y_%H:%M:%S`

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
