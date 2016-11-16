#!/bin/bash

### ZYPPER ###
rm /etc/zypp/repos.d/*

### 42.2###
zypper ar -cf http://download.opensuse.org/repositories/openSUSE:/Leap:/42.2/standard standard::leap42.2
zypper ar -cf http://download.opensuse.org/update/leap/42.2/oss update_oss::leap42.2
zypper ar -cf http://download.opensuse.org/update/openSUSE-stable update_oss::stable

##SOME STANDARD
zypper ar -cf http://download.opensuse.org/repositories/Kernel:/openSUSE-42.2/standard/Kernel:openSUSE-42.2.repo
zypper ar -cf http://download.opensuse.org/repositories/network/openSUSE_Leap_42.2/network.repo
zypper ar -cf http://download.opensuse.org/repositories/shells/openSUSE_Leap_42.2/shells.repo

