#!/bin/bash



echo  "Enter a 2-level FQDN:"
read L2_DOMAIN
echo  "Enter a 3-level domain name (if no - www is used):"
read LX_DOMAIN
echo  "Enter nginx port:"
read NGINX_PORT
echo  "With PHP support? (yes/no):"
read WITH_PHP
echo  "With MySQL support? (yes/no):"
read WITH_MYSQL



if [[ $LX_DOMAIN = '' ]]; then $LX_DOMAIN="www"; fi
if [[ -z "$L2_DOMAIN" && -z "$LX_DOMAIN" && -z "$NGINX_PORT" && -z "$WITH_PHP" && -z "$WITH_MYSQL" ]]; then echo "Please fill up vars correctly"; exit 1; fi 



 
if [[ ! -d /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN ]]; then           
 
 
    PASSWORD=`pwgen 16`
    echo "User password (FTP,SSH,DB) - $PASSWORD"
    DB_USERNAME=`echo $LX_DOMAIN.$L2_DOMAIN| cut -c1-16` 
    echo "Username for DB - $DB_USERNAME"

    #SSH user add
	useradd -Md /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN -g nobody $LX_DOMAIN.$L2_DOMAIN
    echo "$LX_DOMAIN.$L2_DOMAIN:$PASSWORD" |chpasswd

    #FTP user add
	(echo "$PASSWORD"; echo "$PASSWORD" ) | /usr/bin/pure-pw useradd $LX_DOMAIN.$L2_DOMAIN -u $LX_DOMAIN.$L2_DOMAIN -g nobody -d /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN -m
		
    /usr/bin/pure-pw mkdb

    #Initial dir creation
    mkdir -p /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/htdocs                    
    mkdir -p /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/logs
    mkdir -p /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/services
    mkdir -p /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/tmp/nginx
    mkdir -p /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/tmp/php/sessions         

    
	if [[ $WITH_PHP == "yes" ]]; then
		#PHP-FPM configuration
		cp /etc/faster/cmdb/techpool/php5/files/fpm-pool.conf /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/php-fpm.pool
		sed -i "s/L2_DOMAIN/$L2_DOMAIN/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/php-fpm.pool
		sed -i "s/LX_DOMAIN/$LX_DOMAIN/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/php-fpm.pool
		
		#PHP TEST PAGE
		echo "<?php phpinfo(); ?>" > /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/htdocs/index.php	
    fi
    echo "I am alive - $LX_DOMAIN.$L2_DOMAIN" > /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/htdocs/index.html
    
    #Nginx SystemD configuration
    cp /etc/faster/cmdb/techpool/nginx/files/user_systemd.service /usr/lib/systemd/system/$LX_DOMAIN.$L2_DOMAIN.service
    sed -i "s/L2_DOMAIN/$L2_DOMAIN/g" /usr/lib/systemd/system/$LX_DOMAIN.$L2_DOMAIN.service
    sed -i "s/LX_DOMAIN/$LX_DOMAIN/g" /usr/lib/systemd/system/$LX_DOMAIN.$L2_DOMAIN.service    
    
    #Nginx configuration
    cp /etc/faster/cmdb/techpool/nginx/erb/common_nginx.conf.erb /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    cat /etc/faster/cmdb/techpool/nginx/erb/servers_nginx.conf.erb >>  /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
	if [[ $WITH_PHP == "yes" ]]; then
		cat /etc/faster/cmdb/techpool/nginx/erb/server-php-fpm.erb >>  /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
	else
		cat /etc/faster/cmdb/techpool/nginx/erb/server-static.erb >>  /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    fi
    
    echo -e "\t}\n" >> /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    echo -e "}\n" >> /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    
    sed -i "s/L2_DOMAIN/$L2_DOMAIN/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    sed -i "s/LX_DOMAIN/$LX_DOMAIN/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    
    sed -i "s/CONF_client_body_temp_path/tmp\/nginx\/client/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    sed -i "s/CONF_proxy_temp_path/tmp\/nginx\/proxy/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    sed -i "s/CONF_fastcgi_temp_path/tmp\/nginx\/fastcgi/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    sed -i "s/CONF_uwsgi_temp_path/tmp\/nginx\/uwsgi/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    sed -i "s/CONF_scgi_temp_path/tmp\/nginx\/scgi/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf

    sed -i "s/NGINX_PORT/$NGINX_PORT/g" /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/conf/nginx.conf
    
    

    chown -R $LX_DOMAIN.$L2_DOMAIN:nobody /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    chmod -R 700 /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    
    setfacl -R -m d:u:$LX_DOMAIN.$L2_DOMAIN:rwx /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -m d:u::rwx /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -m u:$LX_DOMAIN.$L2_DOMAIN:rwx /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -m u::rwx /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -m d:g:nobody:x /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -m d:g::x /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -m g:nobody:x /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -m g::x /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -m d:o::x /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -m o::x /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -m u:$LX_DOMAIN.$L2_DOMAIN:rwx /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -x g:nobody /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    setfacl -R -x d:g:nobody /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN
    
       

    
    #NGINX BUG!!!
    touch /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/logs/nginx.error.log 
#     setfacl -R -m o::rwx /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/logs/nginx.error.log            
#     setfacl -R -m d:o::rwx /media/storage/sites/$LX_DOMAIN.$L2_DOMAIN/logs/nginx.error.log            
    
    #Systemd 
    systemctl --system daemon-reload && sleep 1
    systemctl restart $LX_DOMAIN.$L2_DOMAIN.service
    systemctl enable $LX_DOMAIN.$L2_DOMAIN.service      
        
	if [[ $WITH_MYSQL == "yes" ]]; then        
		#DB database & user add
		CREATEDB="CREATE DATABASE IF NOT EXISTS \`$LX_DOMAIN.$L2_DOMAIN\` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;" 
		CREATEUSER="GRANT ALL ON \`$LX_DOMAIN.$L2_DOMAIN\`.* TO '$DB_USERNAME'@'localhost' IDENTIFIED BY '$PASSWORD';" 
		mysql -u root -e "$CREATEDB"
		mysql -u root -e "$CREATEUSER"
		mysql -u root -e "FLUSH PRIVILEGES;"
	fi
  
else 
echo "Site already exists!"; exit 1
fi

#DEL - rm FQDN dir, systemd service, php pool, mysql acc, mysql data, ssh acc, ftp acc