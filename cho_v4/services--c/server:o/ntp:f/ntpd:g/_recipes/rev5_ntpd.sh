#!/bin/bash 

## NTPD ##

#Apparmor BUG
rm /etc/apparmor.d/usr.sbin.ntpd
systemctl restart rev5_apparmor.service
#

rm -f /etc/ntp.conf && ln -s /media/sysdata/rev5/techpool/ontology/linux_sys/ntpd/ntp.conf /etc/

rm -f  /etc/tmpfiles.d/rev5_ntpd.conf && ln -s /media/sysdata/rev5/techpool/ontology/linux_sys/ntpd/_systemd/tmpfiles.conf /etc/tmpfiles.d/rev5_ntpd.conf
systemd-tmpfiles --create
rm -f /etc/systemd/system/rev5_ntpd.service && cp /media/sysdata/rev5/techpool/ontology/linux_sys/ntpd/_systemd/rev5_ntpd.service 	/etc/systemd/system/ 
systemctl enable rev5_ntpd.service && systemctl restart rev5_ntpd.service 
systemctl status rev5_ntpd.service 
##
