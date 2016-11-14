##Locks

mkdir -p /media/storage/as/oracle/cone/locks
rm -rf /media/storage/as/oracle/cone/plsql_compile/ && cd /media/storage/as/oracle/cone/plsql_compile
wget http://public.edss.ee/software/Linux/Oracle/cone_locks_in4.tar.gz
tar -xzf ./cone_locks_in4.tar.gz

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
