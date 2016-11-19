#!/bin/bash

. $In4_Exec_Path/2.scenario/2.all-repo_42.2.sh
. $In4_Exec_Path/2.scenario/2.all-packages.sh
if [[ $DeployOsMode== "vm_xen" ]] || [[ $DeployOsMode== "hw_chroot" ]]; then . $In4_Exec_Path/2.scenario/2.kern-packages.sh; fi
if [[ $DeployOsMode== "vm_xen" ]]; then . $In4_Exec_Path/_sub/vm_xen/2.scenario/2.vm_xen-packages.sh; fi
if [[ $DeployOsMode== "hw_chroot" ]]; then . $In4_Exec_Path/_sub/hw_chroot/2.scenario/2.hw_chroot-packages.sh; fi
if [[ $DeployOsMode== "vm_xen" ]] || [[ $DeployOsMode== "hw_chroot" ]]; then . $In4_Exec_Path/2.scenario/3.kern-step2_boot.sh; fi
. $In4_Exec_Path/2.scenario/5.all-pre.sh
. $In4_Exec_Path/2.scenario/6.all-conf_init.sh
## . $In4_Exec_Path/2.scenario/7.all-common.sh ## BUG
. $In4_Exec_Path/2.scenario/8.mounts.sh
if [[ $DeployOsMode== "vm_xen" ]]; then . $In4_Exec_Path/_sub/vm_xen/2.scenario/9.vm_xen_post.sh; fi
if [[ $DeployOsMode== "hw_chroot" ]]; then . $In4_Exec_Path/_sub/vm_xen/2.scenario/9.hw_chroot_post.sh; fi
. $In4_Exec_Path/2.scenario/10.clean.sh
