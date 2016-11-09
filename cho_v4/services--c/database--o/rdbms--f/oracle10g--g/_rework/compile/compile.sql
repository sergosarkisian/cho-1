set serveroutput on;
alter session set plsql_compiler_flags='NATIVE';

alter package kernel_lck compile;

alter package kernel_lck compile body;

--quit


