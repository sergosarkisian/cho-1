#!/bin/bash


 ### DRACUT  ###
cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/dracut.conf-vm /etc/dracut.conf
 ### 
 
 
 ### GRUB2  ###
cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/etc_default_grub--vm_xen /etc/default/grub
mkdir -p  /boot/grub2/
cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/grub2/dsl/main--s/simple/files/hardcoded/boot_grub2_grub.cfg--xen-all /boot/grub2/grub.cfg
 ### 
 

  ### BOOT, GRUB2 init ###
  
# case $TYPE in
#     "vm") grub2-install /dev/loop60 ; sed -i "s/set default=.*/set default=\"ConeCenter - in4 - Xen - Domu - HVM\"/"  /boot/grub2/grub.cfg ;;
#     "hw") grub2-install /dev/$IN4_SYSDATA_DISK; grub2-install /dev/${IN4_SYSDATA_DISK}1; sed -i "s/set default=.*/set default=\"ConeCenter - in4 - HW\"/"  /boot/grub2/grub.cfg ;;
# esac  
#DOUBLE
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
###
