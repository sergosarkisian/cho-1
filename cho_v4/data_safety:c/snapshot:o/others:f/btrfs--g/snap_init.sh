#!/bin/bash

DIR_PATH=$1
if [[ -z $DIR_PATH ]]; then
    echo "Please specify dir for snap"
    exit 1
fi

QGROUP=$2
[ -z "${QGROUP//[0-9]}" ] && [ -n "$QGROUP" ] || echo "Please specify QGROUP ID"

TMP_QGROUP_LIST="/tmp/btrfs_${BTRFS_LABEL}_qgroup_all"
SNAP_PATH="${DIR_PATH}_snap"
BTRFS_LABEL=`btrfs filesystem label $DIR_PATH`
BTRFS_DEV=`btrfs filesystem show storage|grep "/dev/"|awk '{print $8}'`
BTRFS_MOUNT=`mount|grep $BTRFS_DEV|awk '{print $3"/"}'`
BTRFS_SNAP_PATH_REL=${SNAP_PATH#"$BTRFS_MOUNT"}
QGROUP_ALL=`btrfs qgroup show $BTRFS_MOUNT -re > $TMP_QGROUP_LIST` 
DATE=`date +%d.%m.%y_%H:%M:%S`
