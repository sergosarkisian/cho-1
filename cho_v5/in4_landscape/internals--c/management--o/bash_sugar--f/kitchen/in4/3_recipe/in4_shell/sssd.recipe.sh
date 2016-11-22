#!/bin/bash 
########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
set -e

in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "2_init/opensuse" "sssd.package.zypper.sh"

pam-config --add --sss
in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/sssd/sssd_basic.conf" "/etc/sssd/sssd.conf"
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
# systemctl disable sssd && ! systemctl stop sssd && systemctl enable rev5_sssd && ! systemctl restart rev5_sssd
###

