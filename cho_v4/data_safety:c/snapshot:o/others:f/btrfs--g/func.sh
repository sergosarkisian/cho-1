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
    ! SnapUnitQgroup=`cat $TMP_QGROUP_LIST | awk '{print $1}' | grep "$SnapUnitQgroupId$"`
    if ! [[  -n "${SnapUnitQgroup-unset}" ]]; then btrfs qgroup create  $SnapUnitQgroupId $SNAP_PATH; 
        if ! [[ $SnapUnitNaming == "root" ]]; then btrfs qgroup assign $SnapUnitQgroupId  "$SnapUnitDigitRoot/${BTRFS_PATH_ID}0000"  $SNAP_PATH; fi
        SnapQGroupRead  $BTRFS_MOUNT $TMP_QGROUP_LIST
    fi
    
    if  [[ $SnapUnitNaming == "_none_" ]] || [[ $SnapUnitNaming == "root" ]] ; then
        echo "No dirs will be created"
    else
        if [[ ! -e $SNAP_PATH/$SnapUnitDigit.$SnapUnitNaming ]]; then mkdir -p $SnapUnitQgroupId $SNAP_PATH/$SnapUnitDigit.$SnapUnitNaming; fi        
    fi
}

SnapDo () {
    if [[ $SnapMode == "manual" ]] ; then
        SnapPathUnitNaming="$SnapUnitDigitManual.$SnapUnitNamingManual"
        SnapUnitDigitQAssign=$SnapUnitDigitManual
    else
        SnapPathUnitNaming="$SnapUnitDigitUnsorted.$SnapUnitNamingUnsorted"
        SnapUnitDigitQAssign=$SnapUnitDigitUnsorted
    fi
    SnapPathFQ="$SNAP_PATH/$SnapPathUnitNaming/$DATE"
    mkdir -p $SnapDirPath $SnapPathFQ
    #btrfs subvolume snapshot -i $REGISTRED_QGROUP_ID  $SnapDirPath $SnapPathFQ/
    btrfs subvolume snapshot $SnapDirPath $SnapPathFQ/
    SnapSubvolumeRead $BTRFS_MOUNT $TMP_SUB_LIST
    BTRFS_SNAP_PATH_REL=${SnapPathFQ#"$BTRFS_MOUNT"}
    BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\/" $TMP_SUB_LIST|awk '{print $2}'`
    SnapAssign="$SnapUnitDigitQAssign/${BTRFS_PATH_ID}0000"
    ! btrfs qgroup assign --no-rescan $BTRFS_SNAP_PATH_ID $SnapAssign  $SnapPathFQ/    
    echo "Snap is created & assigned to $SnapAssign"
}

SnapDelete () {
    BTRFS_SNAP_PATH_REL=${curr_path#"$BTRFS_MOUNT"}
    BTRFS_SNAP_PATH_ID=`grep  "$BTRFS_SNAP_PATH_REL\$" $TMP_SUB_LIST|awk '{print $2}'`
    btrfs subvolume delete -c $curr_path
    ! btrfs qgroup destroy $BTRFS_SNAP_PATH_ID $BTRFS_MOUNT
    rmdir ${curr_path%/*}
}

SnapSchedParse () {
    input_serialised=$1
    if ! [[ $input_serialised == "no" ]]; then
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
    fi
}

SnapOk () {
    export TERM=xterm
    tput setaf 2
    echo -e "${green}\n\n\n################# SNAP OK in $((SnapEndTime - SnapStartTime)) seconds  #################"
    echo -e "${green}################# RAW snap path -  $SnapPathFQ #################"    
    tput setaf 9       
}
