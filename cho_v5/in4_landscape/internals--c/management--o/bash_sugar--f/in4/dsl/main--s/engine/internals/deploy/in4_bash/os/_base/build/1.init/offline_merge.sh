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

OfflineCpFlow=$1

case $OfflineCpFlow in
    "out")
    if  [[ $OfflineBuildMode == "Yes" ]]; then
        echo "VM data will be copied to $OfflineBuildDir"
        if [[ -d $BuildEnv/loop/etc/zypp/repos.d ]]; then sudo cp -r $BuildEnv/loop/etc/zypp/repos.d $OfflineBuildDir/zypper/; fi
        if [[ -d $BuildEnv/loop/media/sysdata/linux_sys/var/cache/zypp_offline ]]; then sudo cp -r $BuildEnv/loop/media/sysdata/linux_sys/var/cache/zypp_offline $OfflineBuildDir/zypper/; fi
    else
        echo "VM data will be deleted during nest steps"
    fi     
    ;;
    "in")
    if  [[ $OfflineBuildMode == "Yes" ]]; then
        echo "VM data will be copied to $OfflineBuildDir"
        sudo cp -rf $OfflineBuildDir $BuildEnv/loop/media/sysdata
    fi     
    ;;
esac    
### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
