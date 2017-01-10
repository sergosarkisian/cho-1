##Locks

mkdir -p /media/storage/as/oracle/cone/locks
rm -rf /media/storage/as/oracle/cone/plsql_compile/ && mkdir -p /media/storage/as/oracle/cone/plsql_compile && cd /media/storage/as/oracle/cone/plsql_compile
wget http://public.edss.ee/software/Linux/Oracle/cone_locks_in4.tar.gz
tar -xzf ./cone_locks_in4.tar.gz

chown -R oracle:oinstall /media/storage/as/oracle/cone/plsql_compile
setfacl -R -m u:oracle:rwx /media/storage/as/oracle/cone/plsql_compile
setfacl -R -m d:u:oracle:rwx /media/storage/as/oracle/cone/plsql_compile
setfacl -R -m g:oinstall:rwx /media/storage/as/oracle/cone/plsql_compile
setfacl -R -m d:g:oinstall:rwx /media/storage/as/oracle/cone/plsql_compile
su - oracle 

sqlplus / as SYSDBA
EXECUTE UTL_RECOMP.RECOMP_PARALLEL(NULL, 'E$CORE');
exit

mv /usr/bin/gcc-4.8 /usr/bin/realgcc
cp /media/storage/as/oracle/cone/plsql_compile/bin/gcc /usr/bin/gcc-4.8 && chmod 755 /usr/bin/gcc-4.8

su - oracle 
sqlplus 'E$CORE'

	set echo on
	set verify off
	set serveroutput on;
	alter session set plsql_compiler_flags="NATIVE";
	alter package lck compile;
	alter package lckv compile;
	alter package lck compile body;
	BEGIN                                                                                                                                                                               
	LCK.CLEAR(0);                                                                                                                                                                
	END; 
	/
	exit;

####
	RESULT:
ls  /media/storage/as/oracle/cone/locks  => sfile

###

mv -f /usr/bin/realgcc /usr/bin/gcc-4.8
