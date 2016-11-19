#!/bin/bash

if [[ ! -d /media/sysdata/in4/_context ]]; then  
	. /media/sysdata/in4/cho/in4_core/naming/naming.sh os

	echo "Enter SVN password: "
	read SVNPass

	## SVN
	svn status
	sed -i "s/# http-proxy-host.*/http-proxy-host = x/" /root/.subversion/servers
	sed -i "s/# http-proxy-port.*/http-proxy-port = 55555/" /root/.subversion/servers
	##
		
	svn co --username $Org --password $SVNPass https://svn.edss.ee/client/companies/$Org/sdata /media/sysdata/in4/_context/
        #ENABLE SFW2 - > we have a context
	systemctl enable in4__SuSEfirewall2_i@simple

fi 
