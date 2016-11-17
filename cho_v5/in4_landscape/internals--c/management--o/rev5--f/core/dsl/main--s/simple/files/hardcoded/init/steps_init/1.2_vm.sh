#!/bin/bash

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/build_os-vm_env.sh


### DISK INIT ###
rm $BUILD_ENV/*.raw
fallocate -l10g $BUILD_ENV/in4a1-suse-l.raw
mkfs.btrfs -f -L "system" $BUILD_ENV/in4a1-suse-l.raw 

fallocate -l 2g $BUILD_ENV/sysdata.raw
mkfs.btrfs -f -L "sysdata" $BUILD_ENV/sysdata.raw

fallocate -l 2g $BUILD_ENV/swap.raw
mkswap -f -L "swap" $BUILD_ENV/swap.raw 
 ###
 
 ### GENERATE LOOP MOUNT & UNTAR ###
losetup /dev/$LO_SYSTEM $BUILD_ENV/in4a1-suse-l.raw
mount /dev/$LO_SYSTEM  $BUILD_ENV/loop/

 ### 
 mkdir -p  $BUILD_ENV/loop/media/sysdata
losetup /dev/$LO_SYSDATA $BUILD_ENV/sysdata.raw
mount /dev/$LO_SYSDATA $BUILD_ENV/loop/media/sysdata
 ###

