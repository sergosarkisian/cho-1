#!/bin/bash

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/build_os-vm_env.sh

umount loop/dev
umount loop/proc 
umount loop/sys

umount ./loop/media/sysdata 
umount loop 

losetup -d /dev/$LO_SYSDATA
losetup -d /dev/$LO_SYSTEM
