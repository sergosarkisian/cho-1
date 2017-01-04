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
QGROUP=$BTRFS_PATH_ID

### ROOT_QGROUP ###
ROOT_QGROUP_ID="10/${QGROUP}0000"
! ROOT_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$ROOT_QGROUP_ID$" -n`
if [[ ! -e $SNAP_PATH ]]; then btrfs subvolume create $SNAP_PATH; fi
if ! [[  -n "${ROOT_QGROUP-unset}" ]]; then btrfs qgroup create  $ROOT_QGROUP_ID $SNAP_PATH; fi
BTRFS_SNAP_PATH_ID=`btrfs subvolume show $SNAP_PATH|grep "Subvolume ID:"|awk '{print $3}'`
#

### REGISTRED_QGROUP ###
REGISTRED_QGROUP_ID="1/${QGROUP}0000"
! REGISTRED_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$REGISTRED_QGROUP_ID$" -n`
if ! [[  -n "${REGISTRED_QGROUP-unset}" ]]; then btrfs qgroup create  $REGISTRED_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $REGISTRED_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
###

### UNSORTED_QGROUP ###
UNSORTED_QGROUP_ID="2/${QGROUP}0000"
! UNSORTED_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$UNSORTED_QGROUP_ID$" -n`
if ! [[  -n "${UNSORTED_QGROUP-unset}" ]]; then btrfs qgroup create  $UNSORTED_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $UNSORTED_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/_unsorted ]]; then btrfs subvolume create -i $UNSORTED_QGROUP_ID $SNAP_PATH/_unsorted; fi
###

### TRASH_QGROUP ###
TRASH_QGROUP_ID="9/${QGROUP}0000"
! TRASH_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$TRASH_QGROUP_ID$" -n`
if ! [[  -n "${TRASH_QGROUP-unset}" ]]; then btrfs qgroup create  $TRASH_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $TRASH_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
if [[ ! -e $SNAP_PATH/8.trash ]]; then btrfs subvolume create -i $TRASH_QGROUP_ID $SNAP_PATH/8.trash; fi
###

case $SnapUnit in

    "MIN")
        ### MINUTELY_QGROUP ###
        MINUTELY_QGROUP_ID="3/${QGROUP}0000"
        ! MINUTELY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$MINUTELY_QGROUP_ID$" -n`
        if ! [[  -n "${MINUTELY_QGROUP-unset}" ]]; then btrfs qgroup create  $MINUTELY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $MINUTELY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
        if [[ ! -e $SNAP_PATH/2.minutely ]]; then btrfs subvolume create -i $MINUTELY_QGROUP_ID $SNAP_PATH/2.minutely; fi
        ###    
    ;;
    
    "H")
        ### HOURLY_QGROUP ###
        HOURLY_QGROUP_ID="4/${QGROUP}0000"
        ! HOURLY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$HOURLY_QGROUP_ID$" -n`
        if ! [[  -n "${HOURLY_QGROUP-unset}" ]]; then btrfs qgroup create  $HOURLY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $HOURLY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
        if [[ ! -e $SNAP_PATH/3.hourly ]]; then btrfs subvolume create -i $HOURLY_QGROUP_ID $SNAP_PATH/3.hourly; fi
        ###    
    ;;
    
    "D")
        ### DAILY_QGROUP ###
        DAILY_QGROUP_ID="5/${QGROUP}0000"        
        ! DAILY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$DAILY_QGROUP_ID$" -n`
        if ! [[  -n "${DAILY_QGROUP-unset}" ]]; then btrfs qgroup create  $DAILY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $DAILY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
        if [[ ! -e $SNAP_PATH/4.daily ]]; then btrfs subvolume create -i $DAILY_QGROUP_ID $SNAP_PATH/4.daily; fi
        ###
    ;;
    
    "W")
        ### WEEKELY_QGROUP ###
        WEEKELY_QGROUP_ID="6/${QGROUP}0000"
        ! WEEKELY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$WEEKELY_QGROUP_ID$" -n`
        if ! [[  -n "${WEEKELY_QGROUP-unset}" ]]; then btrfs qgroup create  $WEEKELY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $WEEKELY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
        if [[ ! -e $SNAP_PATH/5.weekly ]]; then btrfs subvolume create -i $WEEKELY_QGROUP_ID $SNAP_PATH/5.weekly; fi
        ###    
    ;;
    
    "M")
        ### MONTHLY_QGROUP ###
        MONTHLY_QGROUP_ID="7/${QGROUP}0000"
        ! MONTHLY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$MONTHLY_QGROUP_ID$" -n`
        if ! [[  -n "${MONTHLY_QGROUP-unset}" ]]; then btrfs qgroup create  $MONTHLY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $MONTHLY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
        if [[ ! -e $SNAP_PATH/6.monthly ]]; then btrfs subvolume create -i $MONTHLY_QGROUP_ID $SNAP_PATH/6.monthly; fi
        ###    
    ;;
    
    "Y")
        ### YEARLY_QGROUP ###
        YEARLY_QGROUP_ID="8/${QGROUP}0000"
        ! YEARLY_QGROUP=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$YEARLY_QGROUP_ID$" -n`
        if ! [[  -n "${YEARLY_QGROUP-unset}" ]]; then btrfs qgroup create  $YEARLY_QGROUP_ID $SNAP_PATH; btrfs qgroup assign $YEARLY_QGROUP_ID  $ROOT_QGROUP_ID  $SNAP_PATH; fi
        if [[ ! -e $SNAP_PATH/7.yearly ]]; then btrfs subvolume create -i $YEARLY_QGROUP_ID $SNAP_PATH/7.yearly; fi
        ###        
    ;;
    
    *)
        echo "No such SnapUnit!! Failed! "
        exit 1
    ;;
esac

mkdir -p $DIR_PATH $SNAP_PATH/_unsorted/$DATE
btrfs subvolume snapshot -i $REGISTRED_QGROUP_ID  $DIR_PATH $SNAP_PATH/_unsorted/$DATE/
SnapSubvolumeRead $BTRFS_MOUNT $TMP_SUB_LIST
#BTRFS_SNAP_PATH_ID=`grep  "$DIR_PATH $SNAP_PATH/_unsorted/$DATE\/" $TMP_SUB_LIST|awk '{print $2}'`    
#btrfs qgroup assign $BTRFS_SNAP_PATH_ID $UNSORTED_QGROUP_ID  $SNAP_PATH/_unsorted/$DATE/    

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
