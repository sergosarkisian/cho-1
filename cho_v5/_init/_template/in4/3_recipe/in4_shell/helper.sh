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

### 2.install
in4 recipe 2_init opensuse repo add class--c--order--o--family--f--genus--g--main--s
in4 recipe 2_init opensuse package add class--c--order--o--family--f--genus--g--main--s

### 3.recipe - additional before-execution common tasks


### 4.security - Firewall/PAM/sudo/AppArmor/others
in4 recipe 4_security swf2 add class--c--order--o--family--f--genus--g--main--s

### 5.systemd - autostart, enable, additional systemd elements
in4 recipe 5_service systemd add class--c--order--o--family--f--genus--g--main--s
in4 recipe 5_service systemd enable class--c--order--o--family--f--genus--g--main--s


### 6.logitoring - custom rsyslog/zabbix templates
in4 recipe 6_logitoring zabbix add class--c--order--o--family--f--genus--g--main--s
in4 recipe 6_logitoring rsyslog add class--c--order--o--family--f--genus--g--main--s
kibana

### 7.datasafety - 
in4 recipe 7_datasafety bareos add class--c--order--o--family--f--genus--g--main--s
