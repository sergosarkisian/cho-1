#!/bin/bash

echo -e "\n\n######## ######## START -  scenario - ${0##*/} ######## ########\n\n"

zypper  --gpg-auto-import-keys ref
zypper --non-interactive in --force kernel-default grub2

echo -e "\n\n######## ######## STOP -  scenario - ${0##*/} ######## ########\n\n"
