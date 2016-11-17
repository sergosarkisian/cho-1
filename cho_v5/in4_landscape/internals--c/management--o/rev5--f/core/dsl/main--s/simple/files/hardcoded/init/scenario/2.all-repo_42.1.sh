#!/bin/bash
echo -e "\n\n######## ######## START -  scenario - ${0##*/} ######## ########\n\n"

### ZYPPER ###
rm /etc/zypp/repos.d/*

### 42.1 ###
zypper ar -cf http://download.opensuse.org/repositories/openSUSE:/Leap:/42.1/standard standard::leap42.1
zypper ar -cf http://download.opensuse.org/update/leap/42.1/oss update_oss::leap42.1
zypper ar -cf http://download.opensuse.org/update/openSUSE-stable update_oss::stable
##SOME STANDARD
zypper ar -cf http://download.opensuse.org/repositories/network/openSUSE_Leap_42.1/network.repo
zypper ar -cf http://download.opensuse.org/repositories/shells/openSUSE_Leap_42.1/shells.repo

##CONE CENTER - priority 10
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/services--c:/virtualization--o:/vm--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:services--c:virtualization--o:vm--f.repo
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/logitoring--c:/messagebus--o:/syslog--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:logitoring--c:messagebus--o:syslog--f.repo
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/internals--c:/management--o:/infrastructure--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:internals--c:management--o:infrastructure--f.repo
zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/internals--c:/linux_sys--o:/kernel_leap42_2--f/openSUSE_Leap_42.1/home:conecenter:rev5a1:ontology:internals--c:linux_sys--o:kernel_leap42_2--f.repo
###

echo -e "\n\n######## ######## STOP -  scenario - ${0##*/} ######## ########\n\n"
