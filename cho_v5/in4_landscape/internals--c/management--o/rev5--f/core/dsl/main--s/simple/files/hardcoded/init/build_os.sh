#!/bin/bash
set -e
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/build_os-*_env.sh


if [[ -z $TYPE ]]; then
    echo "Please specify type"
    if [[ -z $1 ]]; then exit 1; else TYPE=$1; fi
fi

if [[ -z $ARCH ]]; then
    echo "Please specify arch"
    if [[ -z $1 ]]; then exit 1; else ARCH=$2; fi
fi

BUILD_ENV="`pwd`/_os_build"

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/1.1_pre.sh
if [[ $TYPE == "hw" ]] ; then . /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/1.2_hw.sh; fi
if [[ $TYPE == "vm" ]] ; then . /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/1.2_vm.sh; fi
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/1.3_exec.sh
. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/2.post.sh
