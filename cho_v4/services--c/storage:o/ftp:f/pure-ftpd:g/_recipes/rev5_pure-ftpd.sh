#!/bin/bash 

## PURE-FTPD ##
rm -f /etc/systemd/system/rev5_pure-ftpd.service 			&& cp /media/sysdata/rev5/techpool/ontology/storage/pure-ftpd/_systemd/rev5_pure-ftpd.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_pure-ftpd 	&& ln -s /media/sysdata/rev5/techpool/ontology/storage/pure-ftpd/_firewall/rev5_pure-ftpd /etc/sysconfig/SuSEfirewall2.d/services/
systemctl enable rev5_pure-ftpd && systemctl restart rev5_pure-ftpd && systemctl status rev5_pure-ftpd
##
