echo -e "\n\n######## ######## START -  scenario - ${0##*/} ######## ########\n\n"

	## SSH
	rm  /etc/ssh/ssh_host_*
        sshd-gen-keys-start
	chmod 644 /etc/ssh/ssh_host_*.pub
	##
		
	## REGENERATE machine-id
	rm /etc/machine-id
	systemd-machine-id-setup
	## 
echo -e "\n\n######## ######## STOP -  scenario - ${0##*/} ######## ########\n\n"
