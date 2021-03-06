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

in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "2_init/opensuse" "rsyslog.package.zypper.sh"

systemctl disable syslog
echo "disabled" > /usr/lib/systemd/system/rsyslog.service
chmod 000 /usr/lib/systemd/system/rsyslog.service

in4func_systemd "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "add" "service" "in4__rsyslog"
in4func_systemd "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "enable" "service" "in4__rsyslog"

in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/rsyslog" "/etc/rsyslog.d"

