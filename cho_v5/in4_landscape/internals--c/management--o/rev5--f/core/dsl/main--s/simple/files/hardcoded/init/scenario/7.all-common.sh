#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### BASH ###
#ZYPPER
zypper --gpg-auto-import-keys --non-interactive in --force bash-completion
#CONF
#rm -f  /etc/bash.bashrc.local && ln -s  /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/bash/conf/bash.bashrc.local /etc/bash.bashrc.local
echo "for f in /etc/profile.d/in4__*; do test -s \$f;   source \$f; done" >>  /etc/bash.bashrc
###

### SUDO ###
#ZYPPER
zypper --gpg-auto-import-keys --non-interactive in --force sudo
#CONF
rm -f /etc/sudoers && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/security:f/sudo--g/etc_sudoers /etc/sudoers
echo -e "localadmin     ALL=(ALL) ALL" > /etc/sudoers.d/localadmin
###

### NSS ###
#CONF
 rm -f /etc/nsswitch.conf &&  ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/network:f/nss:g/nsswitch.conf /etc/ && chmod 744 /etc/nsswitch.conf
###

### PROFILE.D ###
#CONF
rm -f  /etc/profile.d/administrators.sh && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/profile.d--f/administrators.sh /etc/profile.d/ 
rm -f  /etc/profile.d/power.sh && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/profile.d--f/power.sh /etc/profile.d/ 
rm -f  /etc/profile.d/support.sh && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/profile.d--f/support.sh /etc/profile.d/ 
chmod 744 /etc/profile.d/*
###

### SYSCTL ###
#CONF
rm -f /etc/sysctl.d/main.conf  && cp /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/optimization:f/sysctl:g/main.conf /etc/sysctl.d/
rm -f /etc/sysctl.d/memory.conf && cp /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/optimization:f/sysctl:g/memory.conf /etc/sysctl.d/
rm -f /etc/sysctl.d/network.conf  && cp /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/optimization:f/sysctl:g/network.conf /etc/sysctl.d/
rm -f /etc/sysctl.d/server.conf && cp /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/optimization:f/sysctl:g/server.conf /etc/sysctl.d/
###

### ZYPPER ###
#CONF
rm -f  /etc/zypp/zypp.conf && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/conf/zypp.conf /etc/zypp/zypp.conf
rm -f /etc/zypp/zypper.conf && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/conf/zypper.conf /etc/zypp/zypper.conf
#PROFILE.D
rm -f /etc/profile.d/in4__zypper.bash && ln -s /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/pkg_management--f/zypper/profile.d/in4__zypper.bash /etc/profile.d/in4__zypper.bash
###

### SNAPPER ###
#ZYPPER
zypper --gpg-auto-import-keys --non-interactive in --force snapper snapper-zypp-plugin yast2-snapper grub2-snapper-plugin
#CONF
#??
###

### SYSTEMD ###
#ZYPPER
zypper --gpg-auto-import-keys --non-interactive in --force systemd-bash-completion 
#CONF
rm -f /etc/systemd/system.conf && ln -s /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/infrastructure--f/systemd/dsl/main--s/simple/files/hardcoded/systemd_defaults.conf /etc/systemd/system.conf
rm -f /etc/systemd/user.conf 	 && ln -s /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/infrastructure--f/systemd/dsl/main--s/simple/files/hardcoded/systemd_defaults.conf /etc/systemd/user.conf
#PROFILE.D
rm -f /etc/profile.d/in4__systemd.bash 	 && ln -s /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/infrastructure--f/systemd/rev5/5_service/profile.d/rev5__internals--c--management--o--infrastructure--f--systemd--g--main--s.aliases.bash /etc/profile.d/in4__systemd.bash 	
###

### EXIM ###
#ZYPPER
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/services--c:/mail--o:/mta--f/openSUSE_Leap_42.2/home:conecenter:rev5a1:ontology:services--c:mail--o:mta--f.repo
zypper --gpg-auto-import-keys --non-interactive in --force exim
#CONF
rm -f /etc/exim/exim.conf && ln -s /media/sysdata/in4/cho/cho_v4/services--c/mail:o/mta:f/exim:g/in4_mta/engine/_simple/smarthost.conf /etc/exim/exim.conf ## BUG
usermod -G sysdata mail
#SYSTEMD
systemctl mask exim
#PROFILE.D
#+
###

############ SERVICES ##############


### SFW2 ###
#ZYPPER
zypper --gpg-auto-import-keys --non-interactive in --force SuSEfirewall2
#INIT
sed -i "s/FW_LOG_ACCEPT_CRIT=.*/FW_LOG_ACCEPT_CRIT=\"no\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_EXT=.*/FW_IGNORE_FW_BROADCAST_EXT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_INT=.*/FW_IGNORE_FW_BROADCAST_INT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_DMZ=.*/FW_IGNORE_FW_BROADCAST_DMZ=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_LOG_ACCEPT_CRIT=.*/FW_LOG_ACCEPT_CRIT=\"no\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_PROTECT_FROM_INT=.*/FW_PROTECT_FROM_INT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
#SYSTEMD
rm -f /etc/systemd/system/in4__SuSEfirewall2_i@.service 	&& cp  /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/network:f/sfw2:g/_systemd/in4__SuSEfirewall2_i@.service /etc/systemd/system/
rm -f /etc/systemd/system/in4__SuSEfirewall2_init_i@.service 	&& cp  /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/network:f/sfw2:g/_systemd/in4__SuSEfirewall2_init_i@.service /etc/systemd/system/
systemctl stop SuSEfirewall2 && systemctl disable SuSEfirewall2 && systemctl mask SuSEfirewall2
systemctl stop SuSEfirewall2_init && systemctl disable SuSEfirewall2_init && systemctl mask SuSEfirewall2_init
###

### SSHD ###
#ZYPPER
zypper --gpg-auto-import-keys --non-interactive in --force openssh
#SYSTEMD
rm -f /etc/systemd/system/in4__sshd.service 	&& cp  /media/sysdata/in4/cho/cho_v4/services--c/server:o/ssh:f/sshd:g/_systemd/in4__sshd.service /etc/systemd/system/
systemctl stop sshd && systemctl disable sshd && systemctl mask sshd
systemctl enable in4__sshd
#SWF2
rm -f /etc/sysconfig/SuSEfirewall2.d/services/in4__sshd && ln -s  /media/sysdata/in4/cho/cho_v4/services--c/server:o/ssh:f/sshd:g/_firewall/in4__sshd /etc/sysconfig/SuSEfirewall2.d/services/
###

### RSYSLOG ###
#ZYPPER
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/logitoring--c:/messagebus--o:/syslog--f/openSUSE_Leap_42.2/home:conecenter:rev5a1:ontology:logitoring--c:messagebus--o:syslog--f.repo
zypper --gpg-auto-import-keys --non-interactive in --force rsyslog rsyslog-module-relp rsyslog-module-mmnormalize rsyslog-module-gtls
#CONF
rm -rf /etc/rsyslog.d/ && ln -s /media/sysdata/in4/cho/cho_v4/logitoring--c/messagebus--o/syslog--f/rsyslog--g /etc/rsyslog.d
#SYSTEMD
rm -f /etc/systemd/system/in4__rsyslog.service 	&& cp  /media/sysdata/in4/cho/cho_v4/logitoring--c/messagebus--o/syslog--f/rsyslog--g/_systemd/in4__rsyslog.service /etc/systemd/system/
systemctl stop rsyslog && systemctl disable rsyslog
echo "disabled" > /usr/lib/systemd/system/rsyslog.service
chmod 000 /usr/lib/systemd/system/rsyslog.service
systemctl enable  in4__rsyslog && systemctl restart in4__rsyslog
###


############# ???? ############3

### SSSD ###
#ZYPPER
## add build for https://build.opensuse.org/package/show/openSUSE:Factory/sssd
zypper --gpg-auto-import-keys --non-interactive in --force sssd sssd-tools 
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
# systemctl disable sssd && systemctl stop sssd && systemctl enable rev5_sssd && systemctl restart rev5_sssd
###


### ATOP ###
#ZYPPER

#CONF

#PROFILE.D

#SYSTEMD

###


### DRBD9 ###
#ZYPPER
zypper ar -p 10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/data_safety--c:/replication--o:/block--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:data_safety--c:replication--o:block--f.repo
#zypper --gpg-auto-import-keys --non-interactive in --force drbd9-kmp-default drbd9 drbd-utils ## BUG
#CONF
rm -f /etc/drbd.conf && ln -s /media/sysdata/in4/cho/cho_v5/in4_landscape/data_safety--c/replication--o/block--f/drbd9/dsl/main--s/simple/files/hardcoded/drbd.conf /etc/
#PROFILE.D
#++
#SYSTEMD
#++
###


##########################

####
### WTF ### - BUG
rm -f /etc/systemd/system/in4__wtf.service 	&& cp  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/in4__wtf.service /etc/systemd/system/
systemctl enable  in4__wtf && systemctl restart in4__wtf
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
