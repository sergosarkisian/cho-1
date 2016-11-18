#!/bin/bash
set -e
red=`tput setaf 1`
green=`tput setaf 2`
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/build_os-*_env.sh


if [[ -z $TYPE ]]; then
    echo "Please specify type"
    if [[ -z $1 ]]; then echo "Please choose type"; select TYPE in vm hw ;  do  break ; done; else TYPE=$1; fi
fi

if [[ -z $ARCH ]]; then
    echo "Please specify arch"
    if [[ -z $2 ]]; then echo "Please choose arch"; select ARCH in x86_64  i586 armv7l;  do  break ; done; else ARCH=$2; fi
fi

if [[ $TYPE == "vm" ]]; then

    if [[ -z $VM_IMAGE_DIR ]]; then
        echo "Please specify VM image dir"
        if [[ -z $3 ]]; then echo "Please choose VM image dir"; select VM_IMAGE_DIR in /media/storage1/images/!master /media/storage/images/!master `pwd`;  do  break ; done; else VM_IMAGE_DIR=$3; fi
    fi

    BUILD_ENV="$VM_IMAGE_DIR/$OS_TYPE/_os_build"
else
    BUILD_ENV="`pwd`/_os_build"
fi
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/1.1_pre.sh
if [[ $TYPE == "hw" ]] ; then . /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/1.2_hw.sh; fi
if [[ $TYPE == "vm" ]] ; then . /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/1.2_vm.sh; fi
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/1.3_exec.sh
if [[ $TYPE == "vm" ]] ; then . /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/3.1_vm-start.sh; fi
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/2.post.sh


echo -e "${green}\n\n\n ################# BUILDED OK #################"
