##Locks

##cp compiler as in db-oracle.sh

set verify off
set serveroutput on;
alter session set plsql_compiler_flags="NATIVE";
alter package lck compile;
alter package lck compile body;


exec rls.init();

##Check
exec kernel_int.make_logon('DIMIK', '')
