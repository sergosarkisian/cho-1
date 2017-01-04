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
sudo tar xf $OfflineBuildDir/$OsImageFilename -C $BuildEnv/loop/
sudo rm -rf $BuildEnv/loop/media/sysdata/*
###

 ###  CP OWN FILES ###
sudo cp /etc/resolv.conf $BuildEnv/loop/etc/
! sudo cp /etc/sysconfig/proxy $BuildEnv/loop/etc/sysconfig/
sudo chmod 744  $BuildEnv/loop/etc/sysconfig/
 ### 
GitPath="$BuildEnv/loop/media/sysdata/in4/cho"
 
 
 ### GIT INIT ###
 if [[ $OfflineCliMode == "Yes" ]]; then
    if [[ -d /media/tmp/in4/cho ]]; then
        sudo mkdir -p  $BuildEnv/loop/media/sysdata/in4/cho && sudo git init $BuildEnv/loop/media/sysdata/in4/cho && cd  $BuildEnv/loop/media/sysdata/in4/cho
        sudo git  -C $GitPath pull /media/tmp/in4/cho
        sudo git  -C $GitPath remote add origin $GitRepoStable
        sudo git  -C $GitPath remote add dev $GitRepoDev
        sudo git  -C $GitPath config core.filemode false
    fi
else
    sudo mkdir -p  $BuildEnv/loop/media/sysdata/in4 
    sudo git -C $BuildEnv/loop/media/sysdata/in4 clone -b stable  $GitRepoStable
    sudo git -C $GitPath remote add dev $GitRepoDev  
    sudo git  -C $GitPath fetch dev    
    sudo git -C $GitPath config core.filemode false
fi     

if [[ $RunType == "dev" ]]; then
    sudo git -C $GitPath branch --set-upstream-to=dev/master
    sudo git -C $GitPath reset --hard dev/master
fi
###

. $In4_Exec_Path/_base/build/1.init/offline_merge.sh in

 ###  CHROOT TO LOOP ###
sudo mount -t proc proc $BuildEnv/loop/proc/ &&  sudo mount -t sysfs sys $BuildEnv/loop/sys/ && sudo mount -o bind /dev $BuildEnv/loop/dev/

### ENV ##
echo "#!/bin/bash" > $BuildEnv/loop/tmp/in4_env.sh
echo "In4_Exec_Path=\"$In4_Exec_Path\"" >> $BuildEnv/loop/tmp/in4_env.sh
echo "OsVendor=\"$OsVendor\"" >> $BuildEnv/loop/tmp/in4_env.sh
echo "OsRelease=\"$OsRelease\"" >> $BuildEnv/loop/tmp/in4_env.sh
echo "OfflineCliMode=\"$OfflineCliMode\"" >> $BuildEnv/loop/tmp/in4_env.sh
echo "OfflineBuildMode=\"$OfflineBuildMode\"" >> $BuildEnv/loop/tmp/in4_env.sh
echo "OfflineBuildDir=\"$OfflineBuildDir\"" >> $BuildEnv/loop/tmp/in4_env.sh
echo "OfflineMode=\"$OfflineMode\"" >> $BuildEnv/loop/tmp/in4_env.sh
echo "DeployOsMode=\"$DeployOsMode\"" >> $BuildEnv/loop/tmp/in4_env.sh
echo "BuildLayers=(${BuildLayers[@]})" >> $BuildEnv/loop/tmp/in4_env.sh

if [[ " ${BuildLayers[@]} " =~ " unit " ]]; then 
    echo "HWBaseDisk=\"$HWBaseDisk\"" >> $BuildEnv/loop/tmp/in4_env.sh
fi

if [[ $DeployOsMode == "vm_xen" ]] ; then 
    echo "VmDiskLoopSystem=\"$VmDiskLoopSystem\"" >> $BuildEnv/loop/tmp/in4_env.sh
fi
##

time sudo chroot $BuildEnv/loop /bin/bash -c  ". /tmp/in4_env.sh ; sh -x  $In4_Exec_Path/_base/build/2.scenario/scenario_${OsVendor}_${OsRelease}.sh"
 
###
### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
