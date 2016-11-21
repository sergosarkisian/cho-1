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

in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "2_init/opensuse" "sshd.package.zypper.sh"

in4func_systemd "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "add" "service" "in4__sshd"
in4func_systemd "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "enable" "service" "in4__sshd"

in4func_swf2 "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "add" "in4__sshd"
systemctl disable sshd && systemctl mask sshd
