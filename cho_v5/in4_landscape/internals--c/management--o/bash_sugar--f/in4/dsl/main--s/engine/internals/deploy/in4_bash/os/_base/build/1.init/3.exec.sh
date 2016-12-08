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
GitPath="$BuildEnv/loop/media/sysdata/in4/cho"
 
 if [[ -z $OfflineDir ]]; then
    sudo mkdir -p  $BuildEnv/loop/media/sysdata/in4 
    sudo git -C $BuildEnv/loop/media/sysdata/in4 clone -b stable  https://github.com/conecenter/cho.git
    sudo git -C $GitPath remote add dev https://github.com/eistomin/cho.git    
    sudo git -C $GitPath config core.filemode false
else
    
    if [[ -d $OfflineDir/git ]]; then
        sudo mkdir -p  $BuildEnv/loop/media/sysdata/in4/cho && sudo git init $BuildEnv/loop/media/sysdata/in4/cho && cd  $BuildEnv/loop/media/sysdata/in4/cho
        sudo git  -C $GitPath pull $OfflineDir/git
        sudo git  -C $GitPath remote add origin https://github.com/conecenter/cho.git
        sudo git  -C $GitPath remote add dev https://github.com/eistomin/cho.git        
        #sudo git branch --set-upstream-to=origin/stable ## BUG
        #sudo git reset --hard origin/stable ## BUG
        sudo git  -C $GitPath config core.filemode false
    fi
    
    if [[ -d $OfflineDir/zypper/zypp ]]; then
        sudo mkdir $BuildEnv/loop/var/cache/zypp_offline     
        sudo cp -r $OfflineDir/zypper/zypp/* $BuildEnv/loop/var/cache/zypp_offline
    fi
    
    if [[ -d $OfflineDir/zypper/repos.d ]]; then
        sudo mkdir $BuildEnv/loop/etc/zypp/repos.d_offline 
        sudo cp -r $OfflineDir/zypper/repos.d/*  $BuildEnv/loop/etc/zypp/repos.d_offline/
        sudo sed -i 's/keeppackages=.*/keeppackages=1/g' $BuildEnv/loop/etc/zypp/repos.d_offline/*.repo
    fi    
    sudo cp $OfflineDir/packages/* $BuildEnv/loop/tmp/
fi

 ###  CHROOT TO LOOP ###
sudo mount -t proc proc $BuildEnv/loop/proc/ &&  sudo mount -t sysfs sys $BuildEnv/loop/sys/ && sudo mount -o bind /dev $BuildEnv/loop/dev/

if [[ $DeployOsMode == "hw_chroot" ]] ; then 
    time sudo chroot $BuildEnv/loop /bin/bash -c \
    "export  In4_Exec_Path="$In4_Exec_Path"; \
     export OfflineDir="$OfflineDir"; \
     export OfflineMode="$OfflineMode"; \
     export DeployOsMode="$DeployOsMode"; \
     export HWBaseDisk="$HWBaseDisk"; \
     sh -x  $In4_Exec_Path/_base/build/2.scenario/$OsBuildScenario"
fi
if [[ $DeployOsMode == "vm_xen" ]] ; then 
    time sudo chroot $BuildEnv/loop /bin/bash -c \
    "export  In4_Exec_Path="$In4_Exec_Path"; \
     export OfflineDir="$OfflineDir"; \
     export OfflineMode="$OfflineMode"; \    
      export DeployOsMode="$DeployOsMode"; \
      export VmDiskLoopSystem="$VmDiskLoopSystem"; \
      sh -x $In4_Exec_Path/_base/build/2.scenario/$OsBuildScenario"
fi
###
### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
