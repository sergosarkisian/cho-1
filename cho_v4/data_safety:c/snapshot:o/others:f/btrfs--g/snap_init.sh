#!/bin/bash

if [[ -z $DIR_PATH ]]; then
    echo "Please specify dir for snap"
    if [[ -z $1 ]]; then exit 1; else DIR_PATH=$1; fi
fi

TMP_QGROUP_LIST="/tmp/btrfs_${BTRFS_LABEL}_qgroup_all"
SNAP_PATH="${DIR_PATH}_snap"
BTRFS_LABEL=`btrfs filesystem label $DIR_PATH`
BTRFS_DEV=`btrfs filesystem show storage|grep "/dev/"|awk '{print $8}'`
BTRFS_MOUNT=`mount|grep $BTRFS_DEV|awk '{print $3"/"}'`
BTRFS_SNAP_PATH_REL=${SNAP_PATH#"$BTRFS_MOUNT"}
QGROUP_ALL=`btrfs qgroup show $BTRFS_MOUNT -re > $TMP_QGROUP_LIST` 
DATE=`date +%d.%m.%y_%H:%M:%S`
