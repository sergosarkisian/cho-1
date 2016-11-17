#!/bin/bash

# ### 42.1 ###
# mkdir -p /media/storage1/images/\!master/openSUSE-42.1/_dev/loop
# wget -O  /media/storage1/images/\!master/openSUSE-42.1/openSUSE-42.1-docker-guest-docker.$ARCH.tar.xz http://download.opensuse.org/repositories/Virtualization:/containers:/images:/openSUSE-42.1/images/openSUSE-42.1-docker-guest-docker.$ARCH.tar.xz
# cd /media/storage1/images/\!master/openSUSE-42.1/_dev
# ###

. /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/2.post.sh

### 42.2 ###
rm -rf $BUILD_ENV/*
mkdir -p $BUILD_ENV/loop && cd $BUILD_ENV
wget -O $BUILD_ENV/openSUSE-42.2-docker-guest-docker.$ARCH.tar.xz http://download.opensuse.org/repositories/Virtualization:/containers:/images:/openSUSE-42.2/images/openSUSE-42.2-docker-guest-docker.$ARCH.tar.xz

###

 
