#!/bin/bash

 ###  CP OWN FILES ###
cp /etc/resolv.conf ./loop/etc/
cp /etc/sysconfig/proxy ./loop/etc/sysconfig/
chmod 744  ./loop/etc/sysconfig/
 ### 
 
 
### GIT ###
mkdir -p  ./loop/media/sysdata/in4
git -C ./loop/media/sysdata/in4 clone -b stable  https://github.com/conecenter/cho.git
#git -C ./loop/media/sysdata/in4 clone -b master  https://github.com/eistomin/cho.git
git -C ./loop/media/sysdata/in4/cho config core.filemode false
###

 ###  CHROOT TO LOOP ###
mount -t proc proc loop/proc/ &&  mount -t sysfs sys loop/sys/ && mount -o bind /dev loop/dev/
chroot loop /bin/bash -c "export TYPE=$TYPE; sh /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/$SCENARIO"
###
