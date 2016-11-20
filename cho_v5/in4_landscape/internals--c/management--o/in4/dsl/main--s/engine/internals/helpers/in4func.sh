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

in4func_Zypper () {

    ZypperArgsOnline="--non-interactive  --gpg-auto-import-keys in " 
    ZypperArgsOffline="--non-interactive  --no-gpg-checks --no-refresh -C /var/cache/zypp_offline in --force"

    readarray PackagesArray < $1
    for PackagesLines in "${PackagesArray[@]}"
    do
        if [[ -z $OfflineDir ]]; then
            echo "zypper $ZypperArgsOnline ${PackagesLines}" && zypper $ZypperArgsOnline ${PackagesLines}
        elif [[ $OfflineMode == 1  ]]; then
            echo "zypper $ZypperArgsOffline ${PackagesLines}" && zypper $ZypperArgsOffline ${PackagesLines}
        else
            echo "zypper $ZypperArgsOffline ${PackagesLines}" && ! zypper $ZypperArgsOffline ${PackagesLines}
            echo "zypper $ZypperArgsOnline ${PackagesLines}"  && zypper $ZypperArgsOnline ${PackagesLines}
        fi  
    done
}
