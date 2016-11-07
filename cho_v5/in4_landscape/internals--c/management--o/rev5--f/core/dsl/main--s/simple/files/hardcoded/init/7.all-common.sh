### BASH ###
#CONF
#rm -f  /etc/bash.bashrc.local && ln -s  /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/bash/conf/bash.bashrc.local /etc/bash.bashrc.local
echo "for f in /etc/profile.d/in4__*; do test -s $f;   source $f; done" >>  /etc/bash.bashrc
###

### SUDO ###
#CONF
rm -f /etc/sudoers && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/security:f/sudo--g/etc_sudoers /etc/sudoers
echo -e "localadmin     ALL=(ALL) ALL" > /etc/sudoers.d/localadmin
###

### NSS ###
#CONF
 rm -f /etc/nsswitch.conf &&  ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/network:f/nss:g/nsswitch.conf /etc/ && chmod 744 /etc/nsswitch.conf
###

### PROFILE.D ###
#CONF
rm -f  /etc/profile.d/administrators.sh && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/profile.d--f/administrators.sh /etc/profile.d/ 
rm -f  /etc/profile.d/power.sh && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/profile.d--f/power.sh /etc/profile.d/ 
rm -f  /etc/profile.d/support.sh && ln -s /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/profile.d--f/support.sh /etc/profile.d/ 
chmod 744 /etc/profile.d/*
###

### SYSCTL ###
#CONF
rm -f /etc/sysctl.d/main.conf  && cp /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/optimization:f/sysctl:g/main.conf /etc/sysctl.d/
rm -f /etc/sysctl.d/memory.conf && cp /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/optimization:f/sysctl:g/memory.conf /etc/sysctl.d/
rm -f /etc/sysctl.d/network.conf  && cp /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/optimization:f/sysctl:g/network.conf /etc/sysctl.d/
rm -f /etc/sysctl.d/server.conf && cp /media/sysdata/cho/cho_v4/internals:c/linux_sys:o/optimization:f/sysctl:g/server.conf /etc/sysctl.d/
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

### EXIM ###
#CONF
rm -f /etc/exim/exim.conf && ln -s /media/sysdata/cho/cho_v4/services--c/mail:o/mta:f/exim:g/in4_mta/engine/_simple/smarthost.conf /etc/exim/exim.conf
#PROFILE.D
#+
###

############ SERVICES ##############


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

#SYSTEMD

###

### SSSD ###
#CONF
sssd =  conf + systemd service
	mkdir -p /etc/ssl/my/ && cp /etc/faster/cmdb/data/certificates/edss/ca/a.services.pool.pem /etc/ssl/my/core_ca.pem
#PROFILE.D

#SYSTEMD

###


### ATOP ###
#CONF

#PROFILE.D

#SYSTEMD

###

### NAME ###
#CONF

#PROFILE.D

#SYSTEMD

#SWF2
###
