#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"


 mkdir -p /media/sysdata/app /media/sysdata/logs/syslog /media/sysdata/logs/syslog_bus/_client
 mkdir -p /media/sysdata/logs/var_log && ! rm -rf /var/log && ln -s /media/sysdata/logs/var_log /var/log
 mkdir -p /media/sysdata/logs/app/atop /media/sysdata/logs/files	
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
    #chmod 755 /media/sysdata/linux_sys/ /media/sysdata/linux_sys/var
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
in4func_systemd "internals--c--management--o--bash_sugar--f--in4--g--main--s" "add" "service" "in4__sync"
in4func_systemd "internals--c--management--o--bash_sugar--f--in4--g--main--s" "add" "timer" "in4__sync"
in4func_systemd "internals--c--management--o--bash_sugar--f--in4--g--main--s" "enable" "timer" "in4__sync"

###

echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
