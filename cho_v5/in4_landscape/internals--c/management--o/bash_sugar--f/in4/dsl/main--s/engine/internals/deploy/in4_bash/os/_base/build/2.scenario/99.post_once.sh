#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

	## SSH
	! rm  /etc/ssh/ssh_host_*
        sshd-gen-keys-start
	chmod 644 /etc/ssh/ssh_host_*.pub
	##
		
	## REGENERATE machine-id
	rm /etc/machine-id
	systemd-machine-id-setup
	## 
	
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
