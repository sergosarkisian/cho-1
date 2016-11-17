#!/bin/bash

 ###  CP OWN FILES ###
cp /etc/resolv.conf $BUILD_ENV/loop/etc/
cp /etc/sysconfig/proxy $BUILD_ENV/loop/etc/sysconfig/
chmod 744  $BUILD_ENV/loop/etc/sysconfig/
 ### 
 
 
### GIT ###
mkdir -p  $BUILD_ENV/loop/media/sysdata/in4
git -C $BUILD_ENV/loop/media/sysdata/in4 clone -b stable  https://github.com/conecenter/cho.git
#git -C $BUILD_ENV/loop/media/sysdata/in4 clone -b master  https://github.com/eistomin/cho.git
git -C $BUILD_ENV/loop/media/sysdata/in4/cho config core.filemode false
###

 ###  CHROOT TO LOOP ###
mount -t proc proc $BUILD_ENV/loop/proc/ &&  mount -t sysfs sys $BUILD_ENV/loop/sys/ && mount -o bind /dev $BUILD_ENV/loop/dev/
chroot $BUILD_ENV/loop /bin/bash -c "export TYPE=$TYPE; sh /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/$SCENARIO"
###
