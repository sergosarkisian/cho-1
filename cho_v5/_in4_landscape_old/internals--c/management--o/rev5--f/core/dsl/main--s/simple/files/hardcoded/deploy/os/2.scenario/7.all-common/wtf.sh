#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### WTF ### - BUG
rm -f /etc/systemd/system/in4__wtf.service 	&& cp  /media/sysdata/in4/cho/in4_core/init/in4__wtf.service /etc/systemd/system/
systemctl enable  in4__wtf && ! systemctl restart in4__wtf
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
