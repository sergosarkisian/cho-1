connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool &&logPath/3.views

/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$ACTIVE_TRAN (GLOBALID, BRANCH)
AS
   SELECT X.K2GTITID_ORA GLOBALID, X.K2GTIBID BRANCH
     FROM SYS.X$K2GTE2 X
    WHERE X.K2GTIFMT = 1234;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$LOCK_TBL
(
   OWNER,
   OBJECT_NAME,
   GLOBALID,
   CTIME,
   MODE_HELD,
   MODE_REQUESTED,
   BLOCKING_OTHERS
)
AS
     SELECT OB.OWNER,
            OB.OBJECT_NAME,
            G.K2GTITID_ORA GLOBALID,
            L.CTIME,
            DECODE (LMODE,
                    0, 'None',
                    1, 'Null',
                    2, 'Row-S (SS)',
                    3, 'Row-X (SX)',
                    4, 'Share',
                    5, 'S/Row-X (SSX)',
                    6, 'Exclusive',
                    TO_CHAR (LMODE))
               MODE_HELD,
            DECODE (REQUEST,
                    0, 'None',
                    1, 'Null',
                    2, 'Row-S (SS)',
                    3, 'Row-X (SX)',
                    4, 'Share',
                    5, 'S/Row-X (SSX)',
                    6, 'Exclusive',
                    TO_CHAR (REQUEST))
               MODE_REQUESTED,
            DECODE (BLOCK,
                    0, 'Not Blocking',
                    1, 'Blocking',
                    2, 'Global',
                    TO_CHAR (BLOCK))
               BLOCKING_OTHERS
       FROM (SELECT INST_ID,
                    ADDR LADDR,
                    KSQLKADR KADDR,
                    KSQLKSES SADDR,
                    KSQLKRES RADDR,
                    KSQLKMOD LMODE,
                    KSQLKREQ REQUEST,
                    KSQLKCTIM CTIME,
                    KSQLKLBLK BLOCK,
                    KSSOBOWN,
                    KTADMTAB
               FROM SYS.X$KTADM) L, SYS.DBA_OBJECTS OB, SYS.X$K2GTE2 G
      WHERE     L.KTADMTAB = OB.OBJECT_ID
            AND L.KSSOBOWN = G.K2GTDXCB
            AND G.K2GTDXCB != '00'
   ORDER BY CTIME DESC;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$PK
(
   TABLE_NAME,
   COLUMN_NAME,
   POSITION
)
AS
   SELECT o.name TABLE_NAME, col.name COLUMN_NAME, cc.pos# POSITION
     FROM sys.obj$ o,
          sys.cdef$ c,
          sys.ccol$ cc,
          sys.col$ col
    WHERE     c.obj# = o.obj#
          AND CC.CON# = C.CON#
          AND cc.obj# = col.obj#
          AND cc.intcol# = col.intcol#
          AND o.owner# = USERENV ('SCHEMAID')
          AND c.type# = 2                                        /* pk only */
;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$PROCEDURES (PGGNAME, PROCEDURENAME)
AS
   SELECT o.name PGGNAME, pi.procedurename
     FROM sys.obj$ o JOIN sys.procedureinfo$ pi ON pi.obj# = o.obj#
    WHERE o.owner# = SYS_CONTEXT ('USERENV', 'CURRENT_USERID');


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$TAB_IDX
(
   TABLE_NAME,
   CONSTRAINT_NAME,
   COLUMN_NAME,
   POSITION,
   OWNER#
)
AS
     SELECT o.name TABLE_NAME,
            c.name CONSTRAINT_NAME,
            DECODE (ac.name, NULL, col.name, ac.name) COLUMN_NAME,
            cc.pos# POSITION,
            C.owner#
       FROM sys.con$ c,
            sys.col$ col,
            sys.ccol$ cc,
            sys.cdef$ cd,
            sys.obj$ o,
            sys.attrcol$ ac
      WHERE     c.con# = cd.con#
            AND cd.type# IN (2, 3)
            AND cd.con# = cc.con#
            AND cc.obj# = col.obj#
            AND cc.intcol# = col.intcol#
            AND cc.obj# = o.obj#
            --    and c.owner# = userenv('SCHEMAID')
            AND col.obj# = ac.obj#(+)
            AND col.intcol# = ac.intcol#(+)
   ORDER BY constraint_name, position;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$TAB_IDX_COLS
(
   TABLE_NAME,
   INDEX_NAME,
   COLUMN_NAME,
   POSITION,
   OWNER#
)
AS
     SELECT base.name TABLE_NAME,
            idx.name INDEX_NAME,
            DECODE (ac.name, NULL, c.name, ac.name) COLUMN_NAME,
            ic.pos# POSITION,
            base.owner#
       FROM sys.COL$ c,
            sys.OBJ$ idx,
            sys.OBJ$ base,
            sys.ICOL$ ic,
            sys.IND$ i,
            sys.ATTRCOL$ ac
      WHERE c.obj# = base.obj# AND ic.bo# = base.obj#
            AND DECODE (BITAND (i.property, 1024), 0, ic.intcol#, ic.spare2) =
                   c.intcol#
            --                                and base.owner# = userenv('SCHEMAID')
            AND base.namespace = 1
            AND ic.obj# = idx.obj#
            AND idx.obj# = i.obj#
            AND i.type# IN (1, 2, 3, 4, 6, 7, 9)
            AND c.obj# = ac.obj#(+)
            AND c.intcol# = ac.intcol#(+)
   ORDER BY index_name, position;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$TAB_IDX_FK
(
   PK_UK_CONSTRAINT,
   FK_CONSTRAINT,
   OWNER#,
   TABLE_NAME,
   COLUMN_NAME,
   POSITION,
   CASCADE
)
AS
     SELECT rc.name PK_UK_CONSTRAINT,
            c.name FK_CONSTRAINT,
            c.owner#,
            o.name TABLE_NAME,
            DECODE (ac.name, NULL, col.name, ac.name) COLUMN_NAME,
            cc.pos# POSITION,
            DECODE (cd.REFACT, 1, 1, 0) CASCADE
       FROM sys.user$ u,
            sys.con$ c,
            sys.col$ col,
            sys.ccol$ cc,
            sys.cdef$ cd,
            sys.obj$ o,
            sys.attrcol$ ac,
            sys.con$ rc,
            sys.obj$ o2
      WHERE     c.owner# = u.user#
            AND c.con# = cd.con#
            AND cd.type# = 4
            AND cd.rcon# = rc.con#
            AND cd.con# = cc.con#
            AND cc.obj# = col.obj#
            AND cc.intcol# = col.intcol#
            AND cc.obj# = o.obj#
            --    and c.owner# = userenv('SCHEMAID')
            AND col.obj# = ac.obj#(+)
            AND col.intcol# = ac.intcol#(+)
            AND o2.obj# = cd.ROBJ#
   ORDER BY pk_uk_constraint, fk_constraint, position;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$TAB_IDX_PB (TEXT, OWNER#)
AS
     SELECT s.source TEXT, O.owner#
       FROM sys.obj$ o, sys.source$ s
      WHERE o.obj# = s.obj# AND o.type# = 11
   --  and o.owner# = userenv('SCHEMAID')
   ORDER BY NAME, LINE;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$TRANSACTIONS
(
   GLOBALID,
   USERNAME,
   TRNUM,
   TRNAME,
   INST_ID,
   FORMATID,
   BRANCHID,
   BRANCHES,
   REFCOUNT,
   PREPARECOUNT,
   STATE,
   FLAGS,
   COUPLING
)
AS
   SELECT GLOBALID,
          SUBSTR (SUBSTR (T.GLOBALID, 1, INSTR (T.GLOBALID, '.') - 1), 1, 35)
             USERNAME,
          SUBSTR (SUBSTR (T.GLOBALID, INSTR (T.GLOBALID, '.') + 1), 1, 5)
             TRNUM,
          TRNAME,
          INST_ID,
          FORMATID,
          BRANCHID,
          BRANCHES,
          REFCOUNT,
          PREPARECOUNT,
          STATE,
          FLAGS,
          COUPLING
     FROM (SELECT TRIM (
                     TRANSLATE (SUBSTR (GLOBALID, LENGTH (USER) + 2),
                                CHR (0),
                                ' '))
                     GLOBALID,
                  TRIM (
                     TRANSLATE (SYS.UTL_RAW.CAST_TO_VARCHAR2 (GLOBALID),
                                CHR (0),
                                ' '))
                     TRNAME,
                  INST_ID,
                  FORMATID,
                  BRANCHID,
                  BRANCHES,
                  REFCOUNT,
                  PREPARECOUNT,
                  STATE,
                  FLAGS,
                  COUPLING
             FROM (SELECT SYS.UTL_RAW.CAST_TO_VARCHAR2 (v.GLOBALID) GLOBALID,
                          v.INST_ID,
                          v.FORMATID,
                          v.BRANCHID,
                          v.BRANCHES,
                          v.REFCOUNT,
                          v.PREPARECOUNT,
                          v.STATE,
                          v.FLAGS,
                          v.COUPLING
                     FROM SYS.GV_$GLOBAL_TRANSACTION v
                    WHERE FORMATID = 1234)
            WHERE GLOBALID LIKE USER || '%') T;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$TRANSACTIONS2
(
   TRNAME,
   INST_ID,
   FORMATID,
   GLOBALID,
   BRANCHID,
   BRANCHES,
   REFCOUNT,
   PREPARECOUNT,
   STATE,
   FLAGS,
   COUPLING
)
AS
   SELECT TRIM (
             TRANSLATE (SYS.UTL_RAW.CAST_TO_VARCHAR2 (T.GLOBALID),
                        CHR (0),
                        ' '))
             TRNAME,
          t."INST_ID",
          t."FORMATID",
          t."GLOBALID",
          t."BRANCHID",
          t."BRANCHES",
          t."REFCOUNT",
          t."PREPARECOUNT",
          t."STATE",
          t."FLAGS",
          t."COUPLING"
     FROM SYS.GV_$GLOBAL_TRANSACTION T
    WHERE T.FORMATID = 1235;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$WHO_LOCK_ME
(
   GLOBALID,
   LOCALID
)
AS
   SELECT TRANSLATE (gt.K2GTITID_ORA, '+' || CHR (0), '+') GLOBALID,
             TRUNC (h.p2 / POWER (2, 16))
          || '.'
          || (BITAND (h.p2, POWER (2, 16) - 1) + 0)
          || '.'
          || h.p3
             LOCALID
     FROM gv$session_wait_history h
          JOIN x$ktcxb lt
             ON     lt.KXIDUSN = TRUNC (h.p2 / POWER (2, 16))
                AND lt.KXIDSLT = BITAND (h.p2, POWER (2, 16) - 1) + 0
                AND lt.KXIDSQN = h.p3
          JOIN x$k2gte2 gt
             ON gt.k2gtdxcb = lt.KTCXBXBA
    WHERE     h.Inst_ID = USERENV ('INSTANCE')
          AND h.SID = USERENV ('SID')
          AND h.event# = 188;


/* Formatted on 3/14/2012 10:01:23 AM (QP5 v5.139.911.3011) */
CREATE OR REPLACE FORCE VIEW SYS.TT$WHO_LOCK_SOMEONE
(
   SID,
   USERNAME,
   OSUSER,
   MACHINE,
   LOCKWAIT,
   BLOCKING_SESSION,
   TADDR,
   ROW_WAIT_OBJ#,
   WAITROW,
   WAIT_FOR_GLOBALID
)
AS
   SELECT SE.SID,
          SE.USERNAME,
          SE.OSUSER,
          SE.MACHINE,
          SE.LOCKWAIT,
          SE.BLOCKING_SESSION,
          SE.TADDR,
          SE.ROW_WAIT_OBJ#,
          DBMS_ROWID.rowid_create (1,
                                   SE.ROW_WAIT_OBJ#,
                                   SE.ROW_WAIT_FILE#,
                                   SE.ROW_WAIT_BLOCK#,
                                   SE.ROW_WAIT_ROW#)
             waitrow,
          TRANSLATE (gt.K2GTITID_ORA, '+' || CHR (0), '+') WAIT_FOR_GLOBALID
     FROM V$SESSION SE
          JOIN x$ktcxb lt
             ON     lt.KXIDUSN = TRUNC (se.p2 / POWER (2, 16))
                AND lt.KXIDSLT = BITAND (se.p2, POWER (2, 16) - 1) + 0
                AND lt.KXIDSQN = se.p3
          JOIN x$k2gte2 gt
             ON gt.k2gtdxcb = lt.KTCXBXBA
    WHERE SE.LOCKWAIT IS NOT NULL;

spool off
