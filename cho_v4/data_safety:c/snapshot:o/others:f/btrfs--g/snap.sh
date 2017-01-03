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
. /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap_init.sh

QGROUP=`btrfs subvolume show $DIR_PATH|grep "Subvolume ID:"|awk '{print $3}'`

UNSORTED_QGROUP_ID="1/$((QGROUP+9990))"
MINUTELY_QGROUP_ID="2/$((QGROUP+9990))"
HOURLY_QGROUP_ID="3/$((QGROUP+9990))"
DAILY_QGROUP_ID="4/$((QGROUP+9990))"
WEEKELY_QGROUP_ID="5/$((QGROUP+9990))"
MONTHLY_QGROUP_ID="6/$((QGROUP+9990))"
YEARLY_QGROUP_ID="7/$((QGROUP+9990))"
TRASH_QGROUP_ID="8/$((QGROUP+9990))"
ROOT_QGROUP_ID="9/$((QGROUP+9990))"

### ROOT_QGROUP ###
! ROOT_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$ROOT_QGROUP_ID$" -n`
if ! [[  -n "${ROOT_QGROUP-unset}" ]]; then btrfs qgroup create  $ROOT_QGROUP_ID $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH ]]; then btrfs subvolume create -i $ROOT_QGROUP_ID $SNAP_PATH; fi
#

### UNSORTED_QGROUP ###
! UNSORTED_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$UNSORTED_QGROUP_ID$" -n`
if ! [[  -n "${UNSORTED_QGROUP-unset}" ]]; then btrfs qgroup create  $UNSORTED_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $UNSORTED_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/_unsorted ]]; then btrfs subvolume create -i $UNSORTED_QGROUP_ID $SNAP_PATH/_unsorted; fi
###

### MONTHLY_QGROUP ###
! MONTHLY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$MONTHLY_QGROUP_ID$" -n`
if ! [[  -n "${MONTHLY_QGROUP-unset}" ]]; then btrfs qgroup create  $MONTHLY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $MONTHLY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/6.monthly ]]; then btrfs subvolume create -i $MONTHLY_QGROUP_ID $SNAP_PATH/6.monthly; fi
###

### WEEKELY_QGROUP ###
! WEEKELY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$WEEKELY_QGROUP_ID$" -n`
if ! [[  -n "${WEEKELY_QGROUP-unset}" ]]; then btrfs qgroup create  $WEEKELY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $WEEKELY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/5.weekly ]]; then btrfs subvolume create -i $WEEKELY_QGROUP_ID $SNAP_PATH/5.weekly; fi
###

### DAILY_QGROUP ###
! DAILY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$DAILY_QGROUP_ID$" -n`
if ! [[  -n "${DAILY_QGROUP-unset}" ]]; then btrfs qgroup create  $DAILY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $DAILY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/4.daily ]]; then btrfs subvolume create -i $DAILY_QGROUP_ID $SNAP_PATH/4.daily; fi
###

### HOURLY_QGROUP ###
! HOURLY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$HOURLY_QGROUP_ID$" -n`
if ! [[  -n "${HOURLY_QGROUP-unset}" ]]; then btrfs qgroup create  $HOURLY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $HOURLY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/3.hourly ]]; then btrfs subvolume create -i $HOURLY_QGROUP_ID $SNAP_PATH/3.hourly; fi
###

### MINUTELY_QGROUP ###
! MINUTELY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$MINUTELY_QGROUP_ID$" -n`
if ! [[  -n "${MINUTELY_QGROUP-unset}" ]]; then btrfs qgroup create  $MINUTELY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $MINUTELY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/2.minutely ]]; then btrfs subvolume create -i $MINUTELY_QGROUP_ID $SNAP_PATH/2.minutely; fi
###

### TRASH_QGROUP ###
! TRASH_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$TRASH_QGROUP_ID$" -n`
if ! [[  -n "${TRASH_QGROUP-unset}" ]]; then btrfs qgroup create  $TRASH_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $TRASH_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/2.minutely ]]; then btrfs subvolume create -i $TRASH_QGROUP_ID $SNAP_PATH/2.minutely; fi
###

BTRFS_SNAP_PATH_ID=`btrfs subvolume list $BTRFS_MOUNT|grep  "$BTRFS_SNAP_PATH_REL\$" |awk '{print $2}'`

mkdir -p $DIR_PATH $SNAP_PATH/_unsorted/$DATE
btrfs subvolume snapshot -i $UNSORTED_QGROUP_ID  $DIR_PATH $SNAP_PATH/_unsorted/$DATE/

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
