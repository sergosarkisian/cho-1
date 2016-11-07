### ZYPPER ###
#CONF
rm -f  /etc/zypp/zypp.conf && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/conf/zypp.conf /etc/zypp/zypp.conf
rm -f /etc/zypp/zypper.conf && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/conf/zypper.conf /etc/zypp/zypper.conf
#PROFILE.D
rm -f /etc/profile.d/in4__zypper.sh && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/profile.d/zypper.conf /etc/profile.d/in4__zypper.sh

###





### NAME ###
#CONF

#PROFILE.D

#SYSTEMD

#SWF2
###

#
systemd = profile.d + conf
rm -f /etc/systemd/system.conf && ln -s /media/sysdata/rev5/techpool/ontology/linux_sys/systemd/systemd_defaults.conf /etc/systemd/system.conf
rm -f /etc/systemd/user.conf 	 && ln -s /media/sysdata/rev5/techpool/ontology/linux_sys/systemd/systemd_defaults.conf /etc/systemd/user.conf

sssd =  conf + systemd service
	mkdir -p /etc/ssl/my/ && cp /etc/faster/cmdb/data/certificates/edss/ca/a.services.pool.pem /etc/ssl/my/core_ca.pem

sysctl = conf
cp /media/sysdata/rev5/techpool/ontology/linux_sys/sysctl/main.conf /etc/sysctl.d/
cp /media/sysdata/rev5/techpool/ontology/linux_sys/sysctl/memory.conf /etc/sysctl.d/
cp /media/sysdata/rev5/techpool/ontology/linux_sys/sysctl/network.conf /etc/sysctl.d/
cp /media/sysdata/rev5/techpool/ontology/linux_sys/sysctl/server.conf /etc/sysctl.d/

atop =  profile.d + conf + systemd service

rsyslog = conf + systemd service

exim = conf
rm -f /etc/exim/exim.conf && ln -s /media/sysdata/rev5/techpool/ontology/mail/exim/simple/smarthost.conf /etc/exim/exim.conf

sshd = conf + systemd service + swf2
#sshd
rm -f /etc/systemd/system/rev5_sshd.service 			&& ln -s /media/sysdata/rev5/techpool/ontology/network/sshd/_systemd/rev5_sshd.service 	/etc/systemd/system/ 
rm -f /etc/sysconfig/SuSEfirewall2.d/services/rev5_sshd && ln -s /media/sysdata/rev5/techpool/ontology/network/sshd/_firewall/rev5_sshd /etc/sysconfig/SuSEfirewall2.d/services/
systemctl disable sshd && systemctl stop sshd && systemctl enable rev5_sshd && systemctl restart rev5_sshd
#

sudo =  conf
cp /media/sysdata/rev5/techpool/ontology/security/sudo/etc_sudoers /etc/sudoers
echo -e "localadmin     ALL=(ALL) ALL" > /etc/sudoers.d/local

bash = conf
rm -f  /etc/bash.bashrc.local && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/bash.bashrc.local /etc/bash.bashrc.local && chmod 755 /etc/bash.bashrc.local

profile.d = conf
rm -f  /etc/profile.d/administrators.sh && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/administrators.sh /etc/profile.d/ 
rm -f  /etc/profile.d/power.sh && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/power.sh /etc/profile.d/ 
rm -f  /etc/profile.d/support.sh && ln -s /media/sysdata/rev5/techpool/ontology/security/sssd/engine/profile.d/support.sh /etc/profile.d/ 
chmod 744 /etc/profile.d/*
 ###

 
 #####################
 
 rm -f /etc/nsswitch.conf &&  cp /media/sysdata/rev5/techpool/ontology/security/sssd/engine/nsswitch.conf /etc/ && chmod 744 /etc/nsswitch.conf
 
 xen autoservice
 rm -f  /etc/systemd/system/rev5_init_auto_xen.service && cp /media/sysdata/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/_systemd/rev5_init_auto_xen.service /etc/systemd/system/

