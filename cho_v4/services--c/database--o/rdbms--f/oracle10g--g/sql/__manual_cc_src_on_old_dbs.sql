connect "E$&&scheme_uc"/"&&eschemePassword"
set echo on
spool &&logPath/8.manual_cc_src

CREATE OR REPLACE FORCE VIEW V$CC_CONTENT_EXPORT
AS
select value(C).getstringval() data from cc_content c;

spool off


connect "E$XML"/"&&exmlPassword"
set echo on
spool &&logPath/8.manual_cc_src
drop table x$types;
create table x$types (txt clob) ;
spool off


#TNS
