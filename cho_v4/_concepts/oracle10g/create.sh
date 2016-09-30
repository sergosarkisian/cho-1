
----

su - oracle bash -c "/media/storage/database/oracle/eshare/conf/scripts/db.sh > /media/storage/database/oracle/eshare/conf/scripts/logs/db_initial.log"

----              

su - oracle bash -c "/opt/oracle/product/10g/bin/sqlplus -l '/ as sysdba' <<EOF
    set echo on
    set verify off
    set serveroutput on;
    CREATE SPFILE = '/media/storage/database/oracle/eshare/conf/dbs/spfile.ora' FROM PFILE = '/media/storage/database/oracle/eshare/conf/scripts/init.ora';
    exit;
EOF
"

/etc/init.d/oracle restart            


----

su - oracle bash -c "/opt/oracle/product/10g/bin/sqlplus -l \'/ as sysdba\' <<EOF
    set echo on
    set verify off
    set serveroutput on;
    create user oracledba identified by !oracledba1;
    grant create session, connect, select any table, sysdba, sysoper, imp_full_database, exp_full_database, grant any privilege to oracledba;
    grant read, write on directory export to oracledba;
    commit;
    exit;
EOF
"


----

    


/etc/init.d/oracle restart
