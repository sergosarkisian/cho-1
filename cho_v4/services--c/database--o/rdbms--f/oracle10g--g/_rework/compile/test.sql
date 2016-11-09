set serveroutput on;

DECLARE
  RetVal BINARY_INTEGER;
  Rt BINARY_INTEGER;
  vl BINARY_INTEGER;
  VLL BINARY_INTEGER;
  BOTH_WORDS VARCHAR2(200) := 'XXX789989XXX';
  ERRORSTR VARCHAR2(20) := '         ';
  fdt TIMESTAMP;
BEGIN
  fdt := SYSTIMESTAMP;

--  for l in (select * from X$LCKTEST l where seq<=1000 and thelock='lockID'  order by seq) loop
--  for l in (select * from X$LCKTEST l where seq<=1000 and thelock='lock6F'  order by seq) loop
-- for v in 1..160 loop
-- x$antilooptest;
  for l in (select * from X$LCKTEST l where seq<=6000  order by seq) loop
    begin
--     RetVal := EDI.KERNEL_LCK.ADD_LOCK (l.THELOCK, l.PAGE, l.LOCKDESCR, l.LOCKMODE, l.LOCKEDBY, l.TRLOCKID, ERRORSTR  );
--     RetVal := EDI.KERNEL_LCK.ADD_LOCK (l.THELOCK, l.PAGE, l.LOCKMODE, l.LOCKEDBY, l.TRLOCKID, 'FUNC1', 2, 'ARG1', 'ARG2', '', ERRORSTR  );
     vl:=l.LOCKEDBY+20;
     RetVal := EDI.KERNEL_LCK.ADD (l.THELOCK, l.PAGE, l.LOCKMODE, vl, l.TRLOCKID, 'I$ADM.WS_DESCR', 1, '0', '', '', ERRORSTR  );
--     RetVal := EDI.KERNEL_LCK.ADD_LOCK (l.THELOCK, l.PAGE, l.LOCKMODE, vl, l.TRLOCKID, 'I$ADM.WS_DESCR', 1, NULL, '', '', ERRORSTR  );
--    DBMS_OUTPUT.Put_Line(
--                  '=' || RetVal
--        );
--     RetVal := EDI.FTEST3 (BOTH_WORDS, l.PAGE, l.LOCKDESCR, l.LOCKMODE, l.LOCKEDBY, l.TRLOCKID, 64 );
    VLL:=l.seq;
    exit when RetVal = -1;
       rt:=RetVal;
    null;
        exception
          when others then null;
        end;
  end loop;
--  end loop;
    DBMS_OUTPUT.Put_Line(
                  '= SEQ' || VLL || ' LastRet= ' || RetVal || ' PrevRet= ' || rt || ' Error =' || Errorstr ||  ' Time= ' || (SYSTIMESTAMP-fdt)
        );
--    DBMS_OUTPUT.Put_Line('Debug = ' || BOTH_WORDS);
--fdt := SYSTIMESTAMP;
--EDI.KERNEL_LCK.DEL_BY(1);
--EDI.KERNEL_LCK.DEL_BY(2);
--EDI.KERNEL_LCK.DEL_BY(3);
--DBMS_OUTPUT.Put_Line('Delby time = ' || (SYSTIMESTAMP-fdt));
--EDI.KERNEL_LCK.DEL_REC(842);
END;
/
--quit
