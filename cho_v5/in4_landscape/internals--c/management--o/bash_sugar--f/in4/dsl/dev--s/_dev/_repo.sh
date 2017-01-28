#!/bin/bash



zypper ar -cf http://download.opensuse.org/repositories/security/openSUSE_Leap_42.1/ security::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/Java:Factory/openSUSE_42.1/ Java:Factory::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:languages:ruby/openSUSE_Leap_42.1/ languages:ruby::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/network:utilities/openSUSE_Leap_42.1/ network:utilities::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:libraries:c_c++/openSUSE_Leap_42.1/ devel:libraries:c_c++::leap42.1

#OBS BUG
zypper ar -cf http://download.opensuse.org/repositories/Virtualization/openSUSE_Leap_42.1/ Virtualization::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:languages:perl/openSUSE_Leap_42.1/ devel:languages:perl::leap42.1

##PROBLEMS - MAIL
zypper ar -cf http://download.opensuse.org/repositories/network:ha-clustering:Stable/openSUSE_Leap_42.1/ network:ha-clustering:Stable::leap42.1

#TEMP REPOS
zypper ar -cf http://download.opensuse.org/repositories/home:/conecenter:/suse:/rev5/openSUSE_13.2/home:conecenter:suse:rev5.repo
zypper ar -cf http://download.opensuse.org/repositories/Kernel:/stable/standard/Kernel:stable.repo

##DIVIDE PACKAGES
zypper ar -cf http://download.opensuse.org/repositories/devel:languages:erlang/openSUSE_Leap_42.1/ devel:languages:erlang::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:languages:ruby:extensions/openSUSE_Leap_42.1/ devel:languages:ruby:extensions::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/network:ldap/openSUSE_Leap_42.1/ network:ldap::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/Linux-PAM/openSUSE_Leap_42.1/ Linux-PAM::leap42.1


-----
#TW
zypper ar -cf http://download.opensuse.org/tumbleweed/repo/non-oss non-oss::tw
zypper ar -cf http://download.opensuse.org/tumbleweed/repo/oss oss:tw
zypper ar -cf http://download.opensuse.org/update/tumbleweed update::tw


##to conecenter
http://download.opensuse.org/repositories/devel:/tools:/scm:/svn/openSUSE_Leap_42.1/
http://download.opensuse.org/repositories/network:/samba:/STABLE/openSUSE_Leap_42.1/
http://download.opensuse.org/repositories/Archiving/openSUSE_Leap_42.1/
http://download.opensuse.org/repositories/network:/vpn/openSUSE_Tumbleweed/

##DESKTOP
zypper ar -cf http://download.opensuse.org/distribution/openSUSE-stable/repo/non-oss distribution_non-oss::stable
zypper ar -cf http://download.opensuse.org/distribution/leap/42.1/repo/non-oss distribution_non-oss::leap42.1

zypper ar -cf http://download.opensuse.org/update/leap/42.1/non-oss/ update_non-oss::leap42.1

zypper ar -cf http://download.opensuse.org/repositories/KDE:/Qt5/openSUSE_Leap_42.1 KDE:Qt5::leap42.1 
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Applications/openSUSE_Leap_42.1 KDE:Applications::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/KDE:/Extra/openSUSE_Leap_42.1 KDE:Extra::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/multimedia:/apps/openSUSE_Leap_42.1 multimedia:apps::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/multimedia:/libs/openSUSE_Leap_42.1 multimedia:libs::leap42.1

zypper ar -cf http://download.opensuse.org/repositories/LibreOffice:/5.0/openSUSE_42.1 LibreOffice:5.0::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/network:/chromium/openSUSE_Leap_42.1 network:chromium::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/mozilla/openSUSE_Leap_42.1 mozilla::leap42.1

zypper ar -cf http://download.opensuse.org/repositories/security:/chipcard/openSUSE_Leap_42.1 security:chipcard::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/Archiving/openSUSE_Leap_42.1 archiving::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:/tools:/scm:/svn/openSUSE_Leap_42.1 tools:scm:svn::leap42.1

zypper ar -cf http://mirror.karneval.cz/pub/linux/packman/suse/openSUSE_Leap_42.1 packman::leap42.1

##

##DB
http://download.opensuse.org/repositories/server:/database/openSUSE_Leap_42.1
##

zypper --gpg-auto-import-keys rm patterns-openSUSE-minimal_base-conflicts nscd
zypper --gpg-auto-import-keys dup

#####################################################################################3


 
#datasafety 
basic_sync - csync2 lsyncd rsync

#languages
#fcgi-cgi FastCGI

#linux_sys
basic_oper - ipcalc bc ngrep 
basic_mon -  iwatch sysstat blktrace iotop strace lsof prctl
basic_lang - perl expect java-1_8_0-openjdk-headless timezone-java 
haveged - haveged

#network
basic_mon - iptraf-ng tcpdump iftop iperf nethogs

#security
basic - seccheck audit 
pam - pam-google-authenticator  pam-modules pam_ssh

aide - aide
knockd - knockd
john - john


#####################################################################################3


##DESKTOP
zypper in chromium kdesvn kontact5 wireshark kate kdiff3 chromium-desktop-kde flash-player vlc vlc-codecs ffmpeg lame esteidcerts esteidfirefoxplugin esteidpkcs11loader estonianidcard libdigidoc libdigidocpp qdigidoc qesteidutil estonianidcard powertop powerstat remmina rdesktop remmina-plugin-rdp remmina-plugin-vnc libasound2-32bit libXv1-32bit libXss1-32bit libqt4-x11-32bit filezilla MozillaFirefox kwalletmanager5 libsvn_auth_kwallet-1-0  pgadmin3 kmail5 kcalc kopete okular ktorrent baloo5 kaddressbook5 gwenview5 spice-client
#bareos-tray-monitor-qt bareos-bat"
## skype teamviewer flash-player spicey
## akonadi pluguins
##
