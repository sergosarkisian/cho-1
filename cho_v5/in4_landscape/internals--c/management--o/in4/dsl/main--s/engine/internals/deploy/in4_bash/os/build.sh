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

. $In4_Exec_Path/build_env.sh

. $In4_Exec_Path/_base/build/1.init/1.pre.sh
if [[ $DeployOsMode == "hw_chroot" ]] ; then . $In4_Exec_Path/hw_chroot/build/1.init/2.hw_chroot.sh; fi
if [[ $DeployOsMode == "vm_xen" ]] ; then . $In4_Exec_Path/vm_xen/build/1.init/2.vm_xen.sh; fi
. $In4_Exec_Path/_base/build/1.init/3.exec.sh
if [[ $DeployOsMode == "vm_xen" ]] ; then . $In4_Exec_Path/vm_xen/build/1.init/4.vm_xen-start.sh; fi
. $In4_Exec_Path/_base/build/1.init/5.post.sh

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
tput setaf 2
echo -e "${green}\n\n\n ################# BUILDED OK #################"
tput setaf 9
