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

cp /etc/hosts /etc/hosts.back
cp /media/sysdata/in4/cho/cho_v4/internals:c/linux_sys:o/network:f/suse-network:g/hosts /etc/hosts
echo "127.0.0.3 $FullSrvName $SrvName" >> /etc/hosts

hostnamectl --transient set-hostname $SrvName
hostnamectl --static set-hostname  $FullSrvName
timedatectl set-timezone Europe/Tallinn
echo "$FullSrvName" > /etc/HOSTNAME 
