#!/bin/bash

git -C /media/sysdata/in4/cho pull

SVN_UP_CONTEXT=`svn st -u /media/sysdata/in4/_context/|grep "*" -c`
if [[ $SVN_UP_CONTEXT != "0" ]]; then
	svn up /media/sysdata/in4/_context/
fi
