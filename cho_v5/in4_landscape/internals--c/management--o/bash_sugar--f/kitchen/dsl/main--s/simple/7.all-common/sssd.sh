### SSSD ###

#CONF
pam-config --add --sss
rm -f  /etc/sssd/sssd.conf && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/security:f/sssd--g/sssd_basic.conf /etc/sssd/sssd.conf
chmod 700 /etc/sssd/sssd.conf
systemctl enable sssd
#mkdir -p /etc/ssl/my/ && cp /etc/faster/cmdb/data/certificates/edss/ca/a.services.pool.pem /etc/ssl/my/core_ca.pem
# cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/sssd_basic.conf /etc/sssd/sssd.conf	
# sed -i "s/%ORG%/$Org/" /etc/sssd/sssd.conf	
# sed -i "s/%NET%/$Net/" /etc/sssd/sssd.conf	
# #PROFILE.D
# 
# #SYSTEMD
# rm -f /etc/systemd/system/rev5_sssd.service  				&& ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/_systemd/rev5_sssd.service 		/etc/systemd/system/  
# systemctl disable sssd && ! systemctl stop sssd && systemctl enable rev5_sssd && ! systemctl restart rev5_sssd
###
