#!/bin/bash

### ZYPPER ###
rm /etc/zypp/repos.d/*
zypper ar -cf http://download.opensuse.org/repositories/openSUSE:/Leap:/42.1/standard standard::leap42.1
zypper ar -cf http://download.opensuse.org/update/leap/42.1/oss update_oss::leap42.1
zypper ar -cf http://download.opensuse.org/update/openSUSE-stable update_oss::stable
##SOME STANDARD
zypper ar -cf http://download.opensuse.org/repositories/network/openSUSE_Leap_42.1/network.repo
zypper ar -cf http://download.opensuse.org/repositories/shells/openSUSE_Leap_42.1/shells.repo

##CONE CENTER
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/services--c:/virtualization--o:/vm--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:services--c:virtualization--o:vm--f.repo
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/logitoring--c:/messagebus--o:/syslog--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:logitoring--c:messagebus--o:syslog--f.repo
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/internals--c:/management--o:/infrastructure--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:internals--c:management--o:infrastructure--f.repo
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/internals--c:/linux_sys--o:/kernel_leap42_2--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:internals--c:linux_sys--o:kernel_leap42_2--f.repo


zypper  --gpg-auto-import-keys ref
zypper --non-interactive in --force kernel-default grub2 aaa_base kmod binutils
#Xen
zypper --non-interactive in --force spice-vdagent xen-tools-domU xen-libs
zypper --non-interactive in --force hostname iproute2 wicked-service dbus-1 strace
zypper --non-interactive in --force  aaa_base-extras man man-pages
zypper --non-interactive in --force  ca-certificates-mozilla
zypper --non-interactive in --force btrfsprogs e2fsprogs sysfsutils quota
zypper --non-interactive in --force yast2-security
zypper --non-interactive in --force mc vim lsof less strace pwgen 
zypper --non-interactive in --force bzip2 gzip p7zip unzip zip tar 
#MISC
zypper --non-interactive in --force rsync subversion git sysstat tcpdump telnet wget mailx
zypper --non-interactive in --force curl expect  deltarpm
#atop drbd-kmp-default 
#+ pam + policy*
zypper --non-interactive --gpg-auto-import-keys dup
