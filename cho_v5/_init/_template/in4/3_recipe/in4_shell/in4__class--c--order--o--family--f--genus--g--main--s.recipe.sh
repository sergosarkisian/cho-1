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
in4_repo add class--c--order--o--family--f--genus--g--main--s
in4_package add class--c--order--o--family--f--genus--g--main--s

### 3.recipe - additional before-execution common tasks


### 4.security - Firewall/PAM/sudo/AppArmor/others
in4_firewall add class--c--order--o--family--f--genus--g--main--s

### 5.systemd - autostart, enable, additional systemd elements
in4_systemd add class--c--order--o--family--f--genus--g--main--s
in4_systemd enable class--c--order--o--family--f--genus--g--main--s


### 6.logitoring - custom rsyslog/zabbix templates
in4_zabbix add class--c--order--o--family--f--genus--g--main--s
in4_rsyslog add class--c--order--o--family--f--genus--g--main--s
kibana

### 7.datasafety - 
in4_bareos add class--c--order--o--family--f--genus--g--main--s
