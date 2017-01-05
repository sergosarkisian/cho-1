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

if [[ -z $DIR_PATH ]]; then echo "Please specify dir for snap";  exit 1;  fi
if [[ -z $SnapSched ]]; then  echo "Please specify schedule";  exit 1; fi

### INIT ###
BTRFS_LABEL=`btrfs filesystem label $DIR_PATH`
TMP_QGROUP_LIST="/tmp/btrfs_${BTRFS_LABEL}_qgroup_all"
TMP_SUB_LIST="/tmp/btrfs_${BTRFS_LABEL}_sub_all"
TMP_QGROUP_LIST_EMPTY="/tmp/btrfs_${BTRFS_LABEL}_qgroup_all_empty"
BTRFS_PATH_ID=`btrfs subvolume show $DIR_PATH|grep "Subvolume ID:"|awk '{print $3}'`
SNAP_PATH="${DIR_PATH}_snap"
BTRFS_DEV=`btrfs filesystem show $BTRFS_LABEL|grep "/dev/"|awk '{print $8}'`
BTRFS_MOUNT=`mount|grep $BTRFS_DEV -m1|awk '{print $3"/"}'`
if [[ $BTRFS_MOUNT == "//" ]]; then  BTRFS_MOUNT="/";  fi
BTRFS_SNAP_PATH_REL=${SNAP_PATH#"$BTRFS_MOUNT"}
SnapQGroupRead  $BTRFS_MOUNT $TMP_QGROUP_LIST
DATE=`date +%d.%m.%y_%H:%M:%S`
###SNAP UNIT VARS
#Hourly
    SnapUnitDigitHourly=4
    SnapUnitNamingHourly="hourly"        
    SnapUnitTimingCriteriaHourly=`date +%d.%m.%y_%H:`
#Daily
    SnapUnitDigitDaily=5
    SnapUnitDaily="daily"
    SnapUnitTimingCriteriaDaily=`date +%d.%m.%y_`
#Unsorted
    SnapUnitDigitUnsorted=2
    SnapUnitNamingUnsorted="unsorted"
###

### ROOT_QGROUP ###
    SnapUnitDigit=10
    SnapUnitNaming="root"
    SnapCreateBaseQgroup
###

### REGISTRED_QGROUP ###
    SnapUnitDigit=1
    SnapUnitNaming=""
    SnapCreateBaseQgroup
###

### UNSORTED_QGROUP ###
    SnapUnitDigit=2
    SnapUnitNaming="unsorted"
    SnapCreateBaseQgroup
###

### TRASH_QGROUP ###
    SnapUnitDigit=8
    SnapUnitNaming="trash"
    SnapCreateBaseQgroup
###

if ! [[ -z ${SnapSchedArray[h]} ]]; then
        SnapUnitDigit=$SnapUnitDigitHourly
        SnapUnitNaming=$SnapUnitNamingHourly
        SnapUnitTimingCriteria=$SnapUnitTimingCriteriaHourly
        SnapScope=${SnapSchedArray[h]}
        SnapCreateBaseQgroup
        BTRFS_SNAP_PATH_ID=`btrfs subvolume show $SNAP_PATH|grep "Subvolume ID:"|awk '{print $3}'`
        SnapDo        
        SnapUnitPath="$SNAP_PATH/$SnapUnitDigit.$SnapUnitNaming/${SnapUnitTimingCriteria}*"        
elif ! [[ -z ${SnapSchedArray[d]} ]]; 
        SnapUnitDigit=$SnapUnitDigitDaily
        SnapUnitNaming=$SnapUnitNamingDaily
        SnapUnitTimingCriteria=$SnapUnitTimingCriteriaDaily
        SnapScope=${SnapSchedArray[d]}
        SnapCreateBaseQgroup
        BTRFS_SNAP_PATH_ID=`btrfs subvolume show $SNAP_PATH|grep "Subvolume ID:"|awk '{print $3}'`
        SnapDo      
        SnapUnitPath="$SNAP_PATH/$SnapUnitDigit.$SnapUnitNaming/${SnapUnitTimingCriteria}*"
fi
   
SnapUnsorted=`ls $SNAP_PATH/$SnapUnitDigitUnsorted.$SnapUnitNamingUnsorted/|tail -n1`
if [[ -n "$SnapUnsorted" ]]; then

    for curr_path in $SnapUnitPath/*; do
        [ -d "${curr_path}" ] || continue # if not a directory, skip
        echo "Managing $curr_path"
        SnapDelete
    done
    
    ###  MIGRATION TO POOL ###
        SnapSubvolumeRead $BTRFS_MOUNT $TMP_SUB_LIST
        curr_path=$SNAP_PATH/$SnapUnitDigitUnsorted.$SnapUnitNamingUnsorted/$SnapUnsorted
        BTRFS_SNAP_PATH_REL=${curr_path#"$BTRFS_MOUNT"}
        BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\/" $TMP_SUB_LIST|awk '{print $2}'`    
        ! btrfs qgroup remove $BTRFS_SNAP_PATH_ID $UNSORTED_QGROUP_ID $BTRFS_MOUNT;    
        ! btrfs qgroup assign --no-rescan $BTRFS_SNAP_PATH_ID $SnapUnitQgroupId  $SNAP_PATH    
        mv  $curr_path  $SNAP_PATH/$SnapUnitDigit.$SnapUnitNaming
        SnapSubvolumeRead $BTRFS_MOUNT $TMP_SUB_LIST
    ###
    
    ### SNAP SCOPE  - DELETE OUT OF SCOPE ###
        while [[ `ls -daA $SnapUnitPath|wc -l` -gt $SnapScope ]]; do
            curr_path=`find $SnapUnitPath -type f -exec stat -c "%n" {} \; | sort -n | head -1`
            echo "Deleting $curr_path"
            SnapDelete
        do
    ###
    
    for curr_path in $SNAP_PATH/$SnapUnitDigitUnsorted.$SnapUnitNamingUnsorted/*/*; do
        [ -d "${curr_path}" ] || continue # if not a directory, skip
        echo "Managing $curr_path"        
        SnapDelete
    done
    
    QGROUP_EMPTY=`btrfs qgroup show $BTRFS_MOUNT|grep "0.00B"|awk '{print $1}' > $TMP_QGROUP_LIST_EMPTY`
    
#     for qgroup in `cat $TMP_QGROUP_LIST_EMPTY`; do
#         btrfs qgroup destroy $qgroup $BTRFS_MOUNT
#     done
    
    btrfs quota rescan -w    $BTRFS_MOUNT
fi
#

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
