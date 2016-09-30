#!/bin/bash
 
rm /etc/zypp/repos.d/*

#REPO





zypper ar -cf http://download.opensuse.org/distribution/13.2/repo/oss/  repo_oss
zypper ar -cf http://download.opensuse.org/distribution/openSUSE-current/repo/oss openSUSE-current_repo_oss
zypper ar -cf http://download.opensuse.org/update/openSUSE-current/ update_openSUSE-current

zypper ar -cf http://download.opensuse.org/repositories/devel:/languages:/erlang/openSUSE_13.2 languages:erlang
zypper ar -cf http://download.opensuse.org/repositories/devel:/languages:/perl/openSUSE_Tumbleweed languages:perl
zypper ar -cf http://download.opensuse.org/repositories/devel:/languages:/ruby:/extensions/openSUSE_13.2 ruby:extensions
zypper ar -cf http://download.opensuse.org/repositories/devel:/libraries:/c_c++/openSUSE_13.2 libraries:c_c++
zypper ar -cf http://download.opensuse.org/repositories/Linux-PAM/openSUSE_13.2 Linux-PAM
zypper ar -cf http://download.opensuse.org/repositories/network/openSUSE_13.2 network
zypper ar -cf http://download.opensuse.org/repositories/network:/ldap/openSUSE_13.2/ network:ldap
zypper ar -cf http://download.opensuse.org/repositories/network:/utilities/openSUSE_13.2 network:utilities
zypper ar -cf http://download.opensuse.org/repositories/openSUSE:/Tumbleweed/standard openSUSE:Tumbleweed_standard
zypper ar -cf http://download.opensuse.org/repositories/security/openSUSE_Tumbleweed security_Tumbleweed
zypper ar -cf http://download.opensuse.org/repositories/Virtualization/openSUSE_13.2 Virtualization
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/suse:/rev5/openSUSE_13.2 Conecenter_suse_rev5
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/kernels:/42.1/openSUSE_13.2 Conecenter_kernels_42.1

##SSTUDIO BUG






zypper ar -cf http://download.opensuse.org/repositories/server:/monitoring/openSUSE_Tumbleweed monitoring_Tumbleweed


##ZYPP CONF FIXES
sed -i "s/# solver.allowVendorChange.*/solver.allowVendorChange = false/" /etc/zypp/zypp.conf
sed -i "s/solver.allowVendorChange.*/solver.allowVendorChange = false/" /etc/zypp/zypp.conf

sed -i "s/# solver.cleandepsOnRemove.*/solver.cleandepsOnRemove = true/" /etc/zypp/zypp.conf
sed -i "s/solver.cleandepsOnRemove.*/solver.cleandepsOnRemove = true/" /etc/zypp/zypp.conf

sed -i "s/# installRecommends.*/installRecommends = no/" /etc/zypp/zypper.conf
sed -i "s/installRecommends.*/installRecommends = no/" /etc/zypp/zypper.conf

sed -i "s/# solver.onlyRequires.*/solver.onlyRequires = true/" /etc/zypp/zypp.conf
sed -i "s/solver.onlyRequires.*/solver.onlyRequires = true/" /etc/zypp/zypp.conf

sed -i "s/# solver.upgradeTestcasesToKeep.*/solver.upgradeTestcasesToKeep = 0/" /etc/zypp/zypp.conf
sed -i "s/solver.upgradeTestcasesToKeep.*/solver.upgradeTestcasesToKeep = 0/" /etc/zypp/zypp.conf

sed -i "s/# history.logfile =.*/history.logfile = \/media\/logs\/files\/zypp\/history/" /etc/zypp/zypp.conf
sed -i "s/history.logfile =.*/history.logfile = \/media\/logs\/files\/zypp\/history/" /etc/zypp/zypp.conf

sed -i "s/multiversion.kernels =.*/multiversion.kernels = latest,running/" /etc/zypp/zypp.conf


##SW INSTALL
zypper --gpg-auto-import-keys rm patterns-openSUSE-minimal_base-conflicts nscd *bacula*
zypper --gpg-auto-import-keys dup
zypper in -C --auto-agree-with-licenses --oldpackage --no-recommends 'aaa_base' 'aaa_base-extras' 'acl' 'autofs' 'apache2-utils' 'conntrack-tools' 'deltarpm' 'expect' 'glibc-i18ndata' 'git' 'grub2' 'hdparm' 'hwinfo' 'iputils' 'iwatch' 'kernel-default' 'kbd' 'less' 'libstorage5' 'libsepol1' 'libsemanage1' 'lifstat' 'libcgroup1' 'linux32' 'logrotate' 'lshell' 'mailx' 'man' 'man-pages' 'man-pages-posix' 'mc' 'module-init-tools' 'netcfg' 'net-tools' 'ntp' 'ocfs2-tools' 'ocfs2-tools-o2cb' 'openssh' 'openSUSE-release' 'openSUSE-build-key' 'p7zip' 'prctl' 'procps' 'pm-utils' 'pwgen' 'rpcbind' 'rpm' 'quota' 'shadow' 'socat' 'strace' 'subversion' 'sudo' 'SuSEfirewall2' 'sysconfig' 'sysfsutils' 'systemd-sysvinit' 'systemd-bash-completion' 'tree' 'vim' 'w3m' 'wget' 'xtables-addons' 'zip' 'zypper' 'yast2' 'yast2-apparmor' 'yast2-bootloader' 'yast2-firewall' 'yast2-hardware-detection' 'yast2-multipath' 'yast2-network' 'yast2-ldap-client' 'yast2-ntp-client' 'yast2-online-update' 'yast2-online-update-frontend' 'yast2-packager' 'yast2-pam' 'yast2-pkg-bindings' 'yast2-security' 'yast2-storage' 'yast2-sudo' 'yast2-sysconfig' 'yast2-transfer' 'yast2-tune' 'yast2-update' 'yast2-users' 'yast2-xml' 'bc' 'ethtool' 'fping' 'ipcalc' 'lsof' 'tcpdump' 'telnet' 'ipset' 'libnetfilter_conntrack3' 'atop' 'atop-daemon' 'sysstat' 'haveged' 'iftop' 'iotop' 'iptraf-ng' 'nethogs' 'iperf' 'blktrace' 'pam_ssh' 'pdsh' 'pam-config' 'pam-modules' 'krb5' 'krb5-client' 'pam_krb5' 'csync2' 'lsyncd' 'rsync' 'ncftp' 'sshfs' 'curlftpfs' 'rsyslog' 'rsyslog-module-relp' 'rsyslog-module-mmnormalize'  'rsyslog-module-elasticsearch' 'rsyslog-diag-tools' 'libestr0' 'libee0' 'drbd' 'drbd-kmp-xen' 'drbd-kmp-default' 'libcgroup-tools' 'aide' 'audit' 'apparmor-parser' 'apparmor-profiles' 'checkpolicy' 'fail2ban' 'john' 'policycoreutils' 'polkit-default-privs' 'polkit' 'knockd' 'libapparmor1' 'perl-apparmor' 'apparmor-utils' 'libselinux1' 'seccheck' 'selinux-tools' 'erlang' 'erlang-jiffy' 'ruby' 'ruby-common' 'sqlite3' 'sssd' 'sssd-tools' 'sssd-ldap' 'libsss_sudo' 'whois' 'deltarpm'  'joe' 'keyutils' 'tcsh' 'tnftp' 'dmidecode' 'wol'  'wireless-tools' 'yast2-auth-client' 'dhcpcd' 'dhcp-client' 'xen-kmp-default' 'exim' 'java-1_8_0-openjdk-headless' 'SuSEfirewall2-fail2ban' 'apparmor-utils' 'sssd-krb5' 'bash-completion' 'bareos-client'

#DOMU
zypper in -C --auto-agree-with-licenses --oldpackage --no-recommends 'kernel-pv' 'xen-tools-domU' 'drbd-kmp-pv'


## may be not ness - 'findutils-locate' 'genisoimage'

##NET-misc
# arp-scan arpwatch tcpflow 'ipt-netflow' 'ipt-netflow-kmp-default' 'ipt-netflow-kmp-xen'

#### BUGS
#No provider of 'lshell' 'yast2-ldap-client' found.