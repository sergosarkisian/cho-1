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

in4func_resolve_in4() {
declare -A k v store
    
    if [[ $1 =~ --g--.*.--s ]]; then 

        arr=(${1//--/ }) 
        i=0
        for pairs in ${arr[*]}; do
            if [[ $pairs != ? ]]; then 
                v[${i}]=${pairs}
            else
                k[${i}]=${pairs}
                (( ++i))
            fi
        done
        
        i=0
        for kv in ${k[*]}; do   
            store[${kv}]=${v[$i]}
                (( ++i))
    done

    else
        echo  "Enter Class :"
        read c; store["c"]=$c
        echo  "Enter Order :"
        read o; store["o"]=$o
        echo  "Enter Family :"
        read f; store["f"]=$f
        echo  "Enter Genus :"
        read g; store["g"]=$g
        echo  "Enter Species ('main' if ommitted) :"
        read s; store["s"]=$s
        
    fi
    
    in4TaxonomySpecies="${store[s]}--s"
    in4TaxonomySerial="${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}--g--${store[s]}--s"
    in4TaxonomySerialShort="${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}"
    in4TaxonomyPath="${store[c]}--c/${store[o]}--o/${store[f]}--f/${store[g]}"    
}

in4func_Zypper () {

    ZypperArgsOnline="--non-interactive  --gpg-auto-import-keys in " 
    ZypperArgsAltOnline="--non-interactive  --gpg-auto-import-keys  -C /var/cache/zypp_offline in " 
    ZypperArgsOffline="--non-interactive  --no-gpg-checks --no-refresh -C /var/cache/zypp_offline in --force-resolution"

    if [[ `id -u` == 0 ]]; then
        Prefix=""
    else
        Prefix="sudo "
    fi
    
    if [[ -n $(echo "$1"|grep "/") ]]; then
        readarray PackagesArray < $1    
    else
        PackagesArray=("$1")
    fi
    for PackagesLines in "${PackagesArray[@]}"
    do
        if [[ $OfflineCliMode == "Yes" ]]; then
            echo "$Prefix zypper $ZypperArgsOffline ${PackagesLines}" && $Prefix zypper $ZypperArgsOffline ${PackagesLines}        
        elif  [[ $OfflineBuildMode == "Yes" ]]; then
            echo "$Prefix zypper $ZypperArgsOffline ${PackagesLines}" && ! $Prefix zypper $ZypperArgsOffline ${PackagesLines}
            echo "$Prefix zypper $ZypperArgsAltOnline ${PackagesLines}"  && $Prefix zypper $ZypperArgsAltOnline ${PackagesLines}
        else
            echo "$Prefix zypper $ZypperArgsOnline ${PackagesLines}" && $Prefix zypper $ZypperArgsOnline ${PackagesLines}
        fi  
    done
}


in4func_ZypperRepo () {

    ZypperRepoAction=$1
    ZypperRepoURI=$2
    ZypperRepoArgsOnline="--non-interactive  --gpg-auto-import-keys ar -cfk " 
    
    case $ZypperRepoAction in
    "add" )
    
        if [[ $OfflineCliMode == "Yes" ]]; then
            echo "Offline mode, all repos are cached"
        elif  [[ $OfflineBuildMode == "Yes" ]]; then
            echo "zypper $ZypperRepoArgsOnline $ZypperRepoURI" && ! zypper $ZypperRepoArgsOnline $ZypperRepoURI
        else
            echo "zypper $ZypperRepoArgsOnline $ZypperRepoURI" && zypper $ZypperRepoArgsOnline $ZypperRepoURI
        fi      
    ;;
    esac
}

in4func_run () {
    in4LandscapeFQN= in4func_resolve_in4 $1
    RunPath=$2
    RunName=$3
    
    . /media/sysdata/in4/cho/cho_v5/in4_landscape/$in4TaxonomyPath/in4/$RunPath/$RunName
}

in4func_cp () {
    in4LandscapeFQN= in4func_resolve_in4 $1
    CpSource=$2
    CpDestination=$3
    
    cp -r /media/sysdata/in4/cho/cho_v5/in4_landscape/$in4TaxonomyPath/dsl/$in4TaxonomySpecies/$CpSource $CpDestination 
}

in4func_ln () {
    in4LandscapeFQN= in4func_resolve_in4 $1
    LnSource=$2
    LnDestination=$3
    
    rm -rf $LnDestination
    ln -s /media/sysdata/in4/cho/cho_v5/in4_landscape/$in4TaxonomyPath/dsl/$in4TaxonomySpecies/$LnSource $LnDestination
}

in4func_systemd () {
    in4LandscapeFQN= in4func_resolve_in4 $1
    SystemdAction=$2
    SystemdType=$3
    SystemdName=$4
    
    case $SystemdAction in
    "add" )
        rm -f /etc/systemd/system/$SystemdName.$SystemdType
        cp -f /media/sysdata/in4/cho/cho_v5/in4_landscape/$in4TaxonomyPath/in4/5_service/systemd/$SystemdName.$SystemdType /etc/systemd/system/
    ;;
    "enable") systemctl enable $SystemdName.$SystemdType ;;
    esac
}

in4func_swf2 () {
    in4LandscapeFQN= in4func_resolve_in4 $1
    SWF2Action=$2
    SWF2Name=$3
    
    case $SWF2Action in
    "add" )
        rm -f /etc/sysconfig/SuSEfirewall2.d/services/$SWF2Name.swf2
        ln -s  /media/sysdata/in4/cho/cho_v5/in4_landscape/$in4TaxonomyPath/in4/4_security/swf2/$SWF2Name.swf2 /etc/sysconfig/SuSEfirewall2.d/services
    ;;
    esac
}


### CLASSIC ###
_umount() {
    Mount=$1
    while mountpoint -q $Mount; do
        sudo umount $Mount || sleep 1
    done
}
###
