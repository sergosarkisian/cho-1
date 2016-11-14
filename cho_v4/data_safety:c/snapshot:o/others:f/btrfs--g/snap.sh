#!/bin/bash

. /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap_init.sh

QGROUP=$2
[ ! -z "$QGROUP" ] && [ ! -n "$QGROUP" ] || echo "Please specify QGROUP ID"; exit 1

#
ROOT_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "1/$((QGROUP+0))$" -n`
if ! [[  -n "${ROOT_QGROUP-unset}" ]]; then btrfs qgroup create  1/$((QGROUP+0)) $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH ]]; then btrfs subvolume create -i 1/$((QGROUP+0)) $SNAP_PATH; fi
#
UNSORTED_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "1/$((QGROUP+1))$" -n`
if ! [[  -n "${ROOT_QGROUP-unset}" ]]; then btrfs qgroup create  1/$((QGROUP+1)) $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/_unsorted ]]; then btrfs subvolume create -i 1/$((QGROUP+1)) $SNAP_PATH/_unsorted; fi
#

BTRFS_SNAP_PATH_ID=`btrfs subvolume list $BTRFS_MOUNT|grep  "$BTRFS_SNAP_PATH_REL\$" |awk '{print $2}'`
btrfs subvolume snapshot -i 1/$((QGROUP+1))  $DIR_PATH $SNAP_PATH/_unsorted/$DATE
BTRFS_SNAP_ID=`btrfs subvolume list $BTRFS_MOUNT|grep "$BTRFS_SNAP_PATH_REL/$DATE\$" |awk '{print $2}'`
