### MOUNTS ###
zypper in ocfs2-tools
fsck.ocfs2 /dev/sdf
tunefs.ocfs2 -L "storage_old" /dev/sdf
mkdir /media/storage_old
mount /dev/disk/by-label/storage_old -o inode64,rw,noatime,acl /media/storage_old
###


#/usr/bin/rsync -au  --info=progress2 /media/storage_old/database/oracle/wk10/data/main/ /media/storage/as/oracle/data/master/

### MIGRATE BASE DBFs ###
cp /media/storage_old/database/oracle/wk10/data/main/*.ctl /media/storage/as/oracle/data/master/
cp /media/storage_old/database/oracle/wk10/data/main/*.log /media/storage/as/oracle/data/master/
cp /media/storage_old/database/oracle/wk10/data/main/sysaux01.dbf /media/storage/as/oracle/data/master/
cp /media/storage_old/database/oracle/wk10/data/main/system01.dbf /media/storage/as/oracle/data/master/
cp /media/storage_old/database/oracle/wk10/data/main/users01.dbf /media/storage/as/oracle/data/master/

systemctl restart in4__oracle10g.service 
su - oracle
sqlplus "/ as SYSDBA"

ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/redo01.log' TO '/media/storage/as/oracle/data/master/redo01.log';
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/redo02.log' TO '/media/storage/as/oracle/data/master/redo02.log'; 
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/redo03.log' TO '/media/storage/as/oracle/data/master/redo03.log';
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/sysaux01.dbf' TO '/media/storage/as/oracle/data/master/sysaux01.dbf';
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/system01.dbf' TO '/media/storage/as/oracle/data/master/system01.dbf';
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/users01.dbf' TO '/media/storage/as/oracle/data/master/users01.dbf';
ALTER DATABASE DATAFILE '/media/storage/database/oracle/wk10/data/main/undotbs01.dbf' OFFLINE DROP;

###

### ###

chown oracle:oinstall /media/storage_old/database/oracle/wk10/
chown oracle:oinstall /media/storage_old/database/oracle
chown oracle:oinstall /media/storage_old/database/
chown oracle:oinstall /media/storage_old/
chown -R oracle:oinstall /media/storage_old/database/oracle/wk10/data/
ls |grep dbf|egrep -v "sysaux01|system01|users01"
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/temp01.dbf' TO '/media/storage_old/database/oracle/wk10/data/main/temp01.dbf';
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/undotbs01.dbf' TO '/media/storage_old/database/oracle/wk10/data/main/undotbs01.dbf';

ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/ealc.dbf' TO '/media/storage_old/database/oracle/wk10/data/main/ealc.dbf';
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/ecore.dbf' TO '/media/storage_old/database/oracle/wk10/data/main/ecore.dbf';
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/edoc.dbf' TO '/media/storage_old/database/oracle/wk10/data/main/edoc.dbf';
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/ejob.dbf' TO '/media/storage_old/database/oracle/wk10/data/main/ejob.dbf';
ALTER DATABASE RENAME FILE '/media/storage/database/oracle/wk10/data/main/etocean.dbf' TO '/media/storage_old/database/oracle/wk10/data/main/etocean.dbf';

shutdown immediate
startup
###

# ALTER DATABASE DATAFILE '/media/storage_old/database/oracle/wk10/data/main/undotbs01.dbf' OFFLINE DROP;
# ALTER DATABASE DATAFILE '/media/storage_old/database/oracle/wk10/data/main/ecore.dbf' OFFLINE DROP;
# ALTER DATABASE DATAFILE '/media/storage_old/database/oracle/wk10/data/main/ealc.dbf' OFFLINE DROP;
# ALTER DATABASE DATAFILE '/media/storage_old/database/oracle/wk10/data/main/edoc.dbf' OFFLINE DROP;
# ALTER DATABASE DATAFILE '/media/storage_old/database/oracle/wk10/data/main/ejob.dbf' OFFLINE DROP;
# ALTER DATABASE DATAFILE '/media/storage_old/database/oracle/wk10/data/main/etocean.dbf' OFFLINE DROP;
