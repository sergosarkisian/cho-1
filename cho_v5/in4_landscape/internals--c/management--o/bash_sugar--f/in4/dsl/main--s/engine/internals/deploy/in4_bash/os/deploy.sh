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

if [[ $DeployOsMode == "vm_xen" ]]; then
    BuildEnv="$VMImageDir/$OS_Type/_os_build"
else
    BuildEnv="`pwd`/_os_build"
fi

if [[ $DeployOsMode == "vm_xen" ]]; then
    . $In4_Exec_Path/build_env.sh
    . $In4_Exec_Path/_base/build/1.init/6.clean.sh

    if [[ -f $BuildEnv/$In4NamingOsSrvType.raw  ]]; then
        echo "Build image exists, run "
        #. $In4_Exec_Path/run.sh
    else
        echo "Build image not exists, build "
        . $In4_Exec_Path/build.sh
        #. $In4_Exec_Path/run.sh
    fi
fi


### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
