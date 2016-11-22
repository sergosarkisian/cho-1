#!/bin/bash

if [[ -f /etc/systemd/system/init_auto_hw.service ]]; then  
        
        
        ### /dev/xvd* blacklisting   ###
        depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
        mkinitrd
        depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
        mkinitrd
         ### 
	
        sh /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/2.scenario/99.post_once.sh
        timedatectl set-timezone Europe/Tallinn
		
        INTERFACES=`wicked show-xml all|grep "<name>"|sed "s/<name>//; s/<\/name>//"|awk '{print $1}'|grep -v "^lo$"`
        for INTERFACE in $INTERFACES; do
            cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/internals/deploy/in4_bash/os/_sub/hw_chroot/3.env/dhcp /etc/sysconfig/network/ifcfg-$INTERFACE ## BUG
        done
        
        systemctl restart network
        
	systemctl disable init_auto_hw
        rm -f  /etc/systemd/system/init_auto_hw.service
        rm -f /etc/systemd/system/multi-user.target.wants/init_auto_hw.service
fi
