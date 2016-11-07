#!/bin/bash

SVN_UP_CONTEXT=`svn st -u /media/sysdata/rev5/_context/|grep "*" -c`
SVN_UP_TECHPOOL=`svn st -u /media/sysdata/rev5/techpool/|grep "*" -c`

if [[ $SVN_UP_CONTEXT != "0" || $SVN_UP_TECHPOOL != "0" ]]; then
	svn up /media/sysdata/rev5/techpool/
	svn up /media/sysdata/rev5/_context/
	
	# Set root permissions	
	setfacl -R -m u:root:rwx /media/sysdata/rev5
	setfacl -R -m d:u:root:rwx /media/sysdata/rev5
	
	#Set system app permissions
	setfacl -R -m g:sysapp:rx /media/sysdata/rev5
	setfacl -R -m d:g:sysapp:rx /media/sysdata/rev5	
	
	#setfacl - others
	setfacl -R -m u::rwx /media/sysdata/rev5
	setfacl -R -m g::rwx /media/sysdata/rev5
	setfacl -R -m d:u::rwx /media/sysdata/rev5
	setfacl -R -m d:g::rwx /media/sysdata/rev5	
	
fi


if [[ ! -f /media/sysdata/rev5/firstinit.invasive && ! -d /etc/faster/cmdb ]]; then  

. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os

	## SSH
	rm  /etc/ssh/ssh_host_*
	ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
	ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
	ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
	ssh-keygen -q -t rsa1 -b 2048 -f /etc/ssh/ssh_host_key -N ''
	chmod 644 /etc/ssh/ssh_host_*.pub
	systemctl restart sshd.service
	##
		
	## REGENERATE machine-id
	rm /etc/machine-id
	systemd-machine-id-setup
	##

	## PAM SETTINGS
	pam-config --add --sss
	pam-config --add --mkhomedir
	##		
	
	##SERVICES FIRST ENABLE/START
	/sbin/yast security level server
	/sbin/rcapparmor start
	systemctl disable ntpd
	##	

	zypper --non-interactive --gpg-auto-import-keys dup 	

	rm -f /etc/exim/exim.conf && ln -s /media/sysdata/rev5/techpool/ontology/mail/exim/simple/smarthost.conf /etc/exim/exim.conf
	touch /media/sysdata/rev5/firstinit.invasive
fi

if [[ ! -f /media/sysdata/rev5/firstinit.safe && ! -d /etc/faster/cmdb ]]; then  
. /media/sysdata/rev5/techpool/ontology/management/rev5/naming.sh os
 
	## MKDIRs
	mkdir -p /media/logs/atop
	mkdir -p /media/logs/syslog_bus/_client
	mkdir -p /media/logs/syslog
	mkdir -p /media/logs/files	
	mkdir -p /media/storage
	
	chmod 755 /media/
	chmod 755 /media/storage	
	##
	
	#Set logs permissions
	setfacl -R -m   u:log:rwx 	/media/logs
	setfacl -R -m d:u:log:rwx 	/media/logs	
	setfacl -R -m   g:log:rx 	/media/logs
	setfacl -R -m d:g:log:rx 	/media/logs
	#
		
	rm -f  /etc/profile.d/administrators.sh && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/administrators.sh /etc/profile.d/ 
	rm -f  /etc/profile.d/power.sh && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/power.sh /etc/profile.d/ 
	rm -f  /etc/profile.d/support.sh && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/support.sh /etc/profile.d/ 
	
	chmod 744 /etc/profile.d/*
	#
	
	cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/sssd_basic.conf /etc/sssd/sssd.conf	
	sed -i "s/%ORG%/$Org/" /etc/sssd/sssd.conf	
	sed -i "s/%NET%/$Net/" /etc/sssd/sssd.conf	

	sysctl -p /etc/sysctl.d/*
	systemctl daemon-reload
	
	systemctl enable rev5.timer && systemctl restart rev5.timer

	chmod 644 /etc/systemd/system/rev5*
	touch /media/sysdata/rev5/firstinit.safe
fi



