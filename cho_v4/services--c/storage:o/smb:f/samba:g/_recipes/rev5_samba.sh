#!/bin/bash 

## PURE-FTPD ##
rm -f /etc/systemd/system/rev5_samba.service 			&& cp /media/sysdata/rev5/techpool/ontology/storage/samba/_systemd/rev5_samba.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_samba 	&& ln -s /media/sysdata/rev5/techpool/ontology/storage/samba/_firewall/rev5_samba /etc/sysconfig/SuSEfirewall2.d/services/
systemctl enable rev5_samba && systemctl restart rev5_samba && systemctl status rev5_samba
##
