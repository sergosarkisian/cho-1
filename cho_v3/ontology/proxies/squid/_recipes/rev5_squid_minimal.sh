#!/bin/bash 

## SQUID ##
rm -f /etc/systemd/system/rev5_squid.service 			&& cp /media/sysdata/rev5/techpool/ontology/proxies/squid/_systemd/rev5_squid.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_squid && ln -s /media/sysdata/rev5/techpool/ontology/proxies/squid/_firewall/rev5_squid /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload
systemctl enable rev5_squid && systemctl restart rev5_squid
systemctl status rev5_squid
##
