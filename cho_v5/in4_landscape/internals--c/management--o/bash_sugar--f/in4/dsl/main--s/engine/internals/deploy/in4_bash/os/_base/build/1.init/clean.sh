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

if [[ -d $BuildEnv/loop/dev ]]; then ! sudo umount $BuildEnv/loop/dev; fi
if [[ -d $BuildEnv/loop/proc ]]; then ! sudo umount $BuildEnv/loop/proc; fi
if [[ -d $BuildEnv/loop/sys ]]; then ! sudo umount $BuildEnv/loop/sys; fi

if mountpoint -q $BuildEnv/loop/media/sysdata ; then _umount $BuildEnv/loop/media/sysdata; fi
if  mountpoint -q $BuildEnv/loop ; then _umount $BuildEnv/loop; fi
    
if [[ $DeployOsMode == "vm_xen" ]] ; then 
    if [[ -n $(losetup -j ${BuildEnv/sysdata.raw) ]]; then sudo losetup -d /dev/$VmDiskLoopSysdata; fi
    if [[ -n $(losetup -j $BuildEnv/$In4NamingOsSrvType.raw) ]] ; then sudo losetup -d /dev/$VmDiskLoopSystem; fi
fi


### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
