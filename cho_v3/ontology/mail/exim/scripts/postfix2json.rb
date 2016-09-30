#!/usr/bin/ruby

require 'json'

exit 1 if not ARGV[0]
config_path = ARGV[0]

virtuals = File.read("#{config_path}/virtuals")
domains = File.read("#{config_path}/domains")

virtuals_hash = Hash.new
mail_map = Hash.new

## file to hash mapping
virtuals.each_line do |v|
  arr =  v.strip.gsub(/\s+/, " ").gsub(/#.*/, " ").split(" ")
  first = arr.shift 
  if first != nil
    virtuals_hash[first] = arr
  end
end

## resolve nested virtuals  
domains.each_line do |domain|
  domain = domain.gsub(/\s+/, "")
  mail_map[domain] ||= Hash.new
  virtuals_hash.each do |from,to|
    from_splitted = from.split("@")
    if from_splitted[1] == domain    
      
      to.each do |v|
	if v.split("@")[1] == domain
	  if to.length == 1
	    mail_map[domain][v.split("@")[0]] ||= Hash.new		      
	    mail_map[domain][v.split("@")[0]]["Aliases"] ||= Array.new	      
	    mail_map[domain][v.split("@")[0]]["Aliases"] << from_splitted[0]	      
	  else
	    virtuals_hash[v].each do |resolve|
	      mail_map[domain][from_splitted[0]] ||= Hash.new			
	      mail_map[domain][from_splitted[0]]["Destinations"] ||= Array.new		
	      mail_map[domain][from_splitted[0]]["Destinations"] << resolve
	    end
	  end
	else
	  mail_map[domain][from_splitted[0]] ||= Hash.new		    
	  mail_map[domain][from_splitted[0]]["Destinations"] ||= Array.new	    
	  mail_map[domain][from_splitted[0]]["Destinations"] << v
	end
      end
      
    end
  end
end

## uniq  
mail_map.each do |domain,from|
  from.each do |k,v|
    v["Aliases"].uniq! if v["Aliases"]
    v["Destinations"].uniq! if  v["Destinations"]
  end
end

## save to JSON  
File.open("#{config_path}/mail_map.json","w") do |f|
  f.write(JSON.pretty_generate(mail_map))
end  
  