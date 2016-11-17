#!/bin/bash
echo -e "\n\n######## ######## START -  scenario - ${0##*/} ######## ########\n\n"

zypper  --gpg-auto-import-keys ref
zypper --non-interactive in --force aaa_base kmod binutils
zypper --non-interactive in --force net-tools iproute2 wicked-service dbus-1 strace
zypper --non-interactive in --force  aaa_base-extras man man-pages kbd timezone
zypper --non-interactive in --force  ca-certificates-mozilla
zypper --non-interactive in --force btrfsprogs e2fsprogs sysfsutils quota
zypper --non-interactive in --force yast2-security
zypper --non-interactive in --force mc vim lsof less strace pwgen sysstat tcpdump
zypper --non-interactive in --force bzip2 gzip p7zip unzip zip tar xz
#MISC
zypper --non-interactive in --force rsync subversion git telnet wget mailx
zypper --non-interactive in --force curl expect  deltarpm

#+ pam + policy*
zypper --non-interactive --gpg-auto-import-keys dup

echo -e "\n\n######## ######## STOP -  scenario - ${0##*/} ######## ########\n\n"
