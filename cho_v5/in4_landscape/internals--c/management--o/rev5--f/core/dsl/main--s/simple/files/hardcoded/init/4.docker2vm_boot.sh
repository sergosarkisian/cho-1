#!/bin/bash

 ### /dev/xvd* blacklisting   ###
cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/51-block-xenvm_blacklist.conf /etc/modprobe.d/
 ### 


 ### BOOT, GRUB2 init ###
grub2-install /dev/loop60
#DOUBLE
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
###
