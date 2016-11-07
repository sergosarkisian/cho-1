#!/bin/bash

if [[ ! -f /etc/rev5/firstinit.hostip && ! -d /etc/faster/cmdb ]]; then  
	DOMID=`xenstore-read domid`
	NAME=`xenstore-read /local/domain/$DOMID/name`
	.  /etc/rev5/static/naming.sh os $NAME
	
	if [[ $View == "os" ]]; then 
		#hostname
		cp /etc/hosts /etc/hosts.back
		cp /etc/rev5/static/hosts /etc/hosts
		echo "127.0.0.3 $NAME $SrvName" >> /etc/hosts
                rm /etc/machine-id
                systemd-machine-id-setup
		hostnamectl --transient set-hostname $SrvName
		hostnamectl --static set-hostname  $NAME
		echo "$NAME" > /etc/HOSTNAME 
	fi
	
	#xenstore
	xenstore-exists /local/domain/$DOMID/rev5/net/0
	if [[ `echo $?` == 0 ]]; then 
		IP=`xenstore-read /local/domain/$DOMID/rev5/net/0/ip`
		NETMASK=`xenstore-read /local/domain/$DOMID/rev5/net/0/netmask`
		MTU=`xenstore-read /local/domain/$DOMID/rev5/net/0/mtu`
		GATE=`xenstore-read /local/domain/$DOMID/rev5/net/0/gate`
		
		#net
		cp /etc/rev5/static/ifcfg-tmpl /etc/sysconfig/network/ifcfg-eth0
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
	systemctl disable rev5_init_auto_xen
	touch /etc/rev5/firstinit.hostip
fi
