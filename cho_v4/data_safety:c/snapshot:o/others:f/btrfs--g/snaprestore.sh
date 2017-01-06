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

if [[ -z $SnapDirPath ]]; then echo "Please specify dir for restore: ";  if ! [[ -z $1 ]]; then SnapDirPath=$1; else exit 1; fi;  fi

if [[ -z $SnapRestoreUnit ]]; then
    DialogMsg="Please select available snap units for $SnapDirPath snapshots: "
    #SnapRestoreUnitFullList=()
    echo $DialogMsg; select SnapRestoreUnitFull in `ls -daA ${SnapDirPath}_snap/*`;  do  break ; done
    DialogMsg="Please select available snapshots in $SnapRestoreUnitFull: "    
    echo $DialogMsg; select SnapRestorePathFQ in `ls -daA $SnapRestoreUnitFull/*`;  do  break ; done
else
    SnapRestorePathFQ=$SnapDirPath_snap/$SnapRestoreUnit/$SnapRestoreDate
fi

echo "\n###Restoring $SnapRestorePathFQ as $SnapDirPath ###\n"
SnapMode="manual" . /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/runner.sh
btrfs subvolume delete $SnapDirPath
btrfs subvolume snapshot $SnapRestorePathFQ/master /media/storage/as/oracle/data

#
export TERM=xterm
tput setaf 2
echo "${green}\n\n\n################# $SnapRestorePathFQ restored as $SnapDirPath #################\n"
tput setaf 9   
#
