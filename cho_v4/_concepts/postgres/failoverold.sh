#!/bin/sh                                                                                                                                                                                                                                    
# Execute command by failover.                                                                                                                                                                                                               
# special values:  %d = node id                                                                                                                                                                                                              
#                  %h = host name                                                                                                                                                                                                            
#                  %p = port number                                                                                                                                                                                                          
#                  %D = database cluster path                                                                                                                                                                                                
#                  %m = new master node id                                                                                                                                                                                                   
#                  %M = old master node id                                                                                                                                                                                                   
#                  %H = new master node host name                                                                                                                                                                                            
#                  %P = old primary node id                                                                                                                                                                                                  
#                  %% = '%' character                                                                                                                                                                                                        
failed_host_name=$1                                                                                                                                                                                                                          
failed_db_path=$2                                                                                                                                                                                                                       
new_master_host_name=$3                                                                                                                                                                                                                      
                                                                                                                                                                                                       
                                                                                                                                                                                                                                             
# Do nothing if standby goes down.                                                                                                                                                                                                           
if [ -n $new_master_host_name ]; then                                                                                                                                                                                                                                                                                                                   
                                                                                                                                                                                                       
      /usr/bin/ssh -T $new_master_host_name /bin/touch $failed_db_path/standby.trigger
      sleep 10
      /usr/bin/ssh -T $new_master_host_name /bin/sh /etc/init.d/postgresql restart

                                                                                                                                                                                                                                      
      for SERVER in $(cat /etc/pgpool-II/pgpool.conf|grep "backend_hostname"|grep -v " backend_hostname"|cut -d' ' -f3|sed "s/'//g"); do
	  if [ $SERVER != $new_master_host_name ]; then
	      /usr/bin/ssh -T $SERVER /bin/cp $failed_db_path/recovery.tmpl $failed_db_path/recovery.conf   
	      /usr/bin/ssh -T $SERVER /bin/sed -i "s/{{IP}}/$new_master_host_name/" $failed_db_path/recovery.conf
	      #/usr/bin/ssh -T $SERVER /bin/sed -i "s/{{PATH}}/$failed_db_path\/standby.trigger/" $failed_db_path/recovery.conf

	      /usr/bin/ssh -T $new_master_host_name /usr/bin/rsync -acurz --delete  $failed_db_path/archive/ 		$SERVER:$failed_db_path/archive/
	      /usr/bin/ssh -T $new_master_host_name /usr/bin/rsync -acurz --delete  $failed_db_path/pg_xlog/		$SERVER:$failed_db_path/pg_xlog/
              sleep 5                                                                                                                                         
	      /usr/bin/ssh -T $SERVER /bin/sh /etc/init.d/postgresql restart

	  else
	  echo "This is master host"
	  fi
      done                                                                                                                                                                                                          
fi                                                                                                                                                                                                                                             
exit 0;    



