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
set -e

SnapQGroupRead () {
    BTRFS_MOUNT=$1 
    TMP_QGROUP_LIST=$2
    btrfs qgroup show $BTRFS_MOUNT -re > $TMP_QGROUP_LIST
}

SnapSubvolumeRead () {
    BTRFS_MOUNT=$1 
    TMP_SUB_LIST=$2
    btrfs subvolume list $BTRFS_MOUNT > $TMP_SUB_LIST
}

SnapCreateBaseQgroup () {  
    SnapUnitQgroupId="$SnapUnitDigit/${BTRFS_PATH_ID}0000"
    ! SnapUnitQgroup=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$SnapUnitQgroupId$" -n`
    if ! [[  -n "${SnapUnitQgroup-unset}" ]]; then btrfs qgroup create  $SnapUnitQgroupId $SNAP_PATH; 
        if ! [[ $SnapUnitNaming == "root" ]]; then btrfs qgroup assign $SnapUnitQgroupId  $ROOT_QGROUP_ID  $SNAP_PATH; fi
    fi
    if ! [[ $SnapUnitNaming == "" ]] && ! [[ $SnapUnitNaming == "root" ]]; then
        if [[ ! -e $SNAP_PATH/$SnapUnitDigit.$SnapUnitNaming ]]; then btrfs subvolume create -i $SnapUnitQgroupId $SNAP_PATH/$SnapUnitDigit.$SnapUnitNaming; fi        
    fi
}

SnapDo () {
    . /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snap_init.sh

    curr_path="$SNAP_PATH/$SnapUnitDigitUnsorted.$SnapUnitNamingUnsorted/$DATE"
    mkdir -p $DIR_PATH $curr_path
    #btrfs subvolume snapshot -i $REGISTRED_QGROUP_ID  $DIR_PATH $curr_path/
    btrfs subvolume snapshot $DIR_PATH $curr_path/
    SnapSubvolumeRead $BTRFS_MOUNT $TMP_SUB_LIST
    BTRFS_SNAP_PATH_REL=${curr_path#"$BTRFS_MOUNT"}
    BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\/" $TMP_SUB_LIST|awk '{print $2}'`
    ! btrfs qgroup assign --no-rescan $BTRFS_SNAP_PATH_ID $SnapUnitDigitUnsorted/${BTRFS_PATH_ID}0000  $curr_path/    
}

SnapDelete () {
    BTRFS_SNAP_PATH_REL=${curr_path#"$BTRFS_MOUNT"}
    BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\$" $TMP_SUB_LIST|awk '{print $2}'`
    btrfs subvolume delete -c $curr_path
    ! btrfs qgroup destroy $BTRFS_SNAP_PATH_ID $BTRFS_MOUNT;
    rmdir ${curr_path%/*}
}

SnapSchedParse () {
    declare -A k v SnapSchedArray
    input_serialised=$1

    arr=(${input_serialised//--/ }) 
    i=0
    for pairs in ${arr[*]}; do
        if [[ $pairs != ? ]]; then 
            v[${i}]=${pairs}
        else
            k[${i}]=${pairs}
            (( ++i))
        fi
    done
    
    i=0
    for kv in ${k[*]}; do   
        SnapSchedArray[${kv}]=${v[$i]}
               (( ++i))
   done
}
