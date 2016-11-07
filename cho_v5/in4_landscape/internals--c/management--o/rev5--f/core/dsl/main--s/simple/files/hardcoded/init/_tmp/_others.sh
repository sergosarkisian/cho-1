#!/bin/bash
## linux - common
rm -f /etc/nsswitch.conf &&  cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/nsswitch.conf /etc/ && chmod 744 /etc/nsswitch.conf
rm -f /etc/exim/exim.conf && ln -s /media/sysdata/rev5/techpool/ontology/mail/exim/simple/smarthost.conf /etc/exim/exim.conf
##


## sysctl
cp /media/sysdata/rev5/techpool/ontology/linux_sys/sysctl/main.conf /etc/sysctl.d/
cp /media/sysdata/rev5/techpool/ontology/linux_sys/sysctl/memory.conf /etc/sysctl.d/
cp /media/sysdata/rev5/techpool/ontology/linux_sys/sysctl/network.conf /etc/sysctl.d/
cp /media/sysdata/rev5/techpool/ontology/linux_sys/sysctl/server.conf /etc/sysctl.d/
sysctl -p /etc/sysctl.d/*
##

## atop
mkdir -p /media/logs/atop
rm -f /etc/systemd/system/rev5_atop.service 				&& ln -s /media/sysdata/rev5/techpool/ontology/logitoring/atop/_systemd/rev5_atop.service			 /etc/systemd/system/ 
systemctl enable rev5_atop && systemctl restart rev5_atop
##

## rsyslog
mkdir -p /media/logs/syslog_bus/_client
rm -f /etc/systemd/system/rev5_rsyslog_i@.service 			&& ln -s /media/sysdata/rev5/techpool/ontology/logitoring/rsyslog/_systemd/rev5_rsyslog_i@.service 	/etc/systemd/system/ 
systemctl disable rsyslog && systemctl stop rsyslog
rm /usr/lib/systemd/system/rsyslog.service
rm -f /usr/lib/systemd/system/rsyslog.service && ln -s /dev/null /usr/lib/systemd/system/rsyslog.service 
systemctl enable rev5_rsyslog_i@client && systemctl restart rev5_rsyslog_i@client
##

## sudo
cp /media/sysdata/rev5/techpool/ontology/security/sudo/etc_sudoers /etc/sudoers
##

##systemd
rm -f /etc/systemd/system.conf && ln -s /media/sysdata/rev5/techpool/ontology/linux_sys/systemd/systemd_defaults.conf /etc/systemd/system.conf
rm -f /etc/systemd/user.conf 	 && ln -s /media/sysdata/rev5/techpool/ontology/linux_sys/systemd/systemd_defaults.conf /etc/systemd/user.conf
##

## bash
rm -f  /etc/bash.bashrc.local && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/bash.bashrc.local /etc/bash.bashrc.local && chmod 755 /etc/bash.bashrc.local
##

## profile.d
rm -f  /etc/profile.d/administrators.sh && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/administrators.sh /etc/profile.d/ 
rm -f  /etc/profile.d/power.sh && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/power.sh /etc/profile.d/ 
rm -f  /etc/profile.d/support.sh && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/support.sh /etc/profile.d/ 
chmod 744 /etc/profile.d/*
#

## sssd
cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/sssd_basic.conf /etc/sssd/sssd.conf	
sed -i "s/%ORG%/$Org/" /etc/sssd/sssd.conf	
sed -i "s/%NET%/$Net/" /etc/sssd/sssd.conf	
rm -f /etc/systemd/system/rev5_sssd.service  				&& ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/_systemd/rev5_sssd.service 		/etc/systemd/system/  
systemctl disable sssd && systemctl stop sssd && systemctl enable rev5_sssd && systemctl restart rev5_sssd
##

#apparmor
systemctl disable apparmor.service
rm -f /etc/systemd/system/rev5_apparmor.service 				&& ln -s /media/sysdata/rev5/techpool/ontology/security/apparmor/_systemd/rev5_apparmor.service			 /etc/systemd/system/	
#

#rev5_bareos-os
rm -f /etc/systemd/system/rev5_bareos-os.service 			&& ln -s /media/sysdata/rev5/techpool/ontology/data_safety/bareos/_systemd/rev5_bareos-os.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_bareos-os && ln -s /media/sysdata/rev5/techpool/ontology/data_safety/bareos/_firewall/rev5_bareos-os /etc/sysconfig/SuSEfirewall2.d/services/
systemctl enable rev5_bareos-os && systemctl restart rev5_bareos-os
#

#sshd
rm -f /etc/systemd/system/rev5_sshd.service 			&& ln -s /media/sysdata/rev5/techpool/ontology/network/sshd/_systemd/rev5_sshd.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_sshd && ln -s /media/sysdata/rev5/techpool/ontology/network/sshd/_firewall/rev5_sshd /etc/sysconfig/SuSEfirewall2.d/services/
systemctl disable sshd && systemctl stop sshd && systemctl enable rev5_sshd && systemctl restart rev5_sshd
#

## erl-zabbix
rm -f  /etc/tmpfiles.d/erl-zabbix.conf && ln -s /media/sysdata/rev5/techpool/ontology/logitoring/erl-zabbix/_systemd/tmpfiles.conf /etc/tmpfiles.d/erl-zabbix.conf
systemd-tmpfiles --create
rm -f /etc/systemd/system/rev5_monitoring-os.service 		&& ln -s /media/sysdata/rev5/techpool/ontology/logitoring/erl-zabbix/_systemd/rev5_monitoring-os.service /etc/systemd/system/ 
systemctl enable rev5_monitoring-os && systemctl restart rev5_monitoring-os
##

## auditd
rm -f /etc/systemd/system/rev5_auditd.service  			&& ln -s /media/sysdata/rev5/techpool/ontology/security/auditd/_systemd/rev5_auditd.service 			/etc/systemd/system/  	
systemctl disable auditd && systemctl stop auditd && systemctl enable rev5_auditd
##

##TMP - GRUB2 + SYSTEMD PROBLEM
rm -f /etc/systemd/system/rev5_remount.service 			&& ln -s /media/sysdata/rev5/techpool/ontology/management/rev5/_dev/rev5_remount.service 	/etc/systemd/system/
systemctl enable rev5_remount && systemctl restart rev5_remount
##

## sfw2
rm -f /etc/systemd/system/rev5_SuSEfirewall2_init_i@.service 	&& ln -s /media/sysdata/rev5/techpool/ontology/security/SuSEfirewall2/_systemd/rev5_SuSEfirewall2_init_i@.service /etc/systemd/system/ 
rm -f /etc/systemd/system/rev5_SuSEfirewall2_i@.service 	&& ln -s /media/sysdata/rev5/techpool/ontology/security/SuSEfirewall2/_systemd/rev5_SuSEfirewall2_i@.service /etc/systemd/system/ 	
systemctl disable SuSEfirewall2 && systemctl stop SuSEfirewall2
systemctl disable SuSEfirewall2_init && systemctl stop SuSEfirewall2_init
systemctl enable rev5_SuSEfirewall2_i@simple && systemctl restart rev5_SuSEfirewall2_i@simple
##

systemctl daemon-reload
