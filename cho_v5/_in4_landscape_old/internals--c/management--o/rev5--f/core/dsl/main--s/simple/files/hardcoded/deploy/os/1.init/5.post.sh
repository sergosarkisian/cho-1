#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

. /media/sysdata/in4/cho/in4_core/deploy/os/deploy_env.sh

if [[ -d $BUILD_ENV/loop/dev ]]; then umount $BUILD_ENV/loop/dev; fi
if [[ -d $BUILD_ENV/loop/proc ]]; then umount $BUILD_ENV/loop/proc; fi
if [[ -d $BUILD_ENV/loop/sys ]]; then umount $BUILD_ENV/loop/sys; fi

if [[ -d $BUILD_ENV/loop/media/sysdata ]]; then umount $BUILD_ENV/loop/media/sysdata; fi
if [[ -d $BUILD_ENV/loop/media ]]; then umount $BUILD_ENV/loop; fi

if [[ $TYPE == "vm_xen" ]] ; then 
    ! losetup -d /dev/$LO_SYSDATA
    ! losetup -d /dev/$LO_SYSTEM
    ! xl destroy demo-hvxen-test
fi

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
