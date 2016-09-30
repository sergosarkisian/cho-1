#!/bin/bash 

### 2.install
rev5_repo add logitoring--c--messagebus--o--syslog--f--rsyslog--g--main--s
rev5_package add logitoring--c--messagebus--o--syslog--f--rsyslog--g--main--s

### 3.recipe - additional before-execution common tasks


### 4.security - Firewall/PAM/sudo/AppArmor/others
rev5_firewall add logitoring--c--messagebus--o--syslog--f--rsyslog--g--main--s

### 5.systemd - autostart, enable, additional systemd elements
rev5_systemd add logitoring--c--messagebus--o--syslog--f--rsyslog--g--main--s
rev5_systemd enable logitoring--c--messagebus--o--syslog--f--rsyslog--g--main--s


### 6.logitoring - custom rsyslog/zabbix templates
rev5_zabbix add logitoring--c--messagebus--o--syslog--f--rsyslog--g--main--s
rev5_rsyslog add logitoring--c--messagebus--o--syslog--f--rsyslog--g--main--s
kibana

### 7.datasafety - 
rev5_bareos add logitoring--c--messagebus--o--syslog--f--rsyslog--g--main--s
