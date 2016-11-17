#!/bin/bash

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/build_os-vm_env.sh

umount $BUILD_ENV/loop/dev
umount $BUILD_ENV/loop/proc 
umount $BUILD_ENV/loop/sys

umount $BUILD_ENV/loop/media/sysdata 
umount $BUILD_ENV/loop 

losetup -d /dev/$LO_SYSDATA
losetup -d /dev/$LO_SYSTEM
