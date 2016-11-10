
### OLD ORACLE -> MIGRATE ###
mkdir -p /media/storage_old/_tmp/ && cd /media/storage_old/_tmp/
wget http://public.edss.ee/software/Linux/Oracle/oracle10.2.0.5EE_rev2.tar.gz
tar -xzf ./oracle10.2.0.5EE_rev2.tar.gz
cp -R /media/storage_old/_tmp/software/oracle/product /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/
 chown -R oracle:oinstall /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s
###


### LOGGING SYMLINKS  ###
rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/startup.log && ln -s /media/storage/as/oracle/logs/startup.log /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/startup.log
rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/shutdown.log && ln -s /media/storage/as/oracle/logs/shutdown.log /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/shutdown.log

rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/rdbms/log && ln -s /media/storage/as/oracle/logs /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/rdbms/log
rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/rdbms/audit && ln -s /media/storage/as/oracle/logs/audit /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/rdbms/audit

rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/log && ln -s  /media/storage/as/oracle/logs/network /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/log
rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/trace && ln -s  /media/storage/as/oracle/logs/network /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/trace

 rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/dbs &&  ln -s /media/storage/as/oracle/conf/_generated /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/dbs
 rm -rf /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/admin/tnsnames.ora && ln -s /media/storage/as/oracle/conf/_context/tnsnames.ora /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g_rw/ee--s/product/10g/network/admin/tnsnames.ora
### 
