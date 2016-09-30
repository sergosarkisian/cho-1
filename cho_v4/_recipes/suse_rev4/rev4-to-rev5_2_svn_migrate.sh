#!/bin/bash

if [[ ! -d /etc/rev5 ]]; then  

	mkdir /etc/rev5
	echo  "Enter organisation abbr.: "
	read Org
	echo  "Enter SVN password:"
	read SVNPass
	
	sed -i "s/# http-proxy-host.*/http-proxy-host = x/" /root/.subversion/servers
	sed -i "s/# http-proxy-port.*/http-proxy-port = 55555/" /root/.subversion/servers

	svn co --username $Org --password $SVNPass https://svn.edss.ee/techpool /media/sysdata/rev5/techpool
	svn co --username $Org --password $SVNPass https://svn.edss.ee/client/companies/$Org/sdata /media/sysdata/rev5/_context/
		
fi 
