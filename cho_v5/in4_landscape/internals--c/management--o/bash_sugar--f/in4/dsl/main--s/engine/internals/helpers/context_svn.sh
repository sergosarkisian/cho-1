#!/bin/bash
########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash DSL, profiles
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
set -e

if [[ ! -d /media/sysdata/in4/_context ]]; then  
	. /media/sysdata/in4/cho/in4_core/internals/naming/naming.sh os

	echo "Enter SVN password: "
	read SVNPass

	## SVN
	Proxy=`env|grep -i http_proxy`
	if [[ -n $Proxy ]]; then 
            ! svn status
            sed -i "s/# http-proxy-host.*/http-proxy-host = x/" /root/.subversion/servers
            sed -i "s/# http-proxy-port.*/http-proxy-port = 55555/" /root/.subversion/servers
        else
            echo "no proxy"
        fi	
	##
		
	svn co --username $Org --password $SVNPass https://svn.edss.ee/client/companies/$Org/sdata /media/sysdata/in4/_context/
        #ENABLE SFW2 - > we have a context
	systemctl enable in4__SuSEfirewall2_i@simple

fi 
