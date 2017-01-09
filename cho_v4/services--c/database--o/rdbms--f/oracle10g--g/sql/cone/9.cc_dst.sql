connect "E$&&scheme_uc"/"&&eschemePassword"
set echo on
spool &&logPath/9.cc_dst

drop table E$&&scheme_uc..CC_CONTENT;

CREATE DATABASE LINK cc_dst2src_dblink USING 'cc_dst2src.pool';

CREATE TABLE E$&&scheme_uc..CC_CONTENT of xmltype
    (CONSTRAINT CC_PK PRIMARY KEY(XMLDATA.CCID)
    ,CONSTRAINT CC_UK unique (XMLDATA.THEREF, XMLDATA.FORMAT, XMLDATA.MD5)
    )
    xmltype 
      XMLSCHEMA "e$cc"
      element "cc"
      varray XMLDATA.RELATIONS
	STORE AS TABLE CC_RELATION (
		( 
		  CONSTRAINT ccrel_pk PRIMARY KEY (nested_table_id, GIST, array_index)
		)
		ORGANIZATION INDEX OVERFLOW
	);   


create index E$&&scheme_uc..CCREL_REF_idx on E$&&scheme_uc..CC_RELATION(THEREF, FORMAT);
drop table V$CC_CONTENT_EXPORT_DST;
create table V$CC_CONTENT_EXPORT_DST as select to_char(data) data from V$CC_CONTENT_EXPORT@cc_dst2src_dblink;


declare
FXML  xmltype;
AOBJ  E$XML.T$CC;
begin
  for m in (
    select to_char(data) data
    from V$CC_CONTENT_EXPORT_DST
  ) loop
    FXML := xmltype(m.data, 'e$cc');
    FXML.TOOBJECT(AOBJ);
    insert into E$&&scheme_uc..CC_CONTENT(xmldata)
    select e$xml.t$cc(AOBJ.VER, AOBJ.CCID, AOBJ.THEREF, AOBJ.FORMAT, AOBJ.MIMETYPE, AOBJ.MD5, AOBJ.DEPS, AOBJ.KEEPIFVALID, AOBJ.LASTGET, AOBJ.META, AOBJ.DATA, AOBJ.relations)
    from dual;
  end loop;
  commit;
end; 
/


ALTER TABLE E$&&scheme_uc..CC_DEPEND ADD (
    CONSTRAINT CCDEPEND_CC_FK
FOREIGN KEY (CCID)
REFERENCES E$&&scheme_uc..CC_CONTENT ("XMLDATA"."CCID")
    ON DELETE CASCADE,
    CONSTRAINT CCDEPEND_FROMCC_FK
FOREIGN KEY (FROMCCID)
REFERENCES E$&&scheme_uc..CC_CONTENT ("XMLDATA"."CCID"));

    
CREATE OR REPLACE FORCE VIEW V$CC_CONTENT_EXPORT
AS
select value(C).getstringval() data from cc_content c;

spool off
