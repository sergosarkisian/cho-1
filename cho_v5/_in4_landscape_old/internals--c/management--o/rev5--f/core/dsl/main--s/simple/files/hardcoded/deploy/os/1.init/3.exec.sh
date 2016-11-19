#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### UNTAR ###
tar xf *.tar.xz -C $BUILD_ENV/loop/
rm -rf $BUILD_ENV/loop/media/sysdata/*
###

 ###  CP OWN FILES ###
cp /etc/resolv.conf $BUILD_ENV/loop/etc/
cp /etc/sysconfig/proxy $BUILD_ENV/loop/etc/sysconfig/
chmod 744  $BUILD_ENV/loop/etc/sysconfig/
 ### 
 
 GIT_PATH="$BUILD_ENV/loop"
. /media/sysdata/in4/cho/in4_core/deploy/git_init.sh


 ###  CHROOT TO LOOP ###
mount -t proc proc $BUILD_ENV/loop/proc/ &&  mount -t sysfs sys $BUILD_ENV/loop/sys/ && mount -o bind /dev $BUILD_ENV/loop/dev/
chroot $BUILD_ENV/loop /bin/bash -c "export TYPE=$TYPE; export LO_SYSTEM=$LO_SYSTEM; export IN4_BASEDISK=$IN4_BASEDISK; sh /media/sysdata/in4/cho/in4_core/init/$SCENARIO"
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
