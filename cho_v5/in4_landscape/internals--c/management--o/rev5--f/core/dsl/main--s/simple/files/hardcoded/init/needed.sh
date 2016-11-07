## sssd
cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/sssd_basic.conf /etc/sssd/sssd.conf	
sed -i "s/%ORG%/$Org/" /etc/sssd/sssd.conf	
sed -i "s/%NET%/$Net/" /etc/sssd/sssd.conf	
rm -f /etc/systemd/system/rev5_sssd.service  				&& ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/_systemd/rev5_sssd.service 		/etc/systemd/system/  
systemctl disable sssd && systemctl stop sssd && systemctl enable rev5_sssd && systemctl restart rev5_sssd
##
	
		systemctl enable rev5.timer && systemctl restart rev5.timer

		
		## rsyslog
mkdir -p /media/logs/syslog_bus/_client
rm -f /etc/systemd/system/rev5_rsyslog_i@.service 			&& ln -s /media/sysdata/rev5/techpool/ontology/logitoring/rsyslog/_systemd/rev5_rsyslog_i@.service 	/etc/systemd/system/ 
systemctl disable rsyslog && systemctl stop rsyslog
rm /usr/lib/systemd/system/rsyslog.service
rm -f /usr/lib/systemd/system/rsyslog.service && ln -s /dev/null /usr/lib/systemd/system/rsyslog.service 
systemctl enable rev5_rsyslog_i@client && systemctl restart rev5_rsyslog_i@client
##




## sfw2
rm -f /etc/systemd/system/rev5_SuSEfirewall2_init_i@.service 	&& ln -s /media/sysdata/rev5/techpool/ontology/security/SuSEfirewall2/_systemd/rev5_SuSEfirewall2_init_i@.service /etc/systemd/system/ 
rm -f /etc/systemd/system/rev5_SuSEfirewall2_i@.service 	&& ln -s /media/sysdata/rev5/techpool/ontology/security/SuSEfirewall2/_systemd/rev5_SuSEfirewall2_i@.service /etc/systemd/system/ 	
systemctl disable SuSEfirewall2 && systemctl stop SuSEfirewall2
systemctl disable SuSEfirewall2_init && systemctl stop SuSEfirewall2_init
systemctl enable rev5_SuSEfirewall2_i@simple && systemctl restart rev5_SuSEfirewall2_i@simple
##
