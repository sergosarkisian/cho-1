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
. /media/sysdata/in4/cho/in4_core/internals/helpers/in4func.sh

if [[ -z $RunType ]]; then RunType="prod"; fi

if ! [[ -z $1 ]]; then Task=$1; fi
if ! [[ -z $2 ]]; then TaskVars=$2; fi

if [[ -z $Task ]]; then
    DialogMsg="Please specify task"
    echo $DialogMsg; select Task in deploy recipe sync sys run context snap snapstat snaprestore;  do  break ; done
fi

case $Task in
    "deploy") 
        
        if [[ -z $DeployType ]]; then
            DialogMsg="Please specify deploy type"
            echo $DialogMsg; select DeployType in os role app ;  do  break ; done
        fi
        
        case $DeployType in
            "os") 
                In4_Exec_Path="/media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/bash_sugar--f/in4/dsl/main--s/engine/internals/deploy/in4_bash/os"
                if [[ -z $DeployOsMode ]]; then
                    DialogMsg="Please specify deploy OS mode"
                    echo $DialogMsg; select DeployOsMode in container_docker vm_xen hw_chroot hw_bootdrive;  do  break ; done
                fi
                
                if [[ -z $OsVendor ]]; then
                    DialogMsg="Please specify OS vendor"   
                    echo $DialogMsg; select OsVendor in openSUSE;  do  break ; done;
                fi

                if [[ -z $OsRelease ]]; then
                    DialogMsg="Please specify OS release"   
                    echo $DialogMsg; select OsRelease in 42.2;  do  break ; done;
                fi
                
                if [[ -z $DeployOsArch ]]; then
                    DialogMsg="Please specify platform arch"   
                    echo $DialogMsg; select DeployOsArch in x86_64  i586 armv7l;  do  break ; done;
                fi                
                
                ### vm_xen ###
                    
                if [[ $DeployOsMode == "vm_xen" ]]; then
                
                    if [[ -z $OfflineCliMode ]]; then
                        OfflineCliMode="No"                    
                    fi
                    
                    if [[ -z $OfflineBuildMode ]]; then
                        OfflineBuildMode="No"                    
                    fi
                    BuildLayers=(os)
                
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
                if [[ $DeployOsMode == "hw_chroot" ]]; then
                    BuildLayers=(unit os)
                
                    if [[ -z $HWBaseDisk ]]; then
                        DialogMsg="Please specify disk name for OS install"
                        echo $DialogMsg; select HWBaseDisk in sdb sdc sdd sde sdd;  do  break ; done
                    fi
                    
                fi        
                ###
            
                ### hw_bootdrive ###
                if [[ $DeployOsMode == "hw_bootdrive" ]]; then
                
                    OfflineCliMode="No"
                    OfflineBuildMode="Yes"
                    BuildLayers=(unit os)
                    RecreatePartitions="Yes"
                    DiskSizingUnit="MiB"
                    if [[ -z $In4Disk_SystemSize ]]; then
                        In4Disk_SystemSize="2000"
                    fi
                    
                    if [[ -z $In4Disk_SwapSize ]]; then
                        In4Disk_SwapSize="100"                    
                    fi
                    
                    if [[ -z $In4Disk_SysdataSize ]]; then
                        In4Disk_SysdataSize="1500"
                    fi

                    In4Disk_SysdataOnBaseDisk="Yes"

                    if [[ -z $HWBaseDisk ]]; then
                        DialogMsg="Please specify bootable disk name for OS install"
                        echo $DialogMsg; select HWBaseDisk in sdb sdc sdd sde sdd sde sdf;  do  break ; done
                    fi
                fi 
                ###
                
                ### offline mode ###
                if [[ -z $OfflineCliMode ]]; then
                    DialogMsg="Activate offline mode (as a client)?"   
                    echo $DialogMsg; select OfflineCliMode in Yes No;  do  break ; done;
                fi
                
                if [[ $OfflineCliMode == "No" ]]; then
                
                    if [[ -z $OfflineBuildMode ]]; then
                        DialogMsg="Activate offline mode (as a offline pack builder)?"   
                        echo $DialogMsg; select OfflineBuildMode in Yes No;  do  break ; done;
                        
                        if [[ $OfflineBuildMode == "Yes" ]]; then
                        
                            if [[ -z $OfflineBuildDir ]]; then
                                DialogMsg="Please specify offline dir"   
                                echo $DialogMsg; read OfflineBuildDir
                            fi
                            
                        fi
                    fi
                fi
                ###            
                . $In4_Exec_Path/deploy.sh 
                ;;
                
                "role")                 
                    if [[ -z $RoleType ]]; then
                        DialogMsg="Please specify role type"
                        echo $DialogMsg; select AppType in "c2db(oracle10GR2_SE)"  "c2db(oracle10GR2_EE)";  do  break ; done
                    fi
            
                    case $AppType in
                        "c2db(oracle10GR2_EE)") 
                            time . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/in4_oracle_init.sh                 
                            time su - oracle -c "/bin/bash  /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/new_db/db.sh"
                        ;;
                    esac
                ;;
                esac
            ;;
            
                "app")                 
                    if [[ -z $AppType ]]; then
                        DialogMsg="Please specify application type"
                        echo $DialogMsg; select AppType in c2db phpSite ;  do  break ; done
                    fi
            
                    case $AppType in
                        "c2db") time . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/cone/c2db.sh ;;
                    esac
                ;;
                esac
            ;;
            "run" )
                if [[ -z $in4LandscapeFQN ]]; then
                    in4LandscapeFQN=$1
                fi            
                if [[ -z $RunPath ]]; then
                    RunPath=$2
                fi       
                if [[ -z $RunName ]]; then
                    RunName=$3
                fi                       
                in4func_run $in4LandscapeFQN $RunPath $RunName
                #"internals--c--linux_sys--o--boot--f--grub2--g--main--s" "2_init/opensuse" "in4__main--s.package.zypper.sh"                
            ;;
            "sync" )
                systemctl restart in4__sync
            ;;
            "snap" )
                SnapMode="manual" SnapDirPath=$TaskVars . /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/runner.sh
            ;;            
            "snapstat" )
                if [[ -z $TaskVars ]]; then
                    DialogMsg="\n### Please specify mountpoint ###"   
                    echo -e $DialogMsg; select SnapMountpoint in `mount|grep btrfs|awk '{print $3}'`;  do  break ; done
                else            
                SnapMountpoint=$TaskVars
                fi
                ruby /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snapstat.rb $SnapMountpoint
            ;;                
            "snaprestore" )
                if [[ -z $TaskVars ]]; then
                    DialogMsg="\n### Please specify mountpoint ###"   
                    echo -e $DialogMsg; select SnapMountpoint in `mount|grep btrfs|awk '{print $3}'`;  do  break ; done
                    DialogMsg="\n###  Please specify path to restore ###"   
                    echo -e $DialogMsg; select SnapDirPathWoMounpoint in `btrfs subvolume list /media/storage|grep snap$|awk '{print $9}'|sed  "s/_snap$//"`;  do  break ; done              
                    SnapDirPath=$SnapMountpoint/$SnapDirPathWoMounpoint
                else
                    SnapDirPath=$TaskVars
                fi                   
                . /media/sysdata/in4/cho/cho_v4/data_safety:c/snapshot:o/others:f/btrfs--g/snaprestore.sh
            ;;                  
            "context" )
                . /media/sysdata/in4/cho/in4_core/internals/naming/manual.sh
                . /media/sysdata/in4/cho/in4_core/internals/helpers/context_naming.sh
                . /media/sysdata/in4/cho/in4_core/internals/helpers/context_svn.sh
                systemctl restart in4__sync
            ;;            
esac

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
