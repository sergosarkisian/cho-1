#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### GIT ###
mkdir -p  $GIT_PATH/media/sysdata/in4
git -C $GIT_PATH/media/sysdata/in4 clone -b stable  https://github.com/conecenter/cho.git
#git -C $GIT_PATH/media/sysdata/in4 clone -b master  https://github.com/eistomin/cho.git
git -C $GIT_PATH/media/sysdata/in4/cho config core.filemode false
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
