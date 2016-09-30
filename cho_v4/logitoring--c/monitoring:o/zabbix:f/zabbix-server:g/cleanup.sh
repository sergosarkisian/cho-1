tables="history history_uint history_str history_text history_log trends trends_uint alerts"
for table in $tables
    do
        DELETES=$( /usr/bin/psql --dbname zabbix -c "truncate $table ;" )
        echo " $DELETES from table $table "
    done
