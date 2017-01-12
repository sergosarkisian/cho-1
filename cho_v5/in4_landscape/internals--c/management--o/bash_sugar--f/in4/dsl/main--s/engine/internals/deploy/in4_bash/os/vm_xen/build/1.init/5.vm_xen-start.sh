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

. $In4_Exec_Path/_base/build/1.init/clean.sh

cp --sparse=always $BuildEnv/${OsBuild}_${OsSrvType}.raw $BuildEnv/../
cp --sparse=always $BuildEnv/sysdata.raw $BuildEnv/../
cp --sparse=always $BuildEnv/swap.raw $BuildEnv/../

in4func_cp "internals--c--management--o--bash_sugar--f--in4--g--main--s" "engine/internals/deploy/in4_bash/os/vm_xen/build/3.env/demo.xl" "/tmp/"

BuildEnvEscaped=$(echo "$BuildEnv" | sed 's/\//\\\//g')
sed -i "s/VMPATH/$BuildEnvEscaped/g" /tmp/demo.xl
sudo xl create /tmp/demo.xl
DOMID=`sudo xl domid demo-hvxen-test`

secs=60  
SECONDS=0 
while (( SECONDS < secs )); do    # Loop until interval has elapsed.
    STATE=`sudo xenstore-read /local/domain/$DOMID/device/vif/0/state`
    if [[ $STATE == 4 ]]; then break; fi
    sleep 5
done
sudo xl destroy demo-hvxen-test

if [[ $STATE != 4 ]]; then exit 1; fi

### IN4 BASH FOOTER ###
CurDirPath=`echo ${BASH_SOURCE[0]}|sed "s/4//"`; ExecScriptname=`echo ${BASH_SOURCE[0]}`
LogMsg="END -  steps_init - $ExecScriptname"
echo -e "\n\n########  $LogMsg  ########\n\n"; logger -p info -t "in4" $LogMsg
###
