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

in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "2_init/opensuse" "swf2.package.zypper.sh"

in4func_systemd "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "add" "service" "in4__SuSEfirewall2_i"
in4func_systemd "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "add" "service" "in4__SuSEfirewall2_init_i"

 systemctl disable SuSEfirewall2 && systemctl mask SuSEfirewall2
 systemctl disable SuSEfirewall2_init && systemctl mask SuSEfirewall2_init
 
### INIT ###
sed -i "s/FW_LOG_ACCEPT_CRIT=.*/FW_LOG_ACCEPT_CRIT=\"no\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_EXT=.*/FW_IGNORE_FW_BROADCAST_EXT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_INT=.*/FW_IGNORE_FW_BROADCAST_INT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_DMZ=.*/FW_IGNORE_FW_BROADCAST_DMZ=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_LOG_ACCEPT_CRIT=.*/FW_LOG_ACCEPT_CRIT=\"no\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_PROTECT_FROM_INT=.*/FW_PROTECT_FROM_INT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
###
