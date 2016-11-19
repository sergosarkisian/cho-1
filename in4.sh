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
OfflineDir="/home/storage/IT/_tmp/cho/"

if [[ -z $Task ]]; then
    DialogMsg="Please specify task"
    echo $DialogMsg; select Task in deploy recipe sync sys ;  do  break ; done
fi

case $Task in
    "deploy") 
        
        if [[ -z $DeployType ]]; then
            DialogMsg="Please specify deploy type"
            echo $DialogMsg; select DeployType in os role app ;  do  break ; done
        fi
        
        case $DeployType in
            "os") 
                In4_Exec_Path="/media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os"
                if [[ -z $DeployOsMode ]]; then
                    DialogMsg="Please specify deploy OS mode"
                    echo $DialogMsg; select DeployOsMode in vm_xen hw_chroot ;  do  break ; done
                fi
                
                if [[ -z $DeployOsArch ]]; then
                    DialogMsg="Please specify platform arch"   
                    echo $DialogMsg; select DeployOsArch in x86_64  i586 armv7l;  do  break ; done;
                fi
                
                ### vm_xen ###
                    
                if [[ $DeployOsType == "vm_xen" ]]; then
                
                    if [[ -z $VMImageDir ]]; then
                        DialogMsg="Please specify VM image path name"
                        echo $DialogMsg; select VMImageDir in /media/storage1/images/!master /media/storage/images/!master `pwd`;  do  break ; done
                    fi
                    
                    if [[ -z $In4NamingOsSrvType ]]; then
                        DialogMsg="Please specify server type: "
                        echo $DialogMsg; select  In4NamingOsSrvType in in4a1-suse-l ;  do  break ; done;
                    fi

                fi
                ###
                
                ### hw_chroot ###
                if [[ $DeployOsType == "hw_chroot" ]]; then
                
                    if [[ -z $HWBaseDisk ]]; then
                        DialogMsg="Please specify VM image path name"
                        echo $DialogMsg; select HWBaseDisk in sdb sdc sdd sde sdd;  do  break ; done
                    fi
                    
                fi        
                ###
            
                . $In4_Exec_Path/deploy.sh ;;
                esac
            ;;
esac

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
