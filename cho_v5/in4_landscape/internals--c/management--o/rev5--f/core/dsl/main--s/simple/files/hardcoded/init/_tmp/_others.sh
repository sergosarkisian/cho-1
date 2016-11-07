#!/bin/bash

## atop
mkdir -p /media/logs/atop
rm -f /etc/systemd/system/rev5_atop.service 				&& ln -s /media/sysdata/rev5/techpool/ontology/logitoring/atop/_systemd/rev5_atop.service			 /etc/systemd/system/ 
systemctl enable rev5_atop && systemctl restart rev5_atop
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
