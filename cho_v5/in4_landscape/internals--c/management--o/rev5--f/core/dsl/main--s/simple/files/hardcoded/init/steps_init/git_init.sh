#!/bin/bash

### GIT ###
mkdir -p  $GIT_PATH/media/sysdata/in4
git -C $GIT_PATH/media/sysdata/in4 clone -b stable  https://github.com/conecenter/cho.git
#git -C $GIT_PATH/media/sysdata/in4 clone -b master  https://github.com/eistomin/cho.git
git -C $GIT_PATH/media/sysdata/in4/cho config core.filemode false
###
