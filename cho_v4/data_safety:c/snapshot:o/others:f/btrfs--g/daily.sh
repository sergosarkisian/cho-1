#!/bin/bash

. /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap_init.sh

TMP_SUB_LIST="/tmp/btrfs_${BTRFS_LABEL}_sub_all"

DAILY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "1/$((QGROUP+2))$" -n`
if ! [[  -n "${ROOT_QGROUP-unset}" ]]; then btrfs qgroup create  1/$((QGROUP+2)) $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/daily ]]; then btrfs subvolume create -i 1/$((QGROUP+2)) $SNAP_PATH/daily; fi
#
WEEKLY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "1/$((QGROUP+3))$" -n`
if ! [[  -n "${ROOT_QGROUP-unset}" ]]; then btrfs qgroup create  1/$((QGROUP+3)) $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/weekly ]]; then btrfs subvolume create -i 1/$((QGROUP+3)) $SNAP_PATH/weekly; fi
#

#BASE MIGRATION - FROM _unsorted to daily
DAYLY_SNAP_MV=`ls $SNAP_PATH/_unsorted/|tail -n1`
if [[ -n "$DAYLY_SNAP_MV" ]]; then

    for path in $SNAP_PATH/daily/`date +%d.%m.%y`_*/*; do
        [ -d "${path}" ] || continue # if not a directory, skip
        BTRFS_SNAP_PATH_REL=${path#"$BTRFS_MOUNT"}
        BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\$" $TMP_SUB_LIST|awk '{print $2}'`
        btrfs subvolume delete -c $path
        btrfs qgroup destroy $BTRFS_SNAP_PATH_ID $BTRFS_MOUNT;
        rm -f ${path%/*}
    done
    
    mv  $SNAP_PATH/_unsorted/$DAYLY_SNAP_MV  $SNAP_PATH/daily
    btrfs subvolume list $BTRFS_MOUNT > $TMP_SUB_LIST

    for path in $SNAP_PATH/_unsorted/*/*; do
        [ -d "${path}" ] || continue # if not a directory, skip
        BTRFS_SNAP_PATH_REL=${path#"$BTRFS_MOUNT"}
        BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\$" $TMP_SUB_LIST|awk '{print $2}'`
        btrfs subvolume delete -c $path
        btrfs qgroup destroy $BTRFS_SNAP_PATH_ID $BTRFS_MOUNT;
        rm -f $path
    done
fi
#
