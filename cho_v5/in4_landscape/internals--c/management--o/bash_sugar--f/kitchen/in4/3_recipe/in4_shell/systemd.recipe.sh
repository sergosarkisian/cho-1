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

in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "2_init/opensuse" "systemd.package.zypper.sh"

in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/systemd/systemd_defaults.conf" "/etc/systemd/system.conf"
in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/systemd/systemd_defaults.conf" "/etc/systemd/user.conf"
in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/systemd/journald_defaults.conf" "/etc/systemd/journald.conf"

in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/systemd/in4__systemd.bash" "/etc/profile.d/in4__systemd.bash "

#in4func_bash-profile
