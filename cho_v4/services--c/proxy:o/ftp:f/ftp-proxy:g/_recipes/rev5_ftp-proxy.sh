#!/bin/bash 

## FTP-PROXY ##
rm -f /etc/systemd/system/rev5_ftp-proxy.service 			&& cp /media/sysdata/rev5/techpool/ontology/proxies/ftp-proxy/_systemd/rev5_ftp-proxy.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_ftp-proxy && ln -s /media/sysdata/rev5/techpool/ontology/proxies/ftp-proxy/_firewall/rev5_ftp-proxy /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload
systemctl enable rev5_ftp-proxy && systemctl restart rev5_ftp-proxy 
systemctl status rev5_ftp-proxy 
##
