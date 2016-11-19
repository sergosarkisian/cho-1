#!/bin/bash

. /media/sysdata/in4/cho/in4_core/init/scenario/2.all-repo_42.2.sh
. /media/sysdata/in4/cho/in4_core/init/scenario/2.all-packages.sh
if [[ $TYPE == "vm" ]] || [[ $TYPE == "hw" ]]; then . /media/sysdata/in4/cho/in4_core/init/scenario/2.kern-packages.sh; fi
if [[ $TYPE == "vm" ]]; then . /media/sysdata/in4/cho/in4_core/init/scenario/2.vm-packages.sh; fi
if [[ $TYPE == "vm" ]] || [[ $TYPE == "hw" ]]; then . /media/sysdata/in4/cho/in4_core/init/scenario/3.kern-step2_boot.sh; fi
. /media/sysdata/in4/cho/in4_core/init/scenario/5.all-pre.sh
. /media/sysdata/in4/cho/in4_core/init/scenario/6.all-conf_init.sh
. /media/sysdata/in4/cho/in4_core/init/scenario/7.all-common.sh
. /media/sysdata/in4/cho/in4_core/init/scenario/8.mounts.sh
if [[ $TYPE == "vm" ]]; then . /media/sysdata/in4/cho/in4_core/init/scenario/9.vm_post.sh; fi
if [[ $TYPE == "hw" ]]; then . /media/sysdata/in4/cho/in4_core/init/scenario/9.hw_post.sh; fi
. /media/sysdata/in4/cho/in4_core/init/scenario/10.clean.sh
