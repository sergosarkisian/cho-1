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

#LogMsg="Dump vars for $ExecScriptname: "
#echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg

if [[ $RunType == "prod" ]]; then
    if [[ $DeployOsMode == "vm_xen" ]]; then BuildEnv="$VMImageDir/${OsBuild}_${OsSrvType}/_os_build"; fi
    if [[ $DeployOsMode == "hw_chroot" ]] ||  [[ $DeployOsMode == "hw_bootdrive" ]] ; then BuildEnv="/media/sysdata/_os_build"; fi    
else
    BuildEnv="`pwd`/_os_build"
fi

OfflineBuildDir="$BuildEnv/offline"

if [[ $DeployOsMode == "vm_xen" ]]; then
    . $In4_Exec_Path/build_env.sh
    . $In4_Exec_Path/_base/build/1.init/clean.sh

    if [[ -f $BuildEnv/../${OsBuild}_${OsSrvType}.raw  ]]; then
        echo "Build image exists, checking build date"
        
        if [[ -z $In4ImageRedeploy ]]; then
            DialogMsg="Redeploy?"
            echo $DialogMsg; select  In4ImageRedeploy in N Y ;  do  break ; done;
        fi   
        
        if [[ $In4ImageRedeploy == "Y" ]]; then
           time . $In4_Exec_Path/build.sh
        fi
        . $In4_Exec_Path/run.sh
        
    else
        echo "Build image not exists, build "
       time . $In4_Exec_Path/build.sh
        . $In4_Exec_Path/run.sh
    fi
fi

if [[ $DeployOsMode == "hw_chroot" ]] || [[ $DeployOsMode == "hw_bootdrive" ]]; then
    . $In4_Exec_Path/build_env.sh
    . $In4_Exec_Path/_base/build/1.init/clean.sh
    time . $In4_Exec_Path/build.sh
fi

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
