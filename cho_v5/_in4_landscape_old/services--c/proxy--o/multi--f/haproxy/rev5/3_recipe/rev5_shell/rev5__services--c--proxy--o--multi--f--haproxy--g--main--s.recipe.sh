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
rev5_repo add services--c--proxy--o--multi--f--haproxy--g--main--s
rev5_package add services--c--proxy--o--multi--f--haproxy--g--main--s

### 3.recipe - additional before-execution common tasks


### 4.security - Firewall/PAM/sudo/AppArmor/others
rev5_firewall add services--c--proxy--o--multi--f--haproxy--g--main--s

### 5.systemd - autostart, enable, additional systemd elements
rev5_systemd add services--c--proxy--o--multi--f--haproxy--g--main--s
rev5_systemd enable services--c--proxy--o--multi--f--haproxy--g--main--s


### 6.logitoring - custom rsyslog/zabbix templates
rev5_zabbix add services--c--proxy--o--multi--f--haproxy--g--main--s
rev5_rsyslog add services--c--proxy--o--multi--f--haproxy--g--main--s
kibana

### 7.datasafety - 
rev5_bareos add services--c--proxy--o--multi--f--haproxy--g--main--s
