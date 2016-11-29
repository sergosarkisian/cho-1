#!/bin/bash

if [[ -f /etc/systemd/system/init_auto_xen.service ]]; then  
. /media/sysdata/in4/cho/in4_core/internals/helpers/in4func.sh       
        
        ### /dev/xvd* blacklisting   ###
        in4func_cp "internals--c--linux_sys--o--boot--f--dracut--g--main--s" "simple/51-block-xenvm_blacklist.conf" "/etc/modprobe.d/"
        depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
        mkinitrd
        depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
        mkinitrd
         ### 
        
        ###  DISABLE NET DHCP ### 
        cp /media/sysdata/in4/cho/in4_core/internals/deploy/in4_bash/os/_base/build/3.env/wtf/wickedd-dhcp /usr/lib/systemd/system/wickedd-auto4.service
        cp /media/sysdata/in4/cho/in4_core/internals/deploy/in4_bash/os/_base/build/3.env/wtf/wickedd-dhcp /usr/lib/systemd/system/wickedd-dhcp4.service
        systemctl disable wickedd-dhcp6
        systemctl mask wickedd-dhcp6
        ### 
	DOMID=`xenstore-read domid`
	NAME=`xenstore-read /local/domain/$DOMID/name`
	.  /media/sysdata/in4/cho/in4_core/internals/naming/naming.sh os $NAME
	
	if [[ $View == "os" ]]; then 
		#hostname
		cp /etc/hosts /etc/hosts.back
		cp /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/network:f/suse-network:g/hosts /etc/hosts
		echo "127.0.0.3 $NAME $SrvName" >> /etc/hosts

                sh /media/sysdata/in4/cho/in4_core/internals/deploy/in4_bash/os/_base/build/2.scenario/99.post_once.sh
		
		hostnamectl --transient set-hostname $SrvName
		hostnamectl --static set-hostname  $NAME
		timedatectl set-timezone Europe/Tallinn
		echo "$NAME" > /etc/HOSTNAME 
	fi
	
	#xenstore
	xenstore-exists /local/domain/$DOMID/in4/net/0
	if [[ `echo $?` == 0 ]]; then 
		IP=`xenstore-read /local/domain/$DOMID/in4/net/0/ip`
		NETMASK=`xenstore-read /local/domain/$DOMID/in4/net/0/netmask`
		MTU=`xenstore-read /local/domain/$DOMID/in4/net/0/mtu`
		GATE=`xenstore-read /local/domain/$DOMID/in4/net/0/gate`
		
		#net
		cp /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/network:f/suse-network:g/ifcfg-tmpl /etc/sysconfig/network/ifcfg-eth0
		sed -i "s/{IP}/$IP/"  /etc/sysconfig/network/ifcfg-eth0
		sed -i "s/{NETMASK}/$NETMASK/"  /etc/sysconfig/network/ifcfg-eth0
		sed -i "s/{MTU}/$MTU/"  /etc/sysconfig/network/ifcfg-eth0	
		
		#gate
		echo "default $GATE - -" > /etc/sysconfig/network/routes
		
		#dns
		echo "search s.pool" > /etc/resolv.conf
		echo "nameserver $GATE" >> /etc/resolv.conf
		
		systemctl restart network
	fi
	systemctl disable init_auto_xen
        rm -f  /etc/systemd/system/init_auto_xen.service
        rm -f /etc/systemd/system/multi-user.target.wants/init_auto_xen.service
        reboot
fi
