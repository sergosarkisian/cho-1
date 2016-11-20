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

. $In4_Exec_Path/_base/build/1.init/6.clean.sh

### OPENSUSE INIT
 if [[ -z $OfflineDir ]]; then
    ! sudo zypper --non-interactive in wget btrfsprogs parted git xz tar
else
    echo "Needs offline zypper" ## BUG
fi
#

rm -rf $BuildEnv/*
mkdir -p $BuildEnv/loop && cd $BuildEnv

### 42.2 ###
OsImageFilename="openSUSE-42.2-docker-guest-docker.$DeployOsArch.tar.xz"
OsImageDownload="wget -O $BuildEnv/$OsImageFilename http://download.opensuse.org/repositories/Virtualization:/containers:/images:/openSUSE-42.2/images/$OsImageFilename"
 if [[ -z $OfflineDir ]]; then
    `$OsImageDownload`
else
    if [[ -f $OfflineDir/$OsImageFilename  ]]; then
        cp $OfflineDir/$OsImageFilename $BuildEnv/ 
    else
        `$OsImageDownload`            
    fi
fi
#

###

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
