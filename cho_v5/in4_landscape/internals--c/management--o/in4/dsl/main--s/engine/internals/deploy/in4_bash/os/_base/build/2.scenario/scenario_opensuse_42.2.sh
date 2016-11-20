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

### PREREQ ###
 if [[ -z $OfflineDir ]]; then
    rm -rf /etc/zypp/repos.d/*
    zypper --non-interactive in --force util-linux-systemd    
else
    echo "Offline mode"
    rm -rf /etc/zypp/repos.d/*    
    zypper --non-interactive --no-remote in /tmp/*.rpm    
    zypper --non-interactive --no-remote in /var/cache/zypp_offline/packages/*/*/*.rpm        
fi


###
### IN4 BASH HEADER ###
set -e
PrevDirPath=$CurDirPath; CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="BEGIN -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###

. $In4_Exec_Path/_base/build/2.scenario/2.all-repo_42.2.sh
. $In4_Exec_Path/_base/build/2.scenario/2.all-packages.sh
if [[ $DeployOsMode == "vm_xen" ]] || [[ $DeployOsMode == "hw_chroot" ]]; then . $In4_Exec_Path/_base/build/2.scenario/2.kern-packages.sh; fi
if [[ $DeployOsMode == "vm_xen" ]]; then . $In4_Exec_Path/vm_xen/build/2.scenario/2.vm_xen-packages.sh; fi
if [[ $DeployOsMode == "hw_chroot" ]]; then . $In4_Exec_Path/hw_chroot/build/2.scenario/2.hw_chroot-packages.sh; fi
if [[ $DeployOsMode == "vm_xen" ]] || [[ $DeployOsMode == "hw_chroot" ]]; then . $In4_Exec_Path/_base/build/2.scenario/3.kern-step2_boot.sh; fi
. $In4_Exec_Path/_base/build/2.scenario/5.all-pre.sh
. $In4_Exec_Path/_base/build/2.scenario/6.all-conf_init.sh
## . $In4_Exec_Path/_base/build/2.scenario/7.all-common.sh ## BUG
. $In4_Exec_Path/_base/build/2.scenario/8.mounts.sh
if [[ $DeployOsMode == "vm_xen" ]]; then . $In4_Exec_Path/vm_xen/build/2.scenario/9.vm_xen_post.sh; fi
if [[ $DeployOsMode == "hw_chroot" ]]; then . $In4_Exec_Path/vm_xen/build/2.scenario/9.hw_chroot_post.sh; fi
. $In4_Exec_Path/_base/build/2.scenario/10.clean.sh

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
