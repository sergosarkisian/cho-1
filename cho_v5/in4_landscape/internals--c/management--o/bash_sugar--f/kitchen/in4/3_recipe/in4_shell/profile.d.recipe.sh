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

in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/profile.d/support.sh" "/etc/profile.d/support.sh"
in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/profile.d/power.sh" "/etc/profile.d/power.sh"
in4func_ln "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/profile.d/administrators.sh" "/etc/profile.d/administrators.sh"

chmod 744 /etc/profile.d/*
