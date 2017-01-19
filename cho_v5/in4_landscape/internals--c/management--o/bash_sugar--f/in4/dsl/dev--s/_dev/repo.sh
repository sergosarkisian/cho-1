#!/bin/bash

zypper ar -cf http://download.opensuse.org/repositories/security/openSUSE_Leap_42.1/ security::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/Java:Factory/openSUSE_42.1/ Java:Factory::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:languages:ruby:extensions/openSUSE_Leap_42.1/ devel:languages:ruby:extensions::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:languages:ruby/openSUSE_Leap_42.1/ languages:ruby::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:languages:erlang/openSUSE_Leap_42.1/ devel:languages:erlang::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/network:utilities/openSUSE_Leap_42.1/ network:utilities::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/network:ldap/openSUSE_Leap_42.1/ network:ldap::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:libraries:c_c++/openSUSE_Leap_42.1/ devel:libraries:c_c++::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/Linux-PAM/openSUSE_Leap_42.1/ Linux-PAM::leap42.1

#OBS BUG
zypper ar -cf http://download.opensuse.org/repositories/Virtualization/openSUSE_Leap_42.1/ Virtualization::leap42.1
zypper ar -cf http://download.opensuse.org/repositories/devel:languages:perl/openSUSE_Leap_42.1/ devel:languages:perl::leap42.1

##PROBLEMS - MAIL
zypper ar -cf http://download.opensuse.org/repositories/network:ha-clustering:Stable/openSUSE_Leap_42.1/ network:ha-clustering:Stable::leap42.1


##to conecenter
http://download.opensuse.org/repositories/devel:/tools:/scm:/svn/openSUSE_Leap_42.1/
http://download.opensuse.org/repositories/network:/samba:/STABLE/openSUSE_Leap_42.1/
http://download.opensuse.org/repositories/Archiving/openSUSE_Leap_42.1/
http://download.opensuse.org/repositories/network:/vpn/openSUSE_Tumbleweed/

##DB
http://download.opensuse.org/repositories/server:/database/openSUSE_Leap_42.1
##

zypper --gpg-auto-import-keys rm patterns-openSUSE-minimal_base-conflicts nscd *bacula*
zypper --gpg-auto-import-keys dup

##DESKTOP

#bareos-tray-monitor-qt bareos-bat"
## skype teamviewer flash-player spicey
## akonadi pluguins
##
