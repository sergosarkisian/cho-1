#!/bin/bash

### PATHS ###
mkdir -p /media/sysdata /media/storage 
chmod 755 /media/ /media/storage /media/sysdata

#### BUG -MOUNT DISK BEFORE OR MK ON OTHER DISK

mkdir -p /media/sysdata/app /media/sysdata/logs/syslog /media/sysdata/logs/syslog_bus/_client
mkdir -p /media/sysdata/logs/var_log && rm -rf /var/log && ln -s /media/sysdata/logs/var_log /var/log
mkdir -p /media/logs/atop /media/logs/files	
	
rm -f /var; mkdir -p /media/sysdata/linux_sys/var && cp -pR /var/* /media/sysdata/linux_sys/var ; rm -rf /var && ln -s /media/sysdata/linux_sys/var /var
rm -f /root;  mkdir -p /media/sysdata/linux_sys/root && cp -pR /root/* /media/sysdata/linux_sys/root ; rm -rf /root && ln -s /media/sysdata/linux_sys/root /root
 rm /home; mkdir -p /media/sysdata/linux_sys/home && rm -rf /home && ln -s /media/sysdata/linux_sys/home /home
 rm -r /var/tmp; ln -s /tmp /var/tmp
 rm -r /var/run; ln -s /run /var/run
###

### PASSWORD CHANGE & USRR/GROUP CREATION ###
echo 'root:$6$MT8dOpx6$5PfF1i.j/PuDwNyEeh3gohhi2eE9zlRDuHex4aL46DYCyxL/WjKD/CpdDtGA6.L2RweuPommpkGgP3Uo26kIU.' |chpasswd -e

groupadd -g 1000 localadmin
useradd -g localadmin -u 1000 -m localadmin
echo 'localadmin:$6$qJEkrJcMsaNw$gKdxOs6v0WbsElUDSBhbc0TjSSS1FVwxD4asZvH0tHjFwKi3kyRP1y51j1DyqzKkPMmy4PXM7GlCSqKOk35/N1' |chpasswd -e

groupadd -g 999 sysdata
useradd -g sysdata -u 999 -M -d /media/sysdata sysdata

groupadd -g 998 log
useradd -g log -u 998 -M -d /media/sysdata/logs/ log
###


### PERMISSIONS ###
    # Set root permissions	
    setfacl -R -m u:root:rwx /media/sysdata
    setfacl -R -m d:u:root:rwx /media/sysdata
    
    setfacl -R -m g:log:rx /media/sysdata/logs
    setfacl -R -m d:g:log:rx /media/sysdata/logs
    
    setfacl -R -m u:log:rwx /media/sysdata/logs
    setfacl -R -m d:u:log:rwx /media/sysdata/logs
            
    #Set system app permissions
    setfacl -R -m g:sysdata:rx /media/sysdata
    setfacl -R -m d:g:sysdata:rx /media/sysdata	
    
    #setfacl - others
    setfacl -R -m u::rx /media/sysdata
    setfacl -R -m g::rx /media/sysdata
    setfacl -R -m d:u::rx /media/sysdata
    setfacl -R -m d:g::rx /media/sysdata	
    setfacl -R -m o::rx /media/sysdata
    setfacl -R -m d:o::rx /media/sysdata	
###

### SYSDATA PERMS OVERRIDE ###
mkdir -p  /var/lib/empty && chmod 700 /var/lib/empty
usermod -G sysdata man
usermod -G sysdata mail
###
