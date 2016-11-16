#!/bin/bash

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/build_os-vm_env.sh


### DISK INIT ###
rm ./*.raw
fallocate -l10g ./in4a1-suse-l.raw
mkfs.btrfs -L "system" ./in4a1-suse-l.raw 

fallocate -l 2g ./sysdata.raw
mkfs.ext4 -L "sysdata" ./sysdata.raw

fallocate -l 2g ./swap.raw
mkswap -L "swap" ./swap.raw 
 ###
 
 ### GENERATE LOOP MOUNT & UNTAR ###
losetup /dev/$LO_SYSTEM ./in4a1-suse-l.raw
mount /dev/$LO_SYSTEM  ./loop/

 ### 
 mkdir -p  ./loop/media/sysdata
losetup /dev/$LO_SYSDATA ./sysdata.raw
mount /dev/$LO_SYSDATA ./loop/media/sysdata
 ###

