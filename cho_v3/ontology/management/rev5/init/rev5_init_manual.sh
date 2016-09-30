#!/bin/bash

if [[ ! -d /etc/rev5 ]]; then  

	echo  "Enter organisation abbr.: "
	read Org
	echo  "Enter SVN password:"
	read SVNPass
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
	
	sed -i "s/# http-proxy-host.*/http-proxy-host = x/" /root/.subversion/servers
	sed -i "s/# http-proxy-port.*/http-proxy-port = 55555/" /root/.subversion/servers

	mkdir /etc/rev5
	svn co --username $Org --password $SVNPass https://svn.edss.ee/techpool /media/sysdata/rev5/techpool
	svn co --username $Org --password $SVNPass https://svn.edss.ee/client/companies/$Org/sdata /media/sysdata/rev5/_context/
	
	cp /media/sysdata/rev5/techpool/ontology/management/rev5/sync_service/rev5.service /etc/systemd/system/
	cp /media/sysdata/rev5/techpool/ontology/management/rev5/sync_service/rev5.timer /etc/systemd/system/	
	
	systemctl enable rev5.timer	
	systemctl daemon-reload
	systemctl restart rev5.timer		
	
        cp /etc/hosts /etc/hosts.back
        cp /media/sysdata/rev5/techpool/ontology/linux_sys/suse-network/hosts /etc/hosts

	echo "127.0.0.3 $MACIP4-$ContextName-$SrvRole-$DeplType.$SrvType.$Net.$View.$Org.pool $MACIP4-$ContextName-$SrvRole-$DeplType" >> /etc/hosts	
	hostnamectl --transient set-hostname $MACIP4-$ContextName-$SrvRole-$DeplType
	hostnamectl --static set-hostname  $MACIP4-$ContextName-$SrvRole-$DeplType.$SrvType.$Net.$View.$Org.pool
	echo "$MACIP4-$ContextName-$SrvRole-$DeplType.$SrvType.$Net.$View.$Org.pool" > /etc/HOSTNAME 
fi 
