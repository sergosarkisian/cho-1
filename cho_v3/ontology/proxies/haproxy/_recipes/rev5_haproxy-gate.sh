#!/bin/bash 

## HAPROXY ##
#mkdir /etc/ssl/haproxy/
#manual - cer init install
rm /etc/apparmor.d/usr.sbin.haproxy ## BUG !!!

rm -f /etc/systemd/system/rev5_haproxy_i@.service 			&& cp /media/sysdata/rev5/techpool/ontology/proxies/haproxy/_systemd/rev5_haproxy_i@.service 	/etc/systemd/system/ 

rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_haproxy_i@tcp-infra && ln -s /media/sysdata/rev5/techpool/ontology/proxies/haproxy/_firewall/rev5_haproxy_i@tcp-infra /etc/sysconfig/SuSEfirewall2.d/services/
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_haproxy_i@tcp-web  && ln -s /media/sysdata/rev5/techpool/ontology/proxies/haproxy/_firewall/rev5_haproxy_i@tcp-web /etc/sysconfig/SuSEfirewall2.d/services/
systemctl daemon-reload

systemctl enable rev5_haproxy_i@tcp-web.service && systemctl restart rev5_haproxy_i@tcp-web.service
systemctl enable rev5_haproxy_i@tcp-infra.service && systemctl restart rev5_haproxy_i@tcp-infra.service

systemctl enable rev5_haproxy_i@http-web.service && systemctl restart rev5_haproxy_i@http-web.service
##
