#!/bin/bash 

### 2.install
rev5_repo add internals--c--linux_sys--o--boot--f--grub2--g--main--s
rev5_package add internals--c--linux_sys--o--boot--f--grub2--g--main--s

### 3.recipe - additional before-execution common tasks


### 4.security - Firewall/PAM/sudo/AppArmor/others
rev5_firewall add internals--c--linux_sys--o--boot--f--grub2--g--main--s

### 5.systemd - autostart, enable, additional systemd elements
rev5_systemd add internals--c--linux_sys--o--boot--f--grub2--g--main--s
rev5_systemd enable internals--c--linux_sys--o--boot--f--grub2--g--main--s


### 6.logitoring - custom rsyslog/zabbix templates
rev5_zabbix add internals--c--linux_sys--o--boot--f--grub2--g--main--s
rev5_rsyslog add internals--c--linux_sys--o--boot--f--grub2--g--main--s
kibana

### 7.datasafety - 
rev5_bareos add internals--c--linux_sys--o--boot--f--grub2--g--main--s
