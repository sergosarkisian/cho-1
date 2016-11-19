#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/deploy_env.sh

### DISK INIT ###
rm -f $BUILD_ENV/*.raw
fallocate -l10g $BUILD_ENV/$OS_TYPE.raw
mkfs.btrfs -f -L "system" $BUILD_ENV/$OS_TYPE.raw 

fallocate -l 2g $BUILD_ENV/sysdata.raw
mkfs.btrfs -f -L "sysdata" $BUILD_ENV/sysdata.raw

fallocate -l 2g $BUILD_ENV/swap.raw
mkswap -f -L "swap" $BUILD_ENV/swap.raw 
 ###
 
 ### GENERATE LOOP MOUNT & UNTAR ###
losetup /dev/$LO_SYSTEM $BUILD_ENV/$OS_TYPE.raw
mount /dev/$LO_SYSTEM  $BUILD_ENV/loop/

 ### 
 mkdir -p  $BUILD_ENV/loop/media/sysdata
losetup /dev/$LO_SYSDATA $BUILD_ENV/sysdata.raw
mount /dev/$LO_SYSDATA $BUILD_ENV/loop/media/sysdata
 ###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
