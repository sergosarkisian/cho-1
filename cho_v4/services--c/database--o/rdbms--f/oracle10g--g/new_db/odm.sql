connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /media/<%= @disk_label %>/database/oracle/<%= @sid %>/manage/conf/scripts/logs/odm.log

@rdbms/admin/dminst.sql SYSAUX TEMP;
spool off
