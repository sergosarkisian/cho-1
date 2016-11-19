#!/bin/bash
########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash DSL, profiles
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
### IN4 BASH HEADER ###
set -e
PrevDirPath=$CurDirPath; CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="BEGIN -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###

### DISK INIT ###
rm -f $BuildEnv/*.raw
fallocate -l$VmDiskSizeSystem $BuildEnv/$In4NamingOsSrvType.raw
sudo mkfs.btrfs -f -L "system" $BuildEnv/$In4NamingOsSrvType.raw 

fallocate -l $VmDiskSizeSysdata $BuildEnv/sysdata.raw
sudo mkfs.btrfs -f -L "sysdata" $BuildEnv/sysdata.raw

fallocate -l $VmDiskSizeSwap $BuildEnv/swap.raw
sudo mkswap -f -L "swap" $BuildEnv/swap.raw 
 ###
 
 ### GENERATE LOOP MOUNT & UNTAR ###
sudo losetup /dev/$VmDiskLoopSystem $BuildEnv/$In4NamingOsSrvType.raw
sudo mount /dev/$VmDiskLoopSystem  $BuildEnv/loop/

 ### 
sudo mkdir -p  $BuildEnv/loop/media/sysdata
sudo losetup /dev/$VmDiskLoopSysdata $BuildEnv/sysdata.raw
sudo mount /dev/$VmDiskLoopSysdata $BuildEnv/loop/media/sysdata
 ###

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
