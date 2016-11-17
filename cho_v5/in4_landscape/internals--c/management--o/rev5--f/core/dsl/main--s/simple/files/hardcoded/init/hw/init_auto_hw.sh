#!/bin/bash

if [[ -f /etc/systemd/system/init_auto_hw.service ]]; then  
        
        
        ### /dev/xvd* blacklisting   ###
        depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
        mkinitrd
        depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
        mkinitrd
         ### 
	
        sh /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/scenario/99.post_once.sh
        timedatectl set-timezone Europe/Tallinn
		
	systemctl disable init_auto_hw
        rm -f  /etc/systemd/system/init_auto_hw.service
        rm -f /etc/systemd/system/multi-user.target.wants/init_auto_hw.service
fi
