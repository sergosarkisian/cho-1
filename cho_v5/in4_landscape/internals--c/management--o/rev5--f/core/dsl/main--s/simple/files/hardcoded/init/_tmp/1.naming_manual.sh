#!/bin/bash

if [[ ! -d /media/sysdata/rev5 ]]; then  

	echo  "Enter organisation abbr.: "
	read Org
	View="os"	
	echo  "Enter VLAN ID.: "
	read Net	
	echo  "Enter server type (ex. - rev5-suse-l ):"
	read SrvType
	echo  "Enter deployment type (test,dev,prod):"
	read DeplType	
	echo  "Enter server role (ex. hvxen,gate,core,coneapp2,coneapp3,ora10,pg,mysql,php,we2...):"
	read SrvRole
	echo  "Enter 4 octects of MAC/IP:"
	read MACIP4			
	echo  "Enter server context name ( 'vm' or 'phy' if none):"
	read ContextName
	
        cp /etc/hosts /etc/hosts.back
        cp /media/sysdata/rev5/techpool/ontology/linux_sys/suse-network/hosts /etc/hosts

	echo "127.0.0.3 $MACIP4-$ContextName-$SrvRole-$DeplType.$SrvType.$Net.$View.$Org.pool $MACIP4-$ContextName-$SrvRole-$DeplType" >> /etc/hosts	
	hostnamectl --transient set-hostname $MACIP4-$ContextName-$SrvRole-$DeplType
	hostnamectl --static set-hostname  $MACIP4-$ContextName-$SrvRole-$DeplType.$SrvType.$Net.$View.$Org.pool
	echo "$MACIP4-$ContextName-$SrvRole-$DeplType.$SrvType.$Net.$View.$Org.pool" > /etc/HOSTNAME 
fi 
