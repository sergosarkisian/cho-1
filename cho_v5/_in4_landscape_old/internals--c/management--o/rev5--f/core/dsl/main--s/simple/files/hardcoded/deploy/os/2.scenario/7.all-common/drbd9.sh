#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"


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
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
