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
 if [[ -z $OfflineDir ]]; then
    sudo . $In4_Exec_Path/git_init.sh
else
    sudo mkdir -p  $GIT_PATH/media/sysdata/in4/cho && sudo git init $GIT_PATH/media/sysdata/in4/cho && cd  $GIT_PATH/media/sysdata/in4/cho
    sudo git pull $OfflineDir/git
    cp $OfflineDir/packages/* $GIT_PATH/tmp/
fi
 

 ###  CHROOT TO LOOP ###
sudo mount -t proc proc $BuildEnv/loop/proc/ &&  sudo mount -t sysfs sys $BuildEnv/loop/sys/ && sudo mount -o bind /dev $BuildEnv/loop/dev/

if [[ $DeployOsMode == "hw_chroot" ]] ; then 
    sudo chroot $BuildEnv/loop /bin/bash -c \
    "export  In4_Exec_Path="$In4_Exec_Path"; \
     export OfflineDir=$OfflineDir; \
     export DeployOsMode="$DeployOsMode"; \
     export HWBaseDisk="$HWBaseDisk"; \
     . $In4_Exec_Path/_base/build/2.scenario/$OsBuildScenario"
fi
if [[ $DeployOsMode == "vm_xen" ]] ; then 
    sudo chroot $BuildEnv/loop /bin/bash -c \
    "export  In4_Exec_Path="$In4_Exec_Path"; \
      export OfflineDir=$OfflineDir; \
      export DeployOsMode="$DeployOsMode"; \
      export VmDiskLoopSystem="$VmDiskLoopSystem"; \
      . $In4_Exec_Path/_base/build/2.scenario/$OsBuildScenario"
fi
###
### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
