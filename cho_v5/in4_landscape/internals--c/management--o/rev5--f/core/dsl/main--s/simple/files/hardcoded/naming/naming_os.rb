#!/bin/ruby
Naming_view=ARGV[0]
Name=ARGV[1]

#if Naming_view == "os" 
  
  if  Name =~ "pool" 
    Hostname=Name
  else
    Hostname= %x(hostname -f).chomp
  end
    
  dot_arr=Hostname.split(".")
  hyp_arr=Hostname.split("-")
  
  Org=dot_arr[4]
  Net=dot_arr[2]
  View=dot_arr[3]
  SrvType=dot_arr[1]
  SrvName=dot_arr[0]
  MACIP=hyp_arr[0]
  MACIP_HA=MACIP[0...-2]
  SrvContext=hyp_arr[1]	
  SrvRole=hyp_arr[2]
  puts SrvName
    
#end    
