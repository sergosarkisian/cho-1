#!/bin/bash

. /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap_init.sh

if [[ -z $QGROUP ]]; then
    echo "Please specify QGROUP ID"
    if [[ -z $2 ]]; then exit 1; else QGROUP=$2; fi
fi
if [[  -n "${QGROUP//[0-9]}"  ]]; then echo "Please specify QGROUP ID as integer"; exit 1; fi

ROOT_QGROUP_ID="1/$((QGROUP+0))$"
UNSORTED_QGROUP_ID="2/$((QGROUP+1))"
#
ROOT_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$ROOT_QGROUP_ID$" -n`
if ! [[  -n "${ROOT_QGROUP-unset}" ]]; then btrfs qgroup create  $ROOT_QGROUP_ID $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH ]]; then btrfs subvolume create -i $ROOT_QGROUP_ID $SNAP_PATH; fi
#
UNSORTED_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$UNSORTED_QGROUP_ID$" -n`
if ! [[  -n "${UNSORTED_QGROUP-unset}" ]]; then btrfs qgroup create  $UNSORTED_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $UNSORTED_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/_unsorted ]]; then btrfs subvolume create -i $UNSORTED_QGROUP_ID $SNAP_PATH/_unsorted; fi
#

BTRFS_SNAP_PATH_ID=`btrfs subvolume list $BTRFS_MOUNT|grep  "$BTRFS_SNAP_PATH_REL\$" |awk '{print $2}'`
mkdir -p $DIR_PATH $SNAP_PATH/_unsorted/$DATE
btrfs subvolume snapshot -i $UNSORTED_QGROUP_ID  $DIR_PATH $SNAP_PATH/_unsorted/$DATE/
