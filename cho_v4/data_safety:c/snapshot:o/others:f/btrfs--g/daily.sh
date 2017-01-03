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

. /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap.sh

TMP_QGROUP_LIST_EMPTY="/tmp/btrfs_${BTRFS_LABEL}_qgroup_all_empty"

#BASE MIGRATION - FROM _unsorted to daily
DAYLY_SNAP_MV=`ls $SNAP_PATH/_unsorted/|tail -n1`
if [[ -n "$DAYLY_SNAP_MV" ]]; then

    for curr_path in $SNAP_PATH/daily/`date +%d.%m.%y`_*/*; do
        [ -d "${curr_path}" ] || continue # if not a directory, skip
        BTRFS_SNAP_PATH_REL=${curr_path#"$BTRFS_MOUNT"}
        BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\$" $TMP_SUB_LIST|awk '{print $2}'`
        btrfs subvolume delete -c $curr_path
        btrfs qgroup destroy $BTRFS_SNAP_PATH_ID $BTRFS_MOUNT;
        rmdir ${curr_path%/*}
    done
    
    ##  MIGRATION WITH QUOTA
    SUB_LIST_ALL=`btrfs subvolume list $BTRFS_MOUNT > $TMP_SUB_LIST`    
    curr_path=$SNAP_PATH/_unsorted/$DAYLY_SNAP_MV
    BTRFS_SNAP_PATH_REL=${curr_path#"$BTRFS_MOUNT"}
    BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\/" $TMP_SUB_LIST|awk '{print $2}'`    
    btrfs qgroup remove $BTRFS_SNAP_PATH_ID $UNSORTED_QGROUP_ID $BTRFS_MOUNT;    
    btrfs qgroup assign $BTRFS_SNAP_PATH_ID $DAILY_QGROUP_ID  $SNAP_PATH    
    mv  $curr_path  $SNAP_PATH/daily
    btrfs subvolume list $BTRFS_MOUNT > $TMP_SUB_LIST
    ##
    
    for curr_path in $SNAP_PATH/_unsorted/*/*; do
        [ -d "${curr_path}" ] || continue # if not a directory, skip
        BTRFS_SNAP_PATH_REL=${curr_path#"$BTRFS_MOUNT"}
        BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\$" $TMP_SUB_LIST|awk '{print $2}'`
        btrfs subvolume delete -c $curr_path
        btrfs qgroup destroy $BTRFS_SNAP_PATH_ID $BTRFS_MOUNT;
        rmdir ${curr_path%/*}
    done
    
    QGROUP_EMPTY=`btrfs qgroup show $BTRFS_MOUNT|grep "0.00B"|awk '{print $1}' > $TMP_QGROUP_LIST_EMPTY`
    
    for qgroup in `cat $TMP_QGROUP_LIST_EMPTY`; do
        btrfs qgroup destroy $qgroup $BTRFS_MOUNT
    done
    
    btrfs quota rescan -w    $BTRFS_MOUNT
fi
#

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
