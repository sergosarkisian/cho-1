#!/bin/bash

. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os
application=$1
instance=$2


if [[ $application == "rev5_SuSEfirewall2_init_i" ]]; then

	if [[ $instance == "simple" ]]; then
		/usr/sbin/SuSEfirewall2 boot_init file /media/sysdata/rev5/_context/conf/SuSEfirewall2_simple/$Net/$SrvType/$SrvName.fw
	fi	

	if [[ $instance == "netfilter" ]]; then
		/usr/sbin/SuSEfirewall2 boot_init file /media/sysdata/rev5/_context/conf/netfilter/$Net/$SrvType/$SrvName/SuSEfirewall2
	fi	
	
	if [[ $instance == "netfilter-ha" ]]; then
		/usr/sbin/SuSEfirewall2 boot_init file /media/sysdata/rev5/_context/conf/netfilter/$Net$MACIP_HA-$SrvContext-$SrvRole-$DeplType/SuSEfirewall2
	fi	
	
fi

if [[ $application == "rev5_SuSEfirewall2_i" ]]; then

	if [[ $instance == "simple" ]]; then
		/usr/sbin/SuSEfirewall2 boot_setup file /media/sysdata/rev5/_context/conf/SuSEfirewall2_simple/$Net/$SrvType/$SrvName.fw
	fi

	if [[ $instance == "netfilter" ]]; then
		/usr/sbin/SuSEfirewall2 boot_setup file /media/sysdata/rev5/_context/conf/netfilter/$Net/$SrvType/$SrvName/SuSEfirewall2
	fi	

	if [[ $instance == "netfilter-ha" ]]; then
		/usr/sbin/SuSEfirewall2 boot_setup file /media/sysdata/rev5/_context/conf/netfilter/$Net/$MACIP_HA-$SrvContext-$SrvRole-$DeplType/SuSEfirewall2
	fi		
fi
	
if [[ $application == "rev5_bareos_os" ]]; then
	/usr/sbin/bareos-fd -c /media/sysdata/rev5/_context/conf/bareos/backup/$View/$Net/$SrvType/$SrvName/client.fd	
fi

if [[ $application == "rev5_samba" ]]; then
	/usr/sbin/smbd -D -s /media/sysdata/rev5/_context/conf/samba/$Net/$SrvType/$SrvName.conf
fi

if [[ $application == "rev5_vm-start" ]]; then
	HV=$SrvName
	. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os $instance
	/usr/sbin/xl -v create /media/sysdata/rev5/_context/conf/xen/$HV/$Org.pool/$Net/$SrvType/$DeplType/$SrvName.hvm.xl
fi

if [[ $application == "rev5_vm-start_dry" ]]; then
	HV=$SrvName
	. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os $instance
	/usr/sbin/xl -Nv  create /media/sysdata/rev5/_context/conf/xen/$HV/$Org.pool/$Net/$SrvType/$DeplType/$SrvName.hvm.xl
	sleep 2
fi

if [[ $application == "rev5_vm-stop" ]]; then
	HV=$SrvName
	. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os $instance
	/usr/sbin/xl -v shutdown $instance
	/usr/sbin/xl -v shutdown -Fw $instance

fi

if [[ $application == "rev5_bind9-ha" ]]; then
	/usr/sbin/named -c /media/sysdata/rev5/_context/conf/bind9/conf/$MACIP_HA-$SrvContext-$SrvRole-$DeplType.conf -f -u named
fi

if [[ $application == "rev5_exim-ha" ]]; then
	/usr/sbin/exim -bd -q2m -L exim -C /media/sysdata/rev5/_context/conf/exim/$MACIP_HA-$SrvContext-$SrvRole-$DeplType/exim.conf
fi

if [[ $application == "drbd8" ]]; then
	cp /media/sysdata/rev5/_context/conf/drbd8//$Net/$SrvType/$SrvName.res /etc/drbd.d/
fi
