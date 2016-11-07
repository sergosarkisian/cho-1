### BASH ###
#CONF
#rm -f  /etc/bash.bashrc.local && ln -s  /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/bash/conf/bash.bashrc.local /etc/bash.bashrc.local
echo "for f in /etc/profile.d/in4__*; do test -s $f;   source $f; done" >>  /etc/bash.bashrc
###

### ZYPPER ###
#CONF
rm -f  /etc/zypp/zypp.conf && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/conf/zypp.conf /etc/zypp/zypp.conf
rm -f /etc/zypp/zypper.conf && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/conf/zypper.conf /etc/zypp/zypper.conf
#PROFILE.D
rm -f /etc/profile.d/in4__zypper.bash && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/profile.d/in4__zypper.bash /etc/profile.d/in4__zypper.bash
###


### SYSTEMD ###
#CONF
rm -f /etc/systemd/system.conf && ln -s /media/sysdata/cho/cho_v5/in4_landscape/internals--c/management--o/infrastructure--f/systemd/dsl/main--s/simple/files/hardcoded/systemd_defaults.conf /etc/systemd/system.conf
rm -f /etc/systemd/user.conf 	 && ln -s /media/sysdata/cho/cho_v5/in4_landscape/internals--c/management--o/infrastructure--f/systemd/dsl/main--s/simple/files/hardcoded/systemd_defaults.conf /etc/systemd/user.conf
#PROFILE.D
rm -f /etc/profile.d/in4__systemd.bash 	 && ln -s /media/sysdata/cho/cho_v5/in4_landscape/internals--c/management--o/infrastructure--f/systemd/rev5/5_service/profile.d/rev5__internals--c--management--o--infrastructure--f--systemd--g--main--s.aliases.bash /etc/profile.d/in4__systemd.bash 	
###


### SFW2 ###
rm -f /etc/systemd/system/in4__SuSEfirewall2_i@.service 	&& cp  /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/network:f/sfw2:g/_systemd/in4__SuSEfirewall2_i@.service /etc/systemd/system/
rm -f /etc/systemd/system/in4__SuSEfirewall2_init_i@.service 	&& cp  /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/network:f/sfw2:g/_systemd/in4__SuSEfirewall2_init_i@.service /etc/systemd/system/
systemctl stop SuSEfirewall2 && systemctl disable SuSEfirewall2 && systemctl mask SuSEfirewall2
systemctl stop SuSEfirewall2_init && systemctl disable SuSEfirewall2_init && systemctl mask SuSEfirewall2_init
systemctl enable in4__SuSEfirewall2_i@simple
###


### SSHD ###
#SYSTEMD
rm -f /etc/systemd/system/in4__sshd.service 	&& cp  /media/sysdata/cho/cho_v4/services--c/server:o/ssh:f/sshd:g/_systemd/in4__sshd.service /etc/systemd/system/
systemctl stop sshd && systemctl disable sshd && systemctl mask sshd
systemctl enable in4__sshd
#SWF2
rm -f /etc/sysconfig/SuSEfirewall2.d/services/in4__sshd && ln -s  /media/sysdata/cho/cho_v4/services--c/server:o/ssh:f/sshd:g/_firewall/in4__sshd /etc/sysconfig/SuSEfirewall2.d/services/
###


### RSYSLOG ###
#CONF

#PROFILE.D

#SYSTEMD

#SWF2
###


### NAME ###
#CONF

#PROFILE.D

#SYSTEMD

#SWF2
###

### NAME ###
#CONF

#PROFILE.D

#SYSTEMD

#SWF2
###

#

sssd =  conf + systemd service
	mkdir -p /etc/ssl/my/ && cp /etc/faster/cmdb/data/certificates/edss/ca/a.services.pool.pem /etc/ssl/my/core_ca.pem

	
	
	
	
sysctl = conf
cp /media/sysdata/cho/cho_v3/ontology/linux_sys/sysctl/main.conf /etc/sysctl.d/
cp /media/sysdata/cho/cho_v3/ontology/linux_sys/sysctl/memory.conf /etc/sysctl.d/
cp /media/sysdata/cho/cho_v3/ontology/linux_sys/sysctl/network.conf /etc/sysctl.d/
cp /media/sysdata/cho/cho_v3/ontology/linux_sys/sysctl/server.conf /etc/sysctl.d/

atop =  profile.d + conf + systemd service


exim = conf
rm -f /etc/exim/exim.conf && ln -s /media/sysdata/cho/cho_v3/ontology/mail/exim/simple/smarthost.conf /etc/exim/exim.conf

sudo =  conf
cp /media/sysdata/cho/cho_v3/ontology/security/sudo/etc_sudoers /etc/sudoers
echo -e "localadmin     ALL=(ALL) ALL" > /etc/sudoers.d/local


profile.d = conf
rm -f  /etc/profile.d/administrators.sh && ln -s /media/sysdata/cho/cho_v3/ontology/security/sssd/engine/profile.d/administrators.sh /etc/profile.d/ 
rm -f  /etc/profile.d/power.sh && ln -s /media/sysdata/cho/cho_v3/ontology/security/sssd/engine/profile.d/power.sh /etc/profile.d/ 
rm -f  /etc/profile.d/support.sh && ln -s /media/sysdata/cho/cho_v3/ontology/security/sssd/engine/profile.d/support.sh /etc/profile.d/ 
chmod 744 /etc/profile.d/*
 ###

 
 #####################
 
 rm -f /etc/nsswitch.conf &&  cp /media/sysdata/cho/cho_v3/ontology/security/sssd/engine/nsswitch.conf /etc/ && chmod 744 /etc/nsswitch.conf
 

