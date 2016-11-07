	## SSH
	rm  /etc/ssh/ssh_host_*
	ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
	ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
	ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
	ssh-keygen -q -t rsa1 -b 2048 -f /etc/ssh/ssh_host_key -N ''
	chmod 644 /etc/ssh/ssh_host_*.pub
	systemctl restart in4__sshd.service
	##
		
	## REGENERATE machine-id
	rm /etc/machine-id
	systemd-machine-id-setup
	## 
