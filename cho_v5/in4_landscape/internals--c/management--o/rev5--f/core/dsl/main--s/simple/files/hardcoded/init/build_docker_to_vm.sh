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
 
 ###  CP REV5 - BOOT, GRUB2###
cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/etc_default_grub--vm_xen ./loop/etc/default/grub
cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/dracut.conf-vm ./loop/etc/dracut.conf
#cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/51-wa_xenvm_blacklist.conf ./loop/etc/modprobe.d/
#Temp - not in svn
#echo "blacklist xen-blkfront" >  ./loop/etc/modprobe.d/51-block-xenvm_blacklist.conf


mkdir -p  ./loop/boot/grub2/
cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/boot_grub2_grub.cfg--vm ./loop/boot/grub2/grub.cfg

## ADD ZYPPER INIT CONF => no multikernel
 ###
 
 ###  CP REV5 ###
 mkdir -p loop/etc/rev5/static
cp /media/sysdata/rev5/techpool/ontology/linux_sys/suse-network/ifcfg-tmpl loop/etc/rev5/static/
cp /media/sysdata/rev5/techpool/ontology/linux_sys/suse-network/hosts loop/etc/rev5/static/
cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/naming/naming.sh  loop/etc/rev5/static/

cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/1.naming_auto_xen.sh  loop/etc/rev5/static/
cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/2.svn_init.sh loop/etc/rev5/static/
rm -f  loop/etc/systemd/system/rev5_init_auto_xen.service && cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/_systemd/rev5_init_auto_xen.service loop/etc/systemd/system/
 ###
 
 ### MOUNTS  ###
#cp /media/sysdata/rev5/techpool/ontology/linux_sys/systemd/mounts/-.mount loop/etc/systemd/system/
#cp /media/sysdata/rev5/techpool/ontology/linux_sys/systemd/mounts/dev-disk-by\\\\x2dlabel-swap.swap loop/etc/systemd/system/
#cp /media/sysdata/rev5/techpool/ontology/linux_sys/systemd/mounts/media-logs.mount loop/etc/systemd/system/
#mounts - old
echo "LABEL=system           /          btrfs       ro,noatime,acl,user_xattr 0 0" > ./loop/etc/fstab
echo "LABEL=sysdata           /media/sysdata          ext4       noatime,acl,user_xattr 1 1" >> ./loop/etc/fstab
echo "LABEL=swap           swap                 swap       defaults              0 0" >> ./loop/etc/fstab
echo "tmpfs /tmp tmpfs defaults,noatime,mode=1777 0 0" >> ./loop/etc/fstab

###

 ###  CHROOT TO LOOP ###
mount -t proc proc loop/proc/ &&  mount -t sysfs sys loop/sys/ && mount -o bind /dev loop/dev/
cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/chroot_vm.sh  loop/tmp/
cp /media/sysdata/rev5/techpool/rev5a1/products/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/3.init_common.sh loop/tmp/
chroot loop /bin/bash -c "sh /tmp/chroot_vm.sh"

###

umount loop/dev && umount loop/proc && umount loop/sys
umount ./loop/media/sysdata && losetup -d /dev/loop61
umount loop && losetup -d /dev/loop60
###

time cp --sparse=always ./in4a1-suse-l.raw ../
time cp --sparse=always ./sysdata.raw ../
