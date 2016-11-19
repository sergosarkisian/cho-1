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

### UNTAR ###
sudo tar xf *.tar.xz -C $BuildEnv/loop/
sudo rm -rf $BuildEnv/loop/media/sysdata/*
###

 ###  CP OWN FILES ###
sudo cp /etc/resolv.conf $BuildEnv/loop/etc/
sudo cp /etc/sysconfig/proxy $BuildEnv/loop/etc/sysconfig/
sudo chmod 744  $BuildEnv/loop/etc/sysconfig/
 ### 
 
 GIT_PATH="$BuildEnv/loop"
. /media/sysdata/in4/cho/in4_core/deploy/git_init.sh


 ###  CHROOT TO LOOP ###
sudo mount -t proc proc $BuildEnv/loop/proc/ &&  sudo mount -t sysfs sys $BuildEnv/loop/sys/ && sudo mount -o bind /dev $BuildEnv/loop/dev/

if [[ $DeployOsMode == "hw_chroot" ]] ; then 
    chroot $BuildEnv/loop /bin/bash -c \
    "export  In4_Exec_Path= $In4_Exec_Path; export DeployOsMode=$DeployOsMode; export HWBaseDisk=$HWBaseDisk; sh . $In4_Exec_Path/_base/build/2.scenario/$OsBuildScenario"
fi
if [[ $DeployOsMode == "vm_xen" ]] ; then 
    chroot $BuildEnv/loop /bin/bash -c \
    "export  In4_Exec_Path= $In4_Exec_Path; export DeployOsMode=$DeployOsMode; export VmDiskLoopSystem=$VmDiskLoopSystem; sh . $In4_Exec_Path/_base/build/2.scenario/$OsBuildScenario"
fi
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
