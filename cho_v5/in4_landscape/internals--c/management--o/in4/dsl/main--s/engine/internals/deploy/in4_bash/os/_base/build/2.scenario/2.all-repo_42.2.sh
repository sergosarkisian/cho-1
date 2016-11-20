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

### ZYPPER ###
rm /etc/zypp/repos.d/*
 if [[ -z $OfflineDir ]]; then
### 42.2###
    zypper ar -cf http://download.opensuse.org/repositories/openSUSE:/Leap:/42.2/standard standard::leap42.2
    zypper ar -cf http://download.opensuse.org/update/leap/42.2/oss update_oss::leap42.2
    zypper ar -cf http://download.opensuse.org/update/openSUSE-stable update_oss::stable

    ##SOME STANDARD
    zypper ar -cf http://download.opensuse.org/repositories/Kernel:/openSUSE-42.2/standard/Kernel:openSUSE-42.2.repo
    zypper ar -cf http://download.opensuse.org/repositories/network/openSUSE_Leap_42.2/network.repo
    zypper ar -cf http://download.opensuse.org/repositories/shells/openSUSE_Leap_42.2/shells.repo
else
    echo "Offline mode - repos & packages are added manually"
    cp -r $OfflineDir/zypper/zypp/* /var/cache/zypp
    cp -r $OfflineDir/repos.d/*  /etc/zypp/repos.d
fi


### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
