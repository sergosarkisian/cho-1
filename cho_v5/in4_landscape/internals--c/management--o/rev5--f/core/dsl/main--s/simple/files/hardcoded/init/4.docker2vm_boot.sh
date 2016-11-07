#!/bin/bash

 ### BOOT, GRUB2 init ###
grub2-install /dev/loop60
#DOUBLE
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
mkinitrd
###
