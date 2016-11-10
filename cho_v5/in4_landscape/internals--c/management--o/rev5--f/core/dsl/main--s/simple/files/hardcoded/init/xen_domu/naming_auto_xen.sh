#!/bin/bash

if [[ -f /etc/systemd/system/init_auto_xen.service ]]; then  
        
        ### SYSDATA MOUNT -> TO SYSTEMD ###
        sed -i "s/LABEL=sysdata/#LABEL=sysdata/" /etc/fstab
        rm -f /etc/systemd/system/media-sysdata.mount && cp  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/mounts/media-sysdata.mount /etc/systemd/system/
        systemctl enable media-sysdata.mount
        ###
        
        ### /dev/xvd* blacklisting   ###
        cp /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/linux_sys--o/boot--f/dracut/dsl/main--s/simple/files/hardcoded/51-block-xenvm_blacklist.conf /etc/modprobe.d/
        depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
        mkinitrd
        depmod `ls -la /boot/vmlinuz|awk '{print $11}'|sed 's/vmlinuz-//'`
        mkinitrd
         ### 

	DOMID=`xenstore-read domid`
	NAME=`xenstore-read /local/domain/$DOMID/name`
	.  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/naming/naming.sh os $NAME
	
	if [[ $View == "os" ]]; then 
		#hostname
		cp /etc/hosts /etc/hosts.back
		cp /media/sysdata/in4/cho/cho_v3/ontology/linux_sys/suse-network/hosts /etc/hosts
		echo "127.0.0.3 $NAME $SrvName" >> /etc/hosts

                sh /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/post_once.sh
		
		hostnamectl --transient set-hostname $SrvName
		hostnamectl --static set-hostname  $NAME
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
		cp /media/sysdata/in4/cho/cho_v3/ontology/linux_sys/suse-network/ifcfg-tmpl /etc/sysconfig/network/ifcfg-eth0
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
	systemctl disable naming_auto_xen
        rm -f  /etc/systemd/system/init_auto_xen.service
fi
