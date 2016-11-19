#!/bin/bash

. /media/sysdata/in4/cho/in4_core/deploy/os/2.scenario/2.all-repo_42.2.sh
. /media/sysdata/in4/cho/in4_core/deploy/os/2.scenario/2.all-packages.sh
if [[ $TYPE == "vm_xen" ]] || [[ $TYPE == "hw_chroot" ]]; then . /media/sysdata/in4/cho/in4_core/deploy/os/2.scenario/2.kern-packages.sh; fi
if [[ $TYPE == "vm_xen" ]]; then . /media/sysdata/in4/cho/in4_core/deploy/os/_sub/vm_xen/2.scenario/2.vm_xen-packages.sh; fi
if [[ $TYPE == "hw_chroot" ]]; then . /media/sysdata/in4/cho/in4_core/deploy/os/_sub/hw_chroot/2.scenario/2.hw_chroot-packages.sh; fi
if [[ $TYPE == "vm_xen" ]] || [[ $TYPE == "hw_chroot" ]]; then . /media/sysdata/in4/cho/in4_core/deploy/os/2.scenario/3.kern-step2_boot.sh; fi
. /media/sysdata/in4/cho/in4_core/deploy/os/2.scenario/5.all-pre.sh
. /media/sysdata/in4/cho/in4_core/deploy/os/2.scenario/6.all-conf_init.sh
## . /media/sysdata/in4/cho/in4_core/deploy/os/2.scenario/7.all-common.sh ## BUG
. /media/sysdata/in4/cho/in4_core/deploy/os/2.scenario/8.mounts.sh
if [[ $TYPE == "vm_xen" ]]; then . /media/sysdata/in4/cho/in4_core/deploy/os/_sub/vm_xen/2.scenario/9.vm_xen_post.sh; fi
if [[ $TYPE == "hw_chroot" ]]; then . /media/sysdata/in4/cho/in4_core/deploy/os/_sub/vm_xen/2.scenario/9.hw_chroot_post.sh; fi
. /media/sysdata/in4/cho/in4_core/deploy/os/2.scenario/10.clean.sh
