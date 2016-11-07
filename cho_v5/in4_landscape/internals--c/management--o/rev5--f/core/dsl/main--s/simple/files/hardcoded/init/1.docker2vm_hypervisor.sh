#!/bin/bash
mkdir -p /media/storage1/images/\!master/openSUSE-42.1/_dev/loop
wget -O  /media/storage1/images/\!master/openSUSE-42.1/openSUSE-42.1-docker-guest-docker.x86_64.tar.xz http://download.opensuse.org/repositories/Virtualization:/containers:/images:/openSUSE-42.1/images/openSUSE-42.1-docker-guest-docker.x86_64.tar.xz
cd /media/storage1/images/\!master/openSUSE-42.1/_dev

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
 ### 
 
 
### GIT ###
 git -C ./loop/media/sysdata/ clone -b stable  https://github.com/eistomin/cho.git
 git -C ./loop/media/sysdata/cho config core.filemode false
###

 ###  CHROOT TO LOOP ###
mount -t proc proc loop/proc/ &&  mount -t sysfs sys loop/sys/ && mount -o bind /dev loop/dev/
chroot loop /bin/bash -c "sh /media/sysdata/....."
###

### RM TEMP & UMOUNT
#rm ./loop/etc/resolv.conf

umount loop/dev && umount loop/proc && umount loop/sys
umount ./loop/media/sysdata && losetup -d /dev/loop61
umount loop && losetup -d /dev/loop60
###

time cp --sparse=always ./in4a1-suse-l.raw ../
time cp --sparse=always ./sysdata.raw ../ 
