#!/usr/bin/ruby

require 'json'
require 'sqlite3'

exit 1 if not ARGV[2]
config_path = ARGV[0]
sqlite_path = ARGV[1]
type = ARGV[2]

sql = Array.new
db = SQLite3::Database.new( "#{sqlite_path}/mail.sqlite" )
json = JSON.parse(File.read("#{config_path}/mail_map.json"))

json["Data"].each do |domain,user|
  sql << "INSERT OR REPLACE INTO domains (id,domain) VALUES (NULL, '#{domain}');" 
  user.each do |username,values|

    sql << "INSERT OR REPLACE INTO accounts (id,username,domain) VALUES (NULL, '#{username}', '#{domain}');"       
    
    if values["Aliases"]
      puts "Aliases -  #{values["Aliases"]}"
      values["Aliases"].each do |mail_alias|
	sql <<  "INSERT OR REPLACE INTO aliases (id,account,alias_username,alias_domain) VALUES (NULL, '#{username}@#{domain}', '#{mail_alias}', '#{domain}');"         	
      end
    end
    
    if values["Destinations"]
      puts  "Destinations - #{values["Destinations"]}"
      values["Destinations"].each do |mail_destination|
		  
		dst_addr = mail_destination.split("@")
		if dst_addr[1]
			dst_user = dst_addr[0]
			dst_domain = dst_addr[1]
			router = "common"			
			transport = "lmtp_over_smtp"
		else
			dst_user = dst_addr[0]			
			dst_domain = domain
			router = "redirect"
			transport = "lmtp_over_smtp"
		end
		
		  
		dst_transport = mail_destination.split("::")
		if dst_transport[2]
			dst_user = dst_transport[2]			
			router = dst_transport[0]	
			transport = dst_transport[1]							
		end
		
		sql << "INSERT OR REPLACE INTO destinations (id,account,destination_username,destination_domain,router,transport) VALUES (NULL, '#{username}@#{domain}', '#{dst_user}', '#{dst_domain}', '#{router}','#{transport}');"  
		
      end      
    end    
    
  end
end


case type
when "sqlite_master"
	db.transaction 
		db.execute( "delete from domains" )
		db.execute( "delete from accounts" )
		db.execute( "delete from aliases" )
		db.execute( "delete from destinations" )
		db.execute_batch( sql.join(" ") )
		db.commit

when "debug_master"
	puts sql
end