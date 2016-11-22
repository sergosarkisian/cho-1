#!/bin/sh
########    #######    ########    #######    ########    ########
##     / / / /    License    \ \ \ \ 
##    Copyleft culture, Copyright (C) is prohibited here
##    This work is licensed under a CC BY-SA 4.0
##    Creative Commons Attribution-ShareAlike 4.0 License
##    Refer to the http://creativecommons.org/licenses/by-sa/4.0/
########    #######    ########    #######    ########    ########
##    / / / /    Code Climate    \ \ \ \ 
##    Language = bash
##    Indent = space;    4 chars;
########    #######    ########    #######    ########    ########
set -e

in4func_ZypperRepo "add"  "http://download.opensuse.org/repositories/home:/conecenter:/rev5a1:/ontology:/services--c:/mail--o:/mta--f/openSUSE_Leap_42.2/home:conecenter:rev5a1:ontology:services--c:mail--o:mta--f.repo"
in4func_Zypper "exim"
