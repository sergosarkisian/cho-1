#!/bin/sh                                                                                                                                                                                                                                    
# Execute command by failover.   
### Syntax: failover.sh <name of assumed master as written in pgpool.conf> <database path>
                                                                                                                                                                                                                                                                                                                                                                                                                 
#failed_host_name=$1  - for future autofailover
assumed_master_name=$1                                                                                                                                                                                                                                                                                                                                                                                                                                           
db_path=$2                                                                                                                                                                                                                       
delete=0                                                                                                                                                                                           

#Check current status of assumed master server:  master or replica   
/usr/bin/ssh $assumed_master_name /usr/bin/test -f $db_path/recovery.conf && RECOVERY=1 || RECOVERY=0                                                                                                                                                                                                                                       

#If replica
if [ $RECOVERY == 1 ]; then
        
      #Touch magick trigger                                                                                                                                                                                                                                                                                                   
      if [ -f $db_path/recovery.conf ]; then                                                                                                                                                                                                 
      /usr/bin/ssh -T $assumed_master_name /bin/touch $db_path/standby.trigger
	  if [ "$?" != "0" ]; then
	    echo "Failed: /bin/touch $db_path/standby.trigger"
	    exit 1
	  fi

      sleep 10
      #Postgres restart for correct working (timeline may be shifted)
      /usr/bin/ssh -T $assumed_master_name /bin/sh /etc/init.d/postgresql restart
      fi
	  if [ "$?" != "0" ]; then
	    echo "Failed: /bin/sh /etc/init.d/postgresql restart"
	    exit 1
	  fi
fi
      #Turn on backup mode
      /usr/bin/ssh -T $assumed_master_name /usr/bin/psql -U postgres -h $assumed_master_name -c "SELECT pg_start_backup('replication base', 'on')"
	  if [ "$?" != "0" ]; then
	    echo "Failed: SELECT pg_start_backup"
	    exit 1
	  fi

#Parsing pgpool.conf for server creditials                                                                                                                                                                                                                                 
for SERVER in $(cat /etc/pgpool-II/pgpool.conf|grep "backend_hostname"|grep -v " backend_hostname"|cut -d' ' -f3|sed "s/'//g"); do
    #If parsed server is supposed backend
    if [ $SERVER != $assumed_master_name ]; then
	#Stopping postgres
	/usr/bin/ssh -T $SERVER /bin/sh /etc/init.d/postgresql stop
	  if [ "$?" != "0" ]; then
	    echo "Failed: /bin/sh /etc/init.d/postgresql restart"
	    exit 1
	  fi
	#Copy recovery template
	/usr/bin/ssh -T $SERVER /bin/cp $db_path/recovery.tmpl $db_path/recovery.conf
	  if [ "$?" != "0" ]; then
	    echo "Failed: /bin/cp $db_path/recovery.tmpl $db_path/recovery.conf"
	    exit 1
	  fi
	#Change IP in recovery.conf
	/usr/bin/ssh -T $SERVER /bin/sed -i "s/{{IP}}/$assumed_master_name/" $db_path/recovery.conf
	  if [ "$?" != "0" ]; then
	    echo "Failed: /bin/sed -i "s/{{IP}}/$assumed_master_name/" $db_path/recovery.conf"
	    exit 1
	  fi

	if [ $delete == 1 ]; than
	    #Rsync all necessary fles & dirs (delete diff of files from replica) 
	    /usr/bin/ssh -T $assumed_master_name /usr/bin/rsync  --rsync-path="sudo /usr/bin/rsync" --progress -rzuogplt --compress-level=4 --delete 	$db_path/ 	$SERVER:$db_path/ --exclude postmaster.pid --exclude pg-archive/* --exclude recovery.conf

		if [ "$?" != "0" ]; then
		  echo "Failed: /usr/bin/rsync -acurz --delete 	$db_path/ 	$SERVER:$db_path"
		  exit 1
		fi

	else
	    #Rsync all necessary fles & dirs (dot't delete diff of files from replica) 
	    /usr/bin/ssh -T $assumed_master_name /usr/bin/rsync  --rsync-path="sudo /usr/bin/rsync" --progress -rzuogplt --compress-level=4	$db_path/ 	$SERVER:$db_path/ --exclude postmaster.pid --exclude pg-archive/* --exclude recovery.conf

		if [ "$?" != "0" ]; then
		  echo "Failed: /usr/bin/rsync -acurz 	$db_path/ 	$SERVER:$db_path"
		  exit 1
		fi
	fi

	sleep 5                           
	#Postgres restart                                                                                                           
	/usr/bin/ssh -T $SERVER /bin/sh /etc/init.d/postgresql restart

    else
	echo "This is the master host"
    fi
done  

#Turn off backup mode
/usr/bin/ssh -T $assumed_master_name /usr/bin/psql -U postgres -c "SELECT pg_stop_backup()"
    if [ "$?" != "0" ]; then
      echo "Failed: SELECT pg_stop_backup"
      exit 1
    fi                                                                                                                                                                                                        

echo "Cluster resync was done successfully"                                                                                                                                                                                                                               
exit 0;    



