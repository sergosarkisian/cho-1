########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash DSL, profiles
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
set -e

needed:
-- offline = 
    init - zypper 1st install, then cp & symlink
    exec -zypper --no-refresh --raw-cache-dir --pkg-cache-dir --cache-dir; zypper ar -cf  -???; git; docker image;
in4 default logging
profile.d for in4 , in4 = in4 sync

/media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/instance/..
in4 deploy - GIT_PATH
    1.os - SCENARIO,
        hw_chroot - 
        vm_xen -  LO_SYSTEM, LO_SYSDATA
        docker
    3.role
        c3app
    4.app
        c2db_import
        
--
in4 recipe
self  ??
    2_init opensuse repo add
    2_init opensuse package add
    4_security swf2 add 
    5_service systemd 
        mount add
        timer enable

    6_logitoring zabbix add
    6_logitoring rsyslog add
    7_datasafety bareos add


--
in4 sys ln 
in4 sys cp
in4 sys cp_gen

#### TO DO
1) in4 recipe  2_init 

2) in4 cp
in4LandscapeFQN=$1
ActionPath=$2
Destination=$3

= cp -r /media/sysdata/in4/cho/cho_v5/in4_landscape/ $Destination 
