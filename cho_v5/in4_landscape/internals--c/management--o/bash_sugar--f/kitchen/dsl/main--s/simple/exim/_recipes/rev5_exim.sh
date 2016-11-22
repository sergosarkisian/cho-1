#!/bin/bash 

## EXIM ##
rm -f /etc/systemd/system/rev5_exim.service 			&& cp /media/sysdata/rev5/techpool/ontology/mail/exim/mta-router/_systemd/rev5_exim.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_exim && ln -s /media/sysdata/rev5/techpool/ontology/mail/exim/mta-router/_firewall/rev5_exim /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload
systemctl enable rev5_exim.service && systemctl restart rev5_exim.service 
systemctl status rev5_exim.service 
##
