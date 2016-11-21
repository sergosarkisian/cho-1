#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"


### RSYSLOG ###
#ZYPPER
    zypper ar -p10 -cf http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/logitoring--c:/messagebus--o:/syslog--f/openSUSE_Leap_42.2/home:conecenter:rev5a1:ontology:logitoring--c:messagebus--o:syslog--f.repo

in4func_Zypper rsyslog rsyslog-module-relp rsyslog-module-mmnormalize rsyslog-module-gtls
#CONF
rm -rf /etc/rsyslog.d/ && ln -s /media/sysdata/in4/cho/cho_v4/logitoring--c/messagebus--o/syslog--f/rsyslog--g /etc/rsyslog.d
#SYSTEMD
rm -f /etc/systemd/system/in4__rsyslog.service 	&& cp  /media/sysdata/in4/cho/cho_v4/logitoring--c/messagebus--o/syslog--f/rsyslog--g/_systemd/in4__rsyslog.service /etc/systemd/system/
! systemctl stop rsyslog && systemctl disable rsyslog
echo "disabled" > /usr/lib/systemd/system/rsyslog.service
chmod 000 /usr/lib/systemd/system/rsyslog.service
systemctl enable  in4__rsyslog && ! systemctl restart in4__rsyslog
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
