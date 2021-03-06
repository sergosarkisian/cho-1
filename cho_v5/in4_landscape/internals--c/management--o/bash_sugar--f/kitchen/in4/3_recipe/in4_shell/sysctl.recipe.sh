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

in4func_cp "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/sysctl/main.conf" "/etc/sysctl.d/"
in4func_cp "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/sysctl/memory.conf" "/etc/sysctl.d/"
in4func_cp "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/sysctl/network.conf" "/etc/sysctl.d/"
in4func_cp "internals--c--management--o--bash_sugar--f--kitchen--g--main--s" "simple/sysctl/server.conf" "/etc/sysctl.d/"
