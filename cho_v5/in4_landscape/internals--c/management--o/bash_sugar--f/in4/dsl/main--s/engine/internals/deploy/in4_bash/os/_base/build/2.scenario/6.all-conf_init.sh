#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### BOOT OPTIONS ###
sed -i "s/LOADER_TYPE=.*/LOADER_TYPE=\"none\"/" /etc/sysconfig/bootloader
###

### MISC ###
sed -i "s/FAIL_DELAY.*/FAIL_DELAY   10/" /etc/login.defs
sed -i "s/UMASK.*/UMASK   077/" /etc/login.defs
sed -i "s/NETCONFIG_DNS_POLICY=.*/NETCONFIG_DNS_POLICY=\"auto\"/" /etc/sysconfig/network/config
sed -i "s/CHECK_DUPLICATE_IP=.*/CHECK_DUPLICATE_IP='yes'/"    /etc/sysconfig/network/config
#sed -i "s/DEVICE_NAMES=.*/DEVICE_NAMES=\"label\"/"    /etc/sysconfig/storage
sed -i "s/DAILY_TIME=.*/DAILY_TIME=\"00:00\"/" /etc/sysconfig/cron
sed -i  "s/set\ term\ xy/#/" /etc/inputrc
###

### PROXY ###
sed -i "s/HTTP_PROXY=.*/HTTP_PROXY=\"http:\/\/x:55555\"/" /etc/sysconfig/proxy
sed -i "s/HTTPS_PROXY=.*/HTTPS_PROXY=\"http:\/\/x:55555\"/" /etc/sysconfig/proxy
sed -i "s/FTP_PROXY=.*/FTP_PROXY=\"http:\/\/x:55555\"/" /etc/sysconfig/proxy
sed -i "s/NO_PROXY=.*/NO_PROXY=\"localhost, 127.0.0.1, .ccm, .pool\"/" /etc/sysconfig/proxy	
###

### PAM SETTINGS ###
pam-config --add --mkhomedir
pam-config --add --systemd
###		

### SERVICES FIRST ENABLE/START ###
/sbin/yast security level server
#/sbin/rcapparmor start
! systemctl disable ntpd
! systemctl mask ntpd
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
