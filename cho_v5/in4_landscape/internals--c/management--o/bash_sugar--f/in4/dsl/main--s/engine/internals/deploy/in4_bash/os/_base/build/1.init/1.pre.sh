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
 if [[ $OfflineCliMode == "No" ]]; then
    ! in4func_Zypper $In4_Exec_Path/_base/build/1.init/1.pre_packages.suse
else
    echo "Needs offline zypper" ## BUG
fi
#

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


### offline mode ##
 if [[ -z $OfflineBuildDir ]]; then
    `$OsImageDownload`
else
    if [[ -f $OfflineBuildDir/$OsImageFilename  ]]; then
        cp $OfflineBuildDir/$OsImageFilename $BuildEnv/ 
    else
        `$OsImageDownload`            
    fi
fi
###



### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
