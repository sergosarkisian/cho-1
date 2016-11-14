#!/bin/bash

. /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap_init.sh
. /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap.sh

DAILY_QGROUP_ID="2/$((QGROUP+2))"

DAILY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$DAILY_QGROUP_ID$" -n`
if ! [[  -n "${DAILY_QGROUP-unset}" ]]; then btrfs qgroup create  $DAILY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $DAILY_QGROUP_ID  $UNSORTED_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/daily ]]; then btrfs subvolume create -i $DAILY_QGROUP_ID $SNAP_PATH/daily; fi
#
# WEEKLY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "1/$((QGROUP+3))$" -n`
# if ! [[  -n "${ROOT_QGROUP-unset}" ]]; then btrfs qgroup create  1/$((QGROUP+3)) $SNAP_PATH; fi
# if [[ ! -e $SNAP_PATH/weekly ]]; then btrfs subvolume create -i 1/$((QGROUP+3)) $SNAP_PATH/weekly; fi
#

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
    BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\$" $TMP_SUB_LIST|awk '{print $2}'`    
    btrfs qgroup destroy $BTRFS_SNAP_PATH_ID $BTRFS_MOUNT;    
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
fi
#
