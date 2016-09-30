#!/usr/bin/ruby
require "json"
require "/media/sysdata/rev5/techpool/ontology/management/rev5/naming_os.rb"
require "/media/sysdata/rev5/techpool/ontology/logitoring/zabbix/api/zabbix-sender.rb"
path = "/media/sysdata/rev5/_context/conf/monitoring/os/"



drbdfree = Array.new
diskfree = Array.new
diskstats = Array.new
netstats = Array.new

s = Zabbix::Sender.new 'x', 10051


    
json = JSON.parse(File.read("#{path}/#{Net}/#{SrvType}/#{SrvName}.json"))

#drbdfree
if json["monitoring"]["src_tasks"].include? "periodic:drbdfree"
        json["periodic:drbdfree"]["disks"].each do |disks|
                drbdfree << "{\"{#DRBDLABEL}\":\"#{disks.split(":")[1]}\"}"
        end
Metric1 = "module.drbdfree[disk,name,T]"
zabbix_resp = s.send(Hostname, Metric1, "{\"data\":[#{drbdfree.join(",")}]}")

end

#diskfree								
json["periodic:diskfree"]["disks"].each do |disks|
        diskfree << "{\"{#DISKLABEL}\":\"#{disks.split(":")[1]}\"}"
end		
Metric2 = "module.diskfree[disk,name,T]"						
zabbix_resp = s.send(Hostname, Metric2, "{\"data\":[#{diskfree.join(",")}]}")

#diskstats
json["periodic:diskstats"]["disks"].each do |disks|
        diskstats << "{\"{#DISKLABEL}\":\"#{disks.split(":")[1]}\"}"
end
Metric3 = "module.diskstats[disk,name,T]"						
zabbix_resp = s.send(Hostname, Metric3, "{\"data\":[#{diskstats.join(",")}]}")

#netstats
json["periodic:netstats"]["interfaces"].each do |interfaces|
        netstats << "{\"{#IFNAME}\":\"#{interfaces.split(":")[1]}\"}"
end
Metric4 = "module.netstats[iface,name,T]"						
zabbix_resp = s.send(Hostname, Metric4, "{\"data\":[#{netstats.join(",")}]}")
