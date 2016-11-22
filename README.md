# cho
Abbr. from "Chocolate". Also means "Cho eto?"

## Git pull:

+ export GIT_PATH="..somepath"; mkdir $GIT_PATH
+ wget -O $GIT_PATH/git_init.sh  https://raw.githubusercontent.com/eistomin/cho/master/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/init/steps_init/git_init.sh
+ sh $GIT_PATH/git_init.sh

## Run:
+ cd to build dir
in4 deploy
    1.os
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
profile.d for in4 , in4 = in4 sync

