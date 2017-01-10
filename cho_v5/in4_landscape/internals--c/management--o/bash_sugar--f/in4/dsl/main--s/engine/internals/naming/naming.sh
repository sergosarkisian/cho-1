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
fi

## 3 - 
#			- g_extgate_http-host_finvalda+lt-tocean.http_main-rev5_haproxy_i-extflow.transocean-forwarding-cone.ts.cc.pool.
