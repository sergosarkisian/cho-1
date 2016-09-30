#!/bin/bash 

## ZABBIX PROXY ##
rm -f  /etc/tmpfiles.d/rev5_zabbix-proxy.conf && ln -s /media/sysdata/rev5/techpool/ontology/logitoring/zabbix/_systemd/tmpfiles.conf /etc/tmpfiles.d/rev5_zabbix-proxy.conf
systemd-tmpfiles --create
rm -f /etc/systemd/system/rev5_zabbix-proxy.service && cp /media/sysdata/rev5/techpool/ontology/logitoring/zabbix/_systemd/rev5_zabbix-proxy.service 	/etc/systemd/system/ 
systemctl enable rev5_zabbix-proxy.service && systemctl restart rev5_zabbix-proxy.service 
systemctl status rev5_zabbix-proxy.service 
##
