#!/bin/bash

naming_view=$1
name=$2

## 1 - HW UNIT
if [[ $naming_view == "unit" ]]; then
        Hostname=$name
		
	dot_arr=(${Hostname//./ })
	hyp_arr=(${Hostname//-/ })
	
	Location=${dot_arr[2]}
	LocAddr=`echo $Location|cut -d "-" -f 1`
	LocCity=`echo $Location|cut -d "-" -f 2`
	LocCountry=`echo $Location|cut -d "-" -f 3`
	
	Org=${dot_arr[4]}
	View=${dot_arr[3]}
	UnitType=${dot_arr[1]}
	OurVendorRev=`echo $UnitType|cut -d "-" -f 1`
	Vendor=`echo $UnitType|cut -d "-" -f 2`
	Type=`echo $UnitType|cut -d "-" -f 3`
	
	UnitName=${dot_arr[0]}
	MACIP=${hyp_arr[0]}
	MACIP_HA=${MACIP:: -2}	
	SrvContext=${hyp_arr[1]}		
	SrvRole=${hyp_arr[2]}
	DeplType=`echo ${hyp_arr[3]}|cut -d "." -f 1`
fi

## 2 - OS
if [[ $naming_view == "os" ]]; then

	if [[ $name =~ "pool" ]]; then
		Hostname=$name
	else
		Hostname=`hostname -f`
	fi

	dot_arr=(${Hostname//./ })
	hyp_arr=(${Hostname//-/ })
	
    if [[ `echo $Hostname|cut -d"." -f 6` == "pool" ]]; then

## OLD naming 
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
	In4NamingOsSrvType=$SrvType
        FullSrvName="$SrvName.$In4NamingOsSrvType.$Net.$View.$Org.pool"	
    else
    ## NEW Naming
        Org=${dot_arr[5]}
	View=${dot_arr[4]}
        Net=${dot_arr[3]}
	OsSrvType=${dot_arr[2]}
	OsBuild=${dot_arr[1]}
	OsBuildDate=`echo $OsBuild|cut -d "-" -f 1`
	OsBuildDateYear=`echo $OsBuildDate|cut -d "y" -f 2`		
	OsBuildDateWeek=`echo $OsBuildDate|cut -d "y" -f 1|cut -d "w" -f 2`	
	OsBuildGitTag=`echo $OsBuild|cut -d "-" -f 2`
	OsBuildArch=`echo $OsBuild|cut -d "-" -f 3`	
	SrvName=${dot_arr[0]}
	MACIP=${hyp_arr[0]}
        MACIP_HA=${MACIP:: -2}	
	SrvContext=${hyp_arr[1]}		
	SrvRole=${hyp_arr[2]}
	DeplType=`echo ${hyp_arr[3]}|cut -d "." -f 1`
        FullSrvName="$SrvName.$OsBuild.$OsSrvType.$Net.$View.$Org.pool"
    fi
fi

#879879871-db2-c2db-prod.w07y17-tag0_1-in4.42_2-opensuse-l.1000.cc.pool

#879879871-db2-c2db-prod.in4v001-42_2-opensuse.cc.pool

## 3 - 
#			- g_extgate_http-host_finvalda+lt-tocean.http_main-rev5_haproxy_i-extflow.transocean-forwarding-cone.ts.cc.pool.
