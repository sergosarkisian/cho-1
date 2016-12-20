# cho
Abbr. from "Chocolate". Also means "Cho eto?"

# RUN
sh ./in4.sh


## MISC:
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


