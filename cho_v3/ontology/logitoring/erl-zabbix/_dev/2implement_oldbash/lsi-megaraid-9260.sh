/opt/MegaRAID/MegaCli/MegaCli64

meckey="custom.hw.raid.megacli.media_error_count"
 
mecval=`/opt/MegaRAID/MegaCli/MegaCli64 -PDInfo -PhysDrv \[18:11\] -a0| egrep '(Media Error Count)'| cut -d ":" -f2|sed -e s'/ //g'`
 
echo "-" $meckey `date +%s` $mecval


/opt/MegaRAID/MegaCli/MegaCli64 -LDPDInfo -aALL| egrep '(Media Error Count|Other Error Count|Predictive Failure Count|Firmware state|Drive Temperature|Drive has flagged a S.M.A.R.T alert)'



#Disk status for 0-15

/opt/MegaRAID/MegaCli/MegaCli64 -PDInfo -PhysDrv \[18:11\] -a0| egrep '(Media Error Count|Other Error Count|Predictive Failure Count|Firmware state|Drive Temperature|Drive has flagged a S.M.A.R.T alert)'
[start]
Media Error Count: 0
Other Error Count: 0
Predictive Failure Count: 0
Firmware state: Online, Spun Up
Drive Temperature :27C (80.60 F)
Drive has flagged a S.M.A.R.T alert : No
[/end]
# VD info state for 0-1
/opt/MegaRAID/MegaCli/MegaCli64 -LDInfo -L1 -a0| grep 'State'

#BBU state
/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL | egrep '(Voltage:|Temperature:|Battery Replacement required|Remaining Capacity Low|Pack energy|Capacitance|Remaining reserve space)'
[start]
Voltage: 8796 mV
Temperature: 26 C
  Battery Replacement required            : No
  Remaining Capacity Low                  : No
  Pack energy             : 77 J 
  Capacitance             : 97 
  Remaining reserve space : 100 
[/end]

/opt/MegaRAID/MegaCli/MegaCli64 -AdpBbuCmd -GetBbuStatus -aALL | \
egrep '(Voltage:|Temperature:|Battery Replacement required|Remaining Capacity Low|Pack energy|Capacitance|Remaining reserve space)'|\
sed -e 's/^ * //g'| cut -d ":" -f2|cut -d " " -f2

#AdpBbuCmd
custom.hw.raid.megacli.bbu_battery_remaining_reserve_space
custom.hw.raid.megacli.bbu_battery_replacement_required
custom.hw.raid.megacli.bbu_capacitance
custom.hw.raid.megacli.bbu_pack_energy
custom.hw.raid.megacli.bbu_remaining_capacity_low
custom.hw.raid.megacli.bbu_temperature
custom.hw.raid.megacli.bbu_voltage

custom.hw.raid.megacli.bbu_battery_remaining_reserve_space 100
custom.hw.raid.megacli.bbu_battery_replacement_required 0
custom.hw.raid.megacli.bbu_capacitance 97
custom.hw.raid.megacli.bbu_pack_energy 77
custom.hw.raid.megacli.bbu_remaining_capacity_low 0
custom.hw.raid.megacli.bbu_temperature 26
custom.hw.raid.megacli.bbu_voltage 8940

#PDInfo	 
custom.hw.raid.megacli.drive_has_flagged_SMART_alert
custom.hw.raid.megacli.drive_temperature
custom.hw.raid.megacli.firmware_state
custom.hw.raid.megacli.media_error_count
custom.hw.raid.megacli.other_error_count
custom.hw.raid.megacli.predictive_failure_count


