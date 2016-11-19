#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"


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
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
