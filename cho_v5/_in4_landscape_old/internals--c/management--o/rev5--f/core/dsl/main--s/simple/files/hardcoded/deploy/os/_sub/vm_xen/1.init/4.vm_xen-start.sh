#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

cp --sparse=always $BUILD_ENV/$OS_TYPE.raw $BUILD_ENV/../
cp --sparse=always $BUILD_ENV/sysdata.raw $BUILD_ENV/../
cp --sparse=always $BUILD_ENV/swap.raw $BUILD_ENV/../

cp /media/sysdata/in4/cho/in4_core/deploy/os/_sub/vm_xen/3.env/demo.xl  /tmp/demo.xl
BUILD_ENV_ESC=$(echo "$BUILD_ENV" | sed 's/\//\\\//g')
sed -i "s/VMPATH/$BUILD_ENV_ESC/g" /tmp/demo.xl
xl create /tmp/demo.xl
DOMID=`xl domid demo-hvxen-test`

secs=60  
SECONDS=0 
while (( SECONDS < secs )); do    # Loop until interval has elapsed.
    STATE=`xenstore-read /local/domain/$DOMID/device/vif/0/state`
    if [[ $STATE == 4 ]]; then break; fi
    sleep 1
done
xl destroy demo-hvxen-test

if [[ $STATE != 4 ]]; then exit 1; fi

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
