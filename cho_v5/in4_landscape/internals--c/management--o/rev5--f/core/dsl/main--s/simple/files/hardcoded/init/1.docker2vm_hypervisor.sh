#!/bin/bash

### 42.1 ###
mkdir -p /media/storage1/images/\!master/openSUSE-42.1/_dev/loop
wget -O  /media/storage1/images/\!master/openSUSE-42.1/openSUSE-42.1-docker-guest-docker.x86_64.tar.xz http://download.opensuse.org/repositories/Virtualization:/containers:/images:/openSUSE-42.1/images/openSUSE-42.1-docker-guest-docker.x86_64.tar.xz
cd /media/storage1/images/\!master/openSUSE-42.1/_dev
###

### 42.2 ###
mkdir -p /media/storage1/images/\!master/openSUSE-42.2/_dev/loop
wget -O  /media/storage1/images/\!master/openSUSE-42.2/openSUSE-42.2-docker-guest-docker.x86_64.tar.xz http://download.opensuse.org/repositories/Virtualization:/containers:/images:/openSUSE-42.2/images/openSUSE-42.2-docker-guest-docker.x86_64.tar.xz
cd /media/storage1/images/\!master/openSUSE-42.2/_dev
###



### DISK INIT ###
rm ./*.raw
fallocate -l10g ./in4a1-suse-l.raw
mkfs.btrfs -L "system" ./in4a1-suse-l.raw 

fallocate -l 2g ./sysdata.raw
mkfs.ext4 -L "sysdata" ./sysdata.raw

fallocate -l 2g ./swap.raw
mkswap -L "swap" ./swap.raw 
 ###
 
 ### GENERATE LOOP MOUNT & UNTAR ###
losetup /dev/loop60 ./in4a1-suse-l.raw
mount /dev/loop60  ./loop/
tar xf ../*.tar.xz -C ./loop/
 ###
 
 ### 
 mkdir -p  ./loop/media/sysdata
 losetup /dev/loop61 ./sysdata.raw
mount /dev/loop61 ./loop/media/sysdata
 ###

 ###  CP OWN FILES ###
cp /etc/resolv.conf ./loop/etc/
cp /etc/sysconfig/proxy ./loop/etc/sysconfig/
chmod 744  ./loop/etc/sysconfig/

 ### 
 
 
### GIT ###
mkdir -p  ./loop/media/sysdata/in4
 git -C ./loop/media/sysdata/in4 clone -b stable  https://github.com/eistomin/cho.git
 git -C ./loop/media/sysdata/in4/cho config core.filemode false
###

 ###  CHROOT TO LOOP ###
mount -t proc proc loop/proc/ &&  mount -t sysfs sys loop/sys/ && mount -o bind /dev loop/dev/
chroot loop /bin/bash -c "sh /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/scenario_docker2vm_42.2.sh"
###

### RM TEMP & UMOUNT
#rm ./loop/etc/resolv.conf

umount loop/dev && umount loop/proc && umount loop/sys
umount ./loop/media/sysdata && losetup -d /dev/loop61
umount loop && losetup -d /dev/loop60
###

time cp --sparse=always ./in4a1-suse-l.raw ../
time cp --sparse=always ./sysdata.raw ../ 
