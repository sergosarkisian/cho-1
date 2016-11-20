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
    
    in4TaxonomySerial="${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}--g--${store[s]}--s"
    in4TaxonomySerialShort="${store[c]}--c--${store[o]}--o--${store[f]}--f--${store[g]}"
    in4TaxonomyPath="${store[c]}--c/${store[o]}--o/${store[f]}--f/${store[g]}"    
}

in4func_Zypper () {

    ZypperArgsOnline="--non-interactive  --gpg-auto-import-keys in " 
    ZypperArgsAltOnline="--non-interactive  --gpg-auto-import-keys  -C /var/cache/zypp_offline in " 
    ZypperArgsOffline="--non-interactive  --no-gpg-checks --no-refresh -C /var/cache/zypp_offline in --force"

    if [[ -n $(echo "$1"|grep "/") ]]; then
        readarray PackagesArray < $1    
    else
        PackagesArray=($1)
    fi
    for PackagesLines in "${PackagesArray[@]}"
    do
        if [[ -z $OfflineDir ]]; then
            echo "zypper $ZypperArgsOnline ${PackagesLines}" && zypper $ZypperArgsOnline ${PackagesLines}
        elif [[ $OfflineMode == 1  ]]; then
            echo "zypper $ZypperArgsOffline ${PackagesLines}" && zypper $ZypperArgsOffline ${PackagesLines}
        else
            echo "zypper $ZypperArgsOffline ${PackagesLines}" && ! zypper $ZypperArgsOffline ${PackagesLines}
            echo "zypper $ZypperArgsAltOnline ${PackagesLines}"  && zypper $ZypperArgsAltOnline ${PackagesLines}
        fi  
    done
}

in4func_run () {
    "internals--c--linux_sys--o--boot--f--dracut--g--main--s" "2_init/opensuse" "in4__main--s.package.zypper.sh"
    in4LandscapeFQN= in4func_resolve_in4 $1
    RunPath=$2
    RunName=$3
    
    . /media/sysdata/in4/cho/cho_v5/in4_landscape/$in4TaxonomyPath/in4/$RunPath/$RunName
}

in4func_cp () {
    in4LandscapeFQN= in4func_resolve_in4 $1
    Source=$2
    Destination=$3
    
    cp -r /media/sysdata/in4/cho/cho_v5/in4_landscape/$in4TaxonomyPath/dsl/${store[s]}/$Source $Destination 
}
