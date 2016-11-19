#!/bin/bash
set -e
echo -e "\n\n######## ######## BEGIN -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"

### SNAPPER ###
#ZYPPER
zypper --gpg-auto-import-keys --non-interactive in --force snapper snapper-zypp-plugin yast2-snapper grub2-snapper-plugin
#CONF
#??
###
echo -e "\n\n######## ######## END -  steps_init - `echo ${BASH_SOURCE[0]}|awk -F/ '{print $NF}'` ######## ########\n\n"
