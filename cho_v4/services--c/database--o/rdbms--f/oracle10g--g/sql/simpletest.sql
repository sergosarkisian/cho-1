WHENEVER SQLERROR EXIT SQL.SQLCODE
exec dbms_output.put_line( 'Hello' );
select 1 from dual;
exit;
