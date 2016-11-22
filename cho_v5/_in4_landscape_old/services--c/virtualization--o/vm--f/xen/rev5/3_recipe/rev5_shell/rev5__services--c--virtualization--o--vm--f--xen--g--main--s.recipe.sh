#!/bin/bash 

### 2.install
rev5_repo add services--c--virtualization--o--vm--f--xen--g--main--s
rev5_package add services--c--virtualization--o--vm--f--xen--g--main--s

### 3.recipe - additional before-execution common tasks


### 4.security - Firewall/PAM/sudo/AppArmor/others
rev5_firewall add services--c--virtualization--o--vm--f--xen--g--main--s

### 5.systemd - autostart, enable, additional systemd elements
rev5_systemd add services--c--virtualization--o--vm--f--xen--g--main--s
rev5_systemd enable services--c--virtualization--o--vm--f--xen--g--main--s


### 6.logitoring - custom rsyslog/zabbix templates
rev5_zabbix add services--c--virtualization--o--vm--f--xen--g--main--s
rev5_rsyslog add services--c--virtualization--o--vm--f--xen--g--main--s
kibana

### 7.datasafety - 
rev5_bareos add services--c--virtualization--o--vm--f--xen--g--main--s
