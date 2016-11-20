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
profile.d for in4 , in4 = in4 sync

/media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/in4/dsl/main--s/engine/instance/..
in4 deploy -
    1.os - 
        hw_chroot
        vm_xen
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

