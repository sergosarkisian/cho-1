#!/bin/bash
execPath=`pwd`
declare -A k v store
echo -e  "OBS status\n\n"
currentUnixtime=`date "+%s"`
oscTmpFile="/tmp/osc_status.tmp"
openSuseVersion="openSUSE_Leap_42.1"

find ../form/technologies/*--c/*--o/*--f/*/in4/1_build/obs/* -type d -not -path "*.osc*" -not -path "*_git_*" -print0 | while IFS= read -r -d $'\0' line; do
    cd $execPath
    cd $line
    buildPackage=`echo $line|sed -e "s/.*obs\///"`    
    osc blt $openSuseVersion x86_64 -l > $oscTmpFile
    buildFinished=`cat $oscTmpFile |grep "finished \""`
    buildFailed=`cat $oscTmpFile |grep "failed \""`
    buildSRPM=`cat $oscTmpFile|grep SRPMS -m 1 `
    buildVersion=`echo $buildSRPM|sed -e "s/.*\/ *//"|cut -d "-" -f 2`
    buildDate=`echo $buildFinished|sed -e "s/.*at *//" -e "s/\.//"`
    buildUnixtime=`date --date="$buildDate" "+%s"`
    
    
 if [[ ! $buildVersion =~ [0-9] ]]; then buildVersion="unknown"; fi
    echo "## Package - $buildPackage - Ver. $buildVersion                   \\  Package path $line"    

    if [[ $buildUnixtime == ?(-)+([0-9]) ]]; then
        if [[ $(($currentUnixtime - $buildUnixtime)) -gt 432000 ]]; then
            echo "Need upd - $buildPackage, last update - $buildDate"
            if [ -f "$execPath/$line/_service" ]; then
                osc service rr
                echo "Service update trigger was sent, new package will be builded"
            fi
            #osc service rebuild
        else
            echo "Already updated - $buildPackage, last update - $buildDate"    
        fi
    else
        echo "$buildUnixtime is not the number in package $buildPackage. Build string  - $buildFinished"
    fi
    echo  -e "\n"
done
