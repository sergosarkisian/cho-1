#!/bin/bash

echo -e "\n\n######## ######## START -  steps_init - ${0##*/} ######## ########\n\n"

### GIT ###
mkdir -p  $GIT_PATH/media/sysdata/in4
git -C $GIT_PATH/media/sysdata/in4 clone -b stable  https://github.com/conecenter/cho.git
#git -C $GIT_PATH/media/sysdata/in4 clone -b master  https://github.com/eistomin/cho.git
git -C $GIT_PATH/media/sysdata/in4/cho config core.filemode false
###

echo -e "\n\n######## ######## STOP -  steps_init - ${0##*/} ######## ########\n\n"
