#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

cp --sparse=always $BUILD_ENV/$OS_TYPE.raw $BUILD_ENV/../
cp --sparse=always $BUILD_ENV/sysdata.raw $BUILD_ENV/../
cp --sparse=always $BUILD_ENV/swap.raw $BUILD_ENV/../

cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/xen_domu/demo.xl  /tmp/demo.xl
sed -i "s/VMPATH/$BUILD_ENV/" 
xl create /tmp/demo.xl

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
