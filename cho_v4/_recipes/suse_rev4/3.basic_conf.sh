#!/bin/bash
 


####SYSTEM USERS
groupadd -g 1900 admin
useradd -g admin -u 1900 -m admin

groupadd -g 1901 log
useradd -g log -u 1901 -M -d /media/logs log



	
	
##SSSD
cp /etc/faster/cmdb/techpool/sssd/nsswitch.conf /etc/
cp /etc/faster/cmdb/techpool/sssd/sssd_ssh.conf /etc/sssd/sssd.conf
chmod 744 /etc/nsswitch.conf
pam-config --add --sss
pam-config --add --mkhomedir

systemctl enable sssd; systemctl restart sssd	


##RSYSLOG
	if [[ ! -f /etc/rsyslog.conf_legacy ]]; then
		mv /etc/rsyslog.conf /etc/rsyslog.conf_legacy; 
		cp /etc/faster/cmdb/techpool/rsyslog/rsyslog.conf /etc/rsyslog.conf
	fi 

	if [[ ! -f /etc/rsyslog.d_legacy ]]; then 
		mv /etc/rsyslog.d /etc/rsyslog.d_legacy; 
		ln -s  /etc/faster/cmdb/techpool/rsyslog/rsyslog.d /etc/rsyslog.d
	fi

	systemctl restart rsyslog

	
##MONITORING
	mkdir /etc/zabbix
	cp /etc/faster/cmdb/modules/Monitoring/files/default/monitoring.service /usr/lib/systemd/system/monitoring.service
	systemctl enable monitoring && systemctl restart monitoring	
	

##SECURITY
cp /etc/faster/cmdb/techpool/bash/bash.bashrc.local /etc/bash.bashrc.local && chmod 755 /etc/bash.bashrc.local
cp /etc/faster/cmdb/techpool/profile.d/* /etc/profile.d/ && chmod 744 /etc/profile.d/*
        /sbin/rcapparmor start
        /sbin/yast security level server
        systemctl enable apparmor.service #### NOT WORKING !!!!!
        sed -i "s/FAIL_DELAY.*/FAIL_DELAY   10/" /etc/login.defs
        sed -i "s/UMASK.*/UMASK   077/" /etc/login.defs
        
        
        
#SUDOERS
sed -i "s/ALL\tALL=\(ALL\).*/#ALL    ALL=(ALL) ALL/" /etc/sudoers
if grep -Fxq "#ALL    ALL=(ALL) ALL" /etc/sudoers
then
	echo "Defaults targetpw is already disabled"
else
	sed -i "s/Defaults targetpw/#Defaults targetpw/" /etc/sudoers
fi
if grep -Fxq "local     ALL=(ALL) ALL" /etc/sudoers
	then
	echo "sudoers already have local user"
	else
	echo -e "local     ALL=(ALL) ALL" >> /etc/sudoers
fi

        
##NETWORK
sed -i "s/NETCONFIG_DNS_POLICY=.*/NETCONFIG_DNS_POLICY=\"auto\"/" /etc/sysconfig/network/config
sed -i "s/CHECK_DUPLICATE_IP=.*/CHECK_DUPLICATE_IP='yes'/"    /etc/sysconfig/network/config

##STORAGE
sed -i "s/DEVICE_NAMES=.*/DEVICE_NAMES=\"label\"/"    /etc/sysconfig/storage

#MISC
sed -i "s/DAILY_TIME=.*/DAILY_TIME=\"00:00\"/" /etc/sysconfig/cron
systemctl disable ntpd

##SSH
sed -i "s/X11Forwarding.*/X11Forwarding no/" /etc/ssh/sshd_config
sed -i "s/#AllowTcpForwarding.*/AllowTcpForwarding no/" /etc/ssh/sshd_config
sed -i "s/#Port 22/Port 1000/" /etc/ssh/sshd_config
sed -i "s/#PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i "s/PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config
sed -i "s/#Protocol 2/Protocol 2/" /etc/ssh/sshd_config
sed -i "s/#ClientAliveInterval.*/ClientAliveInterval 20/" /etc/ssh/sshd_config
sed -i "s/#MaxAuthTries.*/MaxAuthTries 3/" /etc/ssh/sshd_config
sed -i "s/#UseDNS.*/UseDNS no/" /etc/ssh/sshd_config
sed -i "s/#   Port.*/    Port 1000/" /etc/ssh/ssh_config


if grep -Fxq "ServerAliveInterval 20" /etc/ssh/ssh_config
	then
	rm  /etc/ssh/ssh_host_*
	ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
	ssh-keygen -q -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''
	ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
	ssh-keygen -q -t rsa1 -b 2048 -f /etc/ssh/ssh_host_key -N ''
	chmod 644 /etc/ssh/ssh_host_*.pub
	systemctl restart sshd.service
fi

if grep -Fxq "ServerAliveInterval 20" /etc/ssh/ssh_config
	then
	echo "ServerAliveInterval 20"
	else
	echo "ServerAliveInterval 20"  >> /etc/ssh/ssh_config
fi
##SYSCTL


#FIREWALL
sed -i "s/FW_SERVICES_EXT_TCP=.*/FW_SERVICES_EXT_TCP=\"\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_LOG_ACCEPT_CRIT=.*/FW_LOG_ACCEPT_CRIT=\"no\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_EXT=.*/FW_IGNORE_FW_BROADCAST_EXT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_INT=.*/FW_IGNORE_FW_BROADCAST_INT=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_IGNORE_FW_BROADCAST_DMZ=.*/FW_IGNORE_FW_BROADCAST_DMZ=\"yes\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_LOG_ACCEPT_CRIT=.*/FW_LOG_ACCEPT_CRIT=\"no\"/" /etc/sysconfig/SuSEfirewall2
sed -i "s/FW_PROTECT_FROM_INT=.*/FW_PROTECT_FROM_INT=\"yes\"/" /etc/sysconfig/SuSEfirewall2


#PROXY
	#svn proxy
	#sed -i "s/# http-proxy-host.*/http-proxy-host = x/" /root/.subversion/servers
	#sed -i "s/# http-proxy-port.*/http-proxy-port = 55555/" /root/.subversion/servers
	

	sed -i "s/HTTP_PROXY=.*/HTTP_PROXY=\"http:\/\/x:55555\"/" /etc/sysconfig/proxy
	sed -i "s/HTTPS_PROXY=.*/HTTPS_PROXY=\"http:\/\/x:55555\"/" /etc/sysconfig/proxy
	sed -i "s/FTP_PROXY=.*/FTP_PROXY=\"http:\/\/x:55555\"/" /etc/sysconfig/proxy
	sed -i "s/NO_PROXY=.*/NO_PROXY=\"localhost, 127.0.0.1, .ccm, .pool\"/" /etc/sysconfig/proxy	

	
rm /etc/machine-id
systemd-machine-id-setup