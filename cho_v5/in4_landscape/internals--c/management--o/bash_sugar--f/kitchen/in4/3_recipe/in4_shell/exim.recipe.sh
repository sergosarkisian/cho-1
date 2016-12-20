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

in4func_run "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "2_init/opensuse" "exim.package.zypper.sh"
in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/exim/engine/instance/smarthost.instance" "/etc/exim/exim.conf"
in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/exim" "/etc/exim/engine_path"

usermod -G sysdata mail
systemctl mask exim
