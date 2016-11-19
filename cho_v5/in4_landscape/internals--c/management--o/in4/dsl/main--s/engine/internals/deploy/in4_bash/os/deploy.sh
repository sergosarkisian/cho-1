#!/bin/bash
set -e
#red=`tput setaf 1`

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/build_os-*_env.sh

i=1

if [[ -z $TYPE ]]; then
    DESC="Please specify type"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select TYPE in vm_xen hw_chroot ;  do  break ; done; else TYPE=$ARG_NUM; fi
fi

if [[ -z $ARCH ]]; then
    DESC="Please specify hypervisor name"
    ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
    if [[ -z $ARG_NUM ]]; then echo $DESC; select ARCH in x86_64  i586 armv7l;  do  break ; done; else ARCH=$ARG_NUM; fi
fi



if [[ $TYPE == "vm" ]]; then

    if [[ -z $VM_IMAGE_DIR ]]; then
        DESC="Please specify hypervisor name"
        ARG_NUM=`echo $@|awk '{print $i}'`; let "i++"    
        if [[ -z $ARG_NUM ]]; then echo $DESC; select VM_IMAGE_DIR in /media/storage1/images/!master /media/storage/images/!master `pwd`;  do  break ; done; else VM_IMAGE_DIR=$ARG_NUM; fi
    fi

    BUILD_ENV="$VM_IMAGE_DIR/$OS_TYPE/_os_build"
else
    BUILD_ENV="`pwd`/_os_build"
fi
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/1.init/1.pre.sh
if [[ $TYPE == "hw_chroot" ]] ; then . /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/_sub/hw_chroot/1.init/2.hw_chroot.sh; fi
if [[ $TYPE == "vm_xen" ]] ; then . /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/_sub/vm_xen/1.init//2.vm_xen.sh; fi
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/1.init/3.exec.sh
if [[ $TYPE == "vm_xen" ]] ; then . /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/_sub/vm_xen/1.init//4.vm_xen-start.sh; fi
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/1.init/5.post.sh

green=`tput setaf 2`
echo -e "${green}\n\n\n ################# BUILDED OK #################"
