#!/bin/bash 

## BIND9 ##
systemctl disable rev5_bind9.service && systemctl stop rev5_bind9.service 
rm -f /etc/systemd/system/rev5_bind9.service


rm -f /etc/systemd/system/rev5_bind9-ha.service 			&& cp /media/sysdata/rev5/techpool/ontology/proxies/bind9/_systemd/rev5_bind9-ha.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_bind9 && ln -s /media/sysdata/rev5/techpool/ontology/proxies/bind9/_firewall/rev5_bind9 /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload
systemctl enable rev5_bind9-ha.service && systemctl restart rev5_bind9-ha.service 
systemctl status rev5_bind9-ha.service 

##
