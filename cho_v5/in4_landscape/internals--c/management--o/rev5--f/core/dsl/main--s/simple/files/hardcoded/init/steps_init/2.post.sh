#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/build_os-vm_env.sh

if [[ -d $BUILD_ENV/loop/dev ]]; then umount $BUILD_ENV/loop/dev; fi
if [[ -d $BUILD_ENV/loop/proc ]]; then umount $BUILD_ENV/loop/proc; fi
if [[ -d $BUILD_ENV/loop/sys ]]; then umount $BUILD_ENV/loop/sys; fi

if [[ -d $BUILD_ENV/loop/media/sysdata ]]; then umount $BUILD_ENV/loop/media/sysdata; fi
if [[ -d $BUILD_ENV/loop/media ]]; then umount $BUILD_ENV/loop; fi

losetup -d /dev/$LO_SYSDATA
losetup -d /dev/$LO_SYSTEM


echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
