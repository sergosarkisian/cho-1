#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### PATHS ###
mkdir -p /media/sysdata /media/storage /media/sysdata/in4/
chmod 755 /media/ /media/storage /media/sysdata

#### BUG -MOUNT DISK BEFORE OR MK ON OTHER DISK

mkdir -p /media/sysdata/app /media/sysdata/logs/syslog /media/sysdata/logs/syslog_bus/_client
mkdir -p /media/sysdata/logs/var_log && rm -rf /var/log && ln -s /media/sysdata/logs/var_log /var/log
mkdir -p /media/sysdata/logs/app/atop /media/sysdata/logs/files	
	
! rm -f /var; mkdir -p /media/sysdata/linux_sys/var && cp -pR /var/* /media/sysdata/linux_sys/var ; rm -rf /var && ln -s /media/sysdata/linux_sys/var /var
! rm -f /root;  mkdir -p /media/sysdata/linux_sys/root && cp -pR /root/* /media/sysdata/linux_sys/root ; rm -rf /root && ln -s /media/sysdata/linux_sys/root /root
! rm -f /home; mkdir -p /media/sysdata/linux_sys/home && rm -rf /home && ln -s /media/sysdata/linux_sys/home /home
! rm -r /var/tmp; ln -s /tmp /var/tmp
! rm -r /var/run; ln -s /run /var/run
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
    chmod 755 /media/sysdata/linux_sys/ /media/sysdata/linux_sys/var
    setfacl -R -m u:sysdata:rwx /media/sysdata/app
    setfacl -R -m d:u:sysdata:rwx /media/sysdata/app
    setfacl -R -m g:sysdata:rx /media/sysdata/app
    setfacl -R -m d:g:sysdata:rx /media/sysdata/app
    setfacl -R -m u::rwx /media/sysdata/app	   
    setfacl -R -m d:u::rwx /media/sysdata/app	        
    setfacl -R -m g::rx /media/sysdata/app	   
    setfacl -R -m d:g::rx /media/sysdata/app	        

     
    setfacl -R -m u:sysdata:rwx /media/sysdata/in4
    setfacl -R -m d:u:sysdata:rwx /media/sysdata/in4
    setfacl -R -m g:sysdata:rx /media/sysdata/in4
    setfacl -R -m d:g:sysdata:rx /media/sysdata/in4
    setfacl -R -m u::rwx /media/sysdata/in4	   
    setfacl -R -m d:u::rwx /media/sysdata/in4	        
    setfacl -R -m g::rx /media/sysdata/in4	   
    setfacl -R -m d:g::rx /media/sysdata/in4	             
    
    setfacl -R -m o::rx /media/sysdata/in4
    setfacl -R -m d:o::rx /media/sysdata/in4	        
    

    setfacl -R -m u:log:rwx /media/sysdata/logs
    setfacl -R -m d:u:log:rwx /media/sysdata/logs
    setfacl -R -m g:log:rx /media/sysdata/logs
    setfacl -R -m d:g:log:rx /media/sysdata/logs
    setfacl -R -m u::rwx /media/sysdata/logs	   
    setfacl -R -m d:u::rwx /media/sysdata/logs	        
    setfacl -R -m g::rx /media/sysdata/logs	   
    setfacl -R -m d:g::rx /media/sysdata/logs	     
    

###

### SYSDATA PERMS OVERRIDE ###
mkdir -p  /var/lib/empty && chmod 700 /var/lib/empty
usermod -G sysdata man
usermod -G sysdata mail
###


### SYNC SERVICE ###
rm -f /etc/systemd/system/in4__sync.service 	&& cp  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/sync_service/in4__sync.service /etc/systemd/system/
rm -f /etc/systemd/system/in4__sync.timer 	&& cp  /media/sysdata/in4/cho/cho_v5/in4_landscape/internals--c/management--o/rev5--f/core/dsl/main--s/simple/files/hardcoded/sync_service/in4__sync.timer /etc/systemd/system/
systemctl enable  in4__sync.timer && systemctl restart in4__sync.timer
###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
