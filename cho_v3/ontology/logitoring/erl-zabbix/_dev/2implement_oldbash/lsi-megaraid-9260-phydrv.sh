#!/bin/bash
raidvars=(custom.hw.raid.megacli.drive_has_flagged_SMART_alert custom.hw.raid.megacli.drive_temperature custom.hw.raid.megacli.firmware_state custom.hw.raid.megacli.media_error_count custom.hw.raid.megacli.other_error_count custom.hw.raid.megacli.predictive_failure_count)
###my2=(0 0 0 0 27 1)
#driver count is 16, put drv address in [18:$i]
my2=(`/opt/MegaRAID/MegaCli/MegaCli64 -PDInfo -PhysDrv [18:4] -a0 |/usr/bin/egrep "(Media Error Count|Other Error Count|Predictive Failure Count|Firmware state|Drive Temperature|Drive has flagged a S.M.A.R.T alert)"| cut -d ":" -f2| sed -e 's/\ //g;s/Online.*/0/g;s/No/0/g;s/C.*//g;s/\,/\+/g'`)
cdate=`date +%s`
####echo ${#raidvars[@]}

for ((a=0, b=0; a < ${#raidvars[@]}; a++, b++))
do
	echo  "-" ${raidvars[$a]} $cdate ${my2[$b]}
done
exit 0

##send data to zabbix
#bash `basename`| zabbix-sender -c /etc/zabbix/zabbix-agentd.conf -T -i -
