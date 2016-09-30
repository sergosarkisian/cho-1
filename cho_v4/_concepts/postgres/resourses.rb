parameters = Hash.new

##Userspace parameters
parameters["eff_io_concur"] = 10   
parameters["max_connections"] = 100    
db_ram_percent = 80
##

node_mem = %x(free).split(" ")[7].to_i
parameters["TOTAL_mem"] = node_mem

db_mem = node_mem*1024*db_ram_percent/100

parameters["shared_mem"] = db_mem*25/100
parameters["work_mem"] = db_mem*10/100
parameters["maint_mem"] = db_mem*15/100
parameters["effective_cache"] = db_mem*50/100  

puts parameters 
