#!/usr/bin/ruby
require "json"
path="/etc/faster/cmdb/data/monitoring/servers.pool"

z_proxy_list = ['loots','mkm','tsc', 'tk']
#z_proxy_port = {'all' => '10051', 'loots' => '64904', 'mkm' => '64902', 'tsc' => '64901','tk' => '64903'}
z_proxy_addr = {'all' => 'x', 'loots' => 'ele.loots.ee', 'mkm' => 'www.emde.ee', 'tsc' => 'x.tschudishipping.no','tk' => 'x.tk.ee'}
z_proxy_force_all = ['0205-hv-tsc.l-suse-rev4.servers.pool']


z_sender = Array.new
z_sender_binary = "sudo /usr/sbin/zabbix-sender"

Dir.entries("#{path}/").select.each do |stype|
	
	client =stype.gsub(/\W/,'')
	if client != ""
		Dir.entries("#{path}/#{stype}/").select.each do |d|
			client =d.gsub(/\W/,'')
			if client != ""
				
				Dir.entries("#{path}/#{stype}/#{client}/").select.each do |f|
					drbdfree = Array.new
					diskfree = Array.new
					diskstats = Array.new
					netstats = Array.new
					
					host = f.split(".")[0]
					
					if (z_proxy_list.include? client and not z_proxy_force_all.include? "#{host}.#{stype}.servers.pool")
						z_proxy = z_proxy_addr[client]
					else
						z_proxy = z_proxy_addr["all"]
					end	
					
					if /\.json$/.match(f)  	
						json = JSON.parse(File.read("#{path}/#{stype}/#{client}/#{f}"))
						
						puts "###### Server #{host}.#{stype}.servers.pool using proxy #{z_proxy} ######"	
						z_sender << "echo \"###### Server #{host}.#{stype}.servers.pool using proxy #{z_proxy} ######\""
						
						#drbdfree
						if json["monitoring"]["src_tasks"].include? "periodic:drbdfree"
							json["periodic:drbdfree"]["disks"].each do |disks|
								drbdfree << "{\"{#DRBDLABEL}\":\"#{disks.split(":")[1]}\"}"
							end
						metric = "module.drbdfree[disk,name,T]"
						z_sender << "echo \"# Metric - #{metric}\""							
						z_sender << "#{z_sender_binary} -z #{z_proxy} -s #{host}.#{stype}.servers.pool -k #{metric} -o '{\"data\":[#{drbdfree.join(",")}]}'"													
						end
						
						#diskfree								
						json["periodic:diskfree"]["disks"].each do |disks|
							diskfree << "{\"{#DISKLABEL}\":\"#{disks.split(":")[1]}\"}"
						end		
						metric = "module.diskfree[disk,name,T]"						
						z_sender << "echo \"# Metric - #{metric}\""													
						z_sender << "#{z_sender_binary} -z #{z_proxy} -s #{host}.#{stype}.servers.pool -k #{metric} -o '{\"data\":[#{diskfree.join(",")}]}'"							
						
						#diskstats
						json["periodic:diskstats"]["disks"].each do |disks|
							diskstats << "{\"{#DISKLABEL}\":\"#{disks.split(":")[1]}\"}"
						end
						metric = "module.diskstats[disk,name,T]"						
						z_sender << "echo \"# Metric - #{metric}\""													
						z_sender << "#{z_sender_binary} -z #{z_proxy} -s #{host}.#{stype}.servers.pool -k #{metric} -o '{\"data\":[#{diskstats.join(",")}]}'"
						
						#netstats
						json["periodic:netstats"]["interfaces"].each do |interfaces|
							netstats << "{\"{#IFNAME}\":\"#{interfaces.split(":")[1]}\"}"
						end
						metric = "module.netstats[iface,name,T]"						
						z_sender << "echo \"# Metric - #{metric}\""													
						z_sender << "#{z_sender_binary} -z #{z_proxy} -s #{host}.#{stype}.servers.pool -k #{metric} -o '{\"data\":[#{netstats.join(",")}]}'"
						
						z_sender << "echo -e \"###### END ######\\n\""
						
					end
				end
			end
		end
	end
end

File.open("/tmp/z-sender.sh","w") do |f|
	f.write(z_sender.join("\n\n"))
end		

exec('/bin/sh /tmp/z-sender.sh|egrep -v "failed: 0|skipped: 0"')
