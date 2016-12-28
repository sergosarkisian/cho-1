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

. $In4_Exec_Path/_base/build/1.init/clean.sh

### OPENSUSE INIT
! in4func_Zypper $In4_Exec_Path/_base/build/1.init/1.pre_packages.suse
#

if [[ $OfflineCliMode == "Yes" ]]; then
    echo "Offline mode, all packages are cached"
elif  [[ $OfflineBuildMode == "Yes" ]]; then
    OfflineBuildDir="$BuildEnv/offline"
    mkdir -p $OfflineBuildDir    
    ! in4func_Zypper $In4_Exec_Path/_base/build/1.init/1.pre_packages.suse
else
    ! in4func_Zypper $In4_Exec_Path/_base/build/1.init/1.pre_packages.suse
fi     

sudo rm -rf $BuildEnv/*
mkdir -p $BuildEnv/loop && cd $BuildEnv

### docker image URI ###

case $OsVendor in
    "openSUSE")
        OsImageFilename="openSUSE-$OsRelease-docker-guest-docker.$DeployOsArch.tar.xz"
        OsImageURI="http://download.opensuse.org/repositories/Virtualization:/containers:/images:/openSUSE-$OsRelease/images/$OsImageFilename"
    ;;
esac

OsImageDownload="wget -O $BuildEnv/$OsImageFilename $OsImageURI"
### 


if [[ $OfflineCliMode == "Yes" ]]; then
    if [[ -f $OfflineBuildDir/$OsImageFilename  ]]; then
        cp $OfflineBuildDir/$OsImageFilename $BuildEnv/ 
    else
        `$OsImageDownload`            
    fi
else
    `$OsImageDownload`
fi    

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
