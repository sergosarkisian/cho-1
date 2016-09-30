#!/bin/bash


if [[ ! -f /media/sysdata/rev5/firstinit.invasive ]]; then  

	svn up /media/sysdata/rev5/techpool/
	svn up /media/sysdata/rev5/_context/
	
	# Set root permissions	
	setfacl -R -m u:root:rwx /etc/rev5
	setfacl -R -m d:u:root:rwx /etc/rev5
	
	#Set system app permissions
	setfacl -R -m g:sysapp:rx /etc/rev5
	setfacl -R -m d:g:sysapp:rx /etc/rev5	
	
	#setfacl - others
	setfacl -R -m u::rwx /etc/rev5
	setfacl -R -m g::rwx /etc/rev5
	setfacl -R -m d:u::rwx /etc/rev5
	setfacl -R -m d:g::rwx /etc/rev5	
	
	chmod 644 /etc/systemd/system/rev5*



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
	

	groupadd -g 999 sysapp
	usermod -G sysapp mail
	usermod -G sysapp haproxy	
	usermod -G sysapp bareos	



	## MKDIRs
	mkdir -p /media/logs/atop
	mkdir -p /media/logs/syslog_bus/_client
	mkdir -p /media/logs/syslog
	mkdir -p /media/logs/files	
	mkdir -p /media/storage

	##
	
	#Set logs permissions
	setfacl -R -m   u:log:rwx 	/media/logs
	setfacl -R -m d:u:log:rwx 	/media/logs	
	setfacl -R -m   g:log:rx 	/media/logs
	setfacl -R -m d:g:log:rx 	/media/logs
	#
	

	#SystemD
	rm -f /etc/systemd/system.conf && ln -s /media/sysdata/rev5/techpool/ontology/linux_sys/systemd/systemd_defaults.conf /etc/systemd/system.conf
	rm -f /etc/systemd/user.conf 	 && ln -s /media/sysdata/rev5/techpool/ontology/linux_sys/systemd/systemd_defaults.conf /etc/systemd/user.conf
	#
		
	## CP -> to LN
	rm -f /etc/nsswitch.conf &&  cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/nsswitch.conf /etc/ && chmod 744 /etc/nsswitch.conf
	rm -f  /etc/bash.bashrc.local && cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/bash.bashrc.local /etc/bash.bashrc.local && chmod 755 /etc/bash.bashrc.local
	rm -f /etc/bash.audit && cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/bash.audit /etc/bash.audit && chmod 755 /etc/bash.audit
	
	rm -f  /etc/profile.d/administrators.sh && cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/administrators.sh /etc/profile.d/ 
	rm -f  /etc/profile.d/power.sh && cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/power.sh /etc/profile.d/ 
	rm -f  /etc/profile.d/support.sh && cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/support.sh /etc/profile.d/ 
	
	chmod 744 /etc/profile.d/*
	#
	rm -f  /etc/tmpfiles.d/erl-zabbix.conf && ln -s /media/sysdata/rev5/techpool/ontology/logitoring/erl-zabbix/_systemd/tmpfiles.conf /etc/tmpfiles.d/erl-zabbix.conf
	systemd-tmpfiles --create
	
	rm -f /etc/systemd/system/rev5.service 					&& cp /media/sysdata/rev5/techpool/ontology/management/rev5/sync_service/rev5.service 			/etc/systemd/system/
	rm -f /etc/systemd/system/rev5.timer 					&& cp /media/sysdata/rev5/techpool/ontology/management/rev5/sync_service/rev5.timer 			/etc/systemd/system/ 
	rm -f /etc/systemd/system/rev5_auditd.service  			&& cp /media/sysdata/rev5/techpool/ontology/security/auditd/_systemd/rev5_auditd.service 			/etc/systemd/system/  	
	rm -f /etc/systemd/system/rev5_sssd.service  				&& cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/_systemd/rev5_sssd.service 		/etc/systemd/system/  
	rm -f /etc/systemd/system/rev5_SuSEfirewall2_init_i@.service 	&& cp /media/sysdata/rev5/techpool/ontology/security/SuSEfirewall2/_systemd/rev5_SuSEfirewall2_init_i@.service /etc/systemd/system/ 
	rm -f /etc/systemd/system/rev5_SuSEfirewall2_i@.service 	&& cp /media/sysdata/rev5/techpool/ontology/security/SuSEfirewall2/_systemd/rev5_SuSEfirewall2_i@.service /etc/systemd/system/ 	
	rm -f /etc/systemd/system/rev5_monitoring-os.service 		&& cp /media/sysdata/rev5/techpool/ontology/logitoring/erl-zabbix/_systemd/rev5_monitoring-os.service /etc/systemd/system/ 
	rm -f /etc/systemd/system/rev5_rsyslog_i@.service 			&& cp /media/sysdata/rev5/techpool/ontology/logitoring/rsyslog/_systemd/rev5_rsyslog_i@.service 	/etc/systemd/system/ 
	rm -f /etc/systemd/system/rev5_atop.service 				&& cp /media/sysdata/rev5/techpool/ontology/logitoring/atop/_systemd/rev5_atop.service			 /etc/systemd/system/ 
	
	#apparmor
	systemctl disable apparmor.service
	rm -f /etc/systemd/system/rev5_apparmor.service 				&& cp /media/sysdata/rev5/techpool/ontology/security/apparmor/_systemd/rev5_apparmor.service			 /etc/systemd/system/	
	#
	
	# +stunnel
	
	#rev5_bareos-os
	rm -f /etc/systemd/system/rev5_bareos-os.service 			&& cp /media/sysdata/rev5/techpool/ontology/data_safety/bareos/_systemd/rev5_bareos-os.service 	/etc/systemd/system/ 
	rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_bareos-os && ln -s /media/sysdata/rev5/techpool/ontology/data_safety/bareos/_firewall/rev5_bareos-os /etc/sysconfig/SuSEfirewall2.d/services/
	#
	
	#sshd
	rm -f /etc/systemd/system/rev5_sshd.service 			&& cp /media/sysdata/rev5/techpool/ontology/network/sshd/_systemd/rev5_sshd.service 	/etc/systemd/system/ 
	rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_sshd && ln -s /media/sysdata/rev5/techpool/ontology/network/sshd/_firewall/rev5_sshd /etc/sysconfig/SuSEfirewall2.d/services/
	#
	
	# ALT: systemd scope - http://www.freedesktop.org/software/systemd/man/systemd.scope.html
	systemctl daemon-reload
	
	systemctl enable rev5.timer && systemctl restart rev5.timer
	systemctl disable sssd && systemctl stop sssd && systemctl enable rev5_sssd && systemctl restart rev5_sssd
	systemctl disable auditd && systemctl stop auditd && systemctl enable rev5_auditd && systemctl restart rev5_auditd	
	systemctl disable monitoring && systemctl stop monitoring	
	systemctl disable rsyslog && systemctl stop rsyslog
	rm /usr/lib/systemd/system/rsyslog.service
	rm -f /usr/lib/systemd/system/rsyslog.service && ln -s /dev/null /usr/lib/systemd/system/rsyslog.service 
	systemctl enable rev5_rsyslog_i@client && systemctl restart rev5_rsyslog_i@client
	systemctl enable rev5_atop && systemctl restart rev5_atop
	
	systemctl enable rev5_bareos-os && systemctl restart rev5_bareos-os
	systemctl enable rev5_monitoring-os && systemctl restart rev5_monitoring-os
	systemctl disable sshd && systemctl stop sshd && systemctl enable rev5_sshd && systemctl restart rev5_sshd



	chmod 644 /etc/systemd/system/rev5*
	touch /media/sysdata/rev5/firstinit.safe
	touch /media/sysdata/rev5/firstinit.invasive
	touch /media/sysdata/rev5/firstinit.hostip
	touch /media/sysdata/rev5/rev4_to_rev5
	


fi



