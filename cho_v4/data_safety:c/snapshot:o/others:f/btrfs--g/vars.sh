#!/bin/bash
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
### IN4 BASH HEADER ###
set -e

###SNAP UNIT VARS
#Registred
    SnapUnitDigitRegistred=1
    SnapUnitNamingRegistred="_none_"
#Unsorted
    SnapUnitDigitUnsorted=2
    SnapUnitNamingUnsorted="unsorted"
#Minutely
    SnapUnitDigitMinutely=3
    SnapUnitNamingMinutely="minutely"    
#Hourly
    SnapUnitDigitHourly=4
    SnapUnitNamingHourly="hourly"        
    SnapUnitTimingCriteriaHourly=`date +%d.%m.%y_w%W_%H:`
#Daily
    SnapUnitDigitDaily=5
    SnapUnitDaily="daily"
    SnapUnitTimingCriteriaDaily=`date +%d.%m.%y_`
#Weekly
    SnapUnitDigitWeekly=6
    SnapUnitWeekly="weekly"
    SnapUnitTimingCriteriaWeekly=`date +_w%W_`
#Monthly
    SnapUnitDigitMonthly=7
    SnapUnitMonthly="monthly"
    SnapUnitTimingCriteriaMonthly=`date +.%m.%y_`    
#Manual
    SnapUnitDigitManual=8
    SnapUnitNamingManual="manual"
#Trash
    SnapUnitDigitTrash=9
    SnapUnitNamingTrash="trash"
#Root
    SnapUnitDigitRoot=10
    SnapUnitNamingRoot="root"
###
