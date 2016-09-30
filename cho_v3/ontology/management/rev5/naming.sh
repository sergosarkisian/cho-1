#!/bin/bash

naming_view=$1
name=$2

if [[ $naming_view == "os" ]]; then

	if [[ $name =~ "pool" ]]; then
		hostname=$name
	else
		hostname=`hostname -f`
	fi
	
	dot_arr=(${hostname//./ })
	hyp_arr=(${hostname//-/ })

	Org=${dot_arr[4]}
	Net=${dot_arr[2]}
	View=${dot_arr[3]}
	SrvType=${dot_arr[1]}
	SrvName=${dot_arr[0]}
	MACIP=${hyp_arr[0]}
	MACIP_HA=${MACIP:: -2}	
	SrvContext=${hyp_arr[1]}		
	SrvRole=${hyp_arr[2]}
	DeplType=`echo ${hyp_arr[3]}|cut -d "." -f 1`
fi
