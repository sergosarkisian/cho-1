-CREATE SPFILE='/opt/oracle/database/{{SID}}/dbs/spfile.ora' FROM  PFILE='/opt/oracle/database/{{SID}}/dbs/init.ora';


/opt/oracle/database/{{SID}}/dbs/spfile.ora

ALTER DATABASE DATAFILE '/media/storage/database/oracle/wk10/data/main/undotbs01.dbf' RESIZE 10000M;
ALTER DATABASE DATAFILE '/media/storage/database/oracle/wk10/data/main/undotbs01.dbf' AUTOEXTEND ON  NEXT 1000M MAXSIZE UNLIMITED;











CREATE TABLESPACE E$CORE DATAFILE 
  '/media/storage/database/oracle/wk10/data/main/ecore.dbf' SIZE 5000M AUTOEXTEND ON NEXT 100M MAXSIZE 5000M
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

CREATE TABLESPACE E$TOCEAN DATAFILE 
  '/media/storage/database/oracle/wk10/data/main/etocean.dbf' SIZE 2000M AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 32K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;


##DROP TABLESPACE E$TOCEAN INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;


CREATE ROLE SESSION_MANAGER NOT IDENTIFIED;


CREATE USER CORE
  IDENTIFIED BY VALUES '5C05D80DBA3D6FC2'
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
  -- 3 Roles for E$TOCEAN 
  GRANT CONNECT TO E$TOCEAN;
  GRANT EXP_FULL_DATABASE TO E$TOCEAN;
  GRANT IMP_FULL_DATABASE TO E$TOCEAN;
  ALTER USER E$TOCEAN DEFAULT ROLE ALL;
  -- 3 System Privileges for E$TOCEAN 
  GRANT GRANT ANY PRIVILEGE TO E$TOCEAN;
  GRANT SELECT ANY TABLE TO E$TOCEAN;
  GRANT CREATE SESSION TO E$TOCEAN;
  -- 1 Object Privilege for E$TOCEAN 
    GRANT READ, WRITE ON DIRECTORY SYS.export TO E$TOCEAN;



CREATE USER E$CORE
  IDENTIFIED BY VALUES '7CD9C72DDA786401'
  DEFAULT TABLESPACE E$CORE
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
  -- 3 Roles for E$CORE 
  GRANT DBA TO E$CORE WITH ADMIN OPTION;
  GRANT CONNECT TO E$CORE WITH ADMIN OPTION;
  GRANT SELECT_CATALOG_ROLE TO E$CORE WITH ADMIN OPTION;
  ALTER USER E$CORE DEFAULT ROLE ALL;
  -- 10 System Privileges for E$CORE 
  GRANT CREATE ANY PROCEDURE TO E$CORE WITH ADMIN OPTION;
  GRANT CREATE ANY SYNONYM TO E$CORE WITH ADMIN OPTION;
  GRANT EXECUTE ANY PROCEDURE TO E$CORE;
  GRANT DROP ANY PROCEDURE TO E$CORE WITH ADMIN OPTION;
  GRANT CREATE USER TO E$CORE;
  GRANT DROP ANY SYNONYM TO E$CORE WITH ADMIN OPTION;
  GRANT ALTER USER TO E$CORE;
  GRANT UNLIMITED TABLESPACE TO E$CORE WITH ADMIN OPTION;
  GRANT CREATE ANY TABLE TO E$CORE WITH ADMIN OPTION;
  GRANT DROP USER TO E$CORE;




CREATE USER E$TOCEAN
  IDENTIFIED BY VALUES 'FC14367310CDEFAE'
  DEFAULT TABLESPACE E$TOCEAN
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
  -- 6 Roles for E$TOCEAN 
  GRANT READ, WRITE ON DIRECTORY import TO E$TOCEAN;
  GRANT READ, WRITE ON DIRECTORY export TO E$TOCEAN;  
  GRANT AQ_USER_ROLE TO E$TOCEAN WITH ADMIN OPTION;
  GRANT CONNECT TO E$TOCEAN;
  GRANT RESOURCE TO E$TOCEAN;
  GRANT CTXAPP TO E$TOCEAN;
  GRANT SESSION_MANAGER TO E$TOCEAN;
  GRANT AQ_ADMINISTRATOR_ROLE TO E$TOCEAN WITH ADMIN OPTION;
  ALTER USER E$TOCEAN DEFAULT ROLE ALL;
  -- 12 System Privileges for E$TOCEAN 
  GRANT CREATE TYPE TO E$TOCEAN;
  GRANT SELECT ANY TABLE TO E$TOCEAN;
  GRANT DEBUG CONNECT SESSION TO E$TOCEAN WITH ADMIN OPTION;
  BEGIN
SYS.DBMS_AQADM.GRANT_SYSTEM_PRIVILEGE (
  PRIVILEGE    => 'MANAGE_ANY',
  GRANTEE      => 'E$TOCEAN',
  ADMIN_OPTION => TRUE);
END;
/
  GRANT CREATE ANY VIEW TO E$TOCEAN;
  GRANT CREATE SEQUENCE TO E$TOCEAN;
  GRANT CREATE ANY TABLE TO E$TOCEAN;
  BEGIN
SYS.DBMS_AQADM.GRANT_SYSTEM_PRIVILEGE (
  PRIVILEGE    => 'ENQUEUE_ANY',
  GRANTEE      => 'E$TOCEAN',
  ADMIN_OPTION => TRUE);
END;
/
  GRANT CREATE PROCEDURE TO E$TOCEAN;
  GRANT UNLIMITED TABLESPACE TO E$TOCEAN;
  GRANT CREATE VIEW TO E$TOCEAN;
  GRANT CREATE DATABASE LINK TO E$TOCEAN;
  -- 1 Tablespace Quota for E$TOCEAN 
  ALTER USER E$TOCEAN QUOTA UNLIMITED ON E$TOCEAN;


alter user E$TOCEAN identified by "3edc4rfv";



CREATE USER E$XML
  IDENTIFIED BY VALUES '84686A394D1A623F'
  DEFAULT TABLESPACE E$CORE
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
  -- 2 Roles for E$XML 
  GRANT RESOURCE TO E$XML;
  GRANT DBA TO E$XML;
  ALTER USER E$XML DEFAULT ROLE ALL;
  -- 3 System Privileges for E$XML 
  GRANT UNLIMITED TABLESPACE TO E$XML;
  GRANT CREATE ANY TABLE TO E$XML WITH ADMIN OPTION;
  GRANT EXECUTE ANY PROCEDURE TO E$XML;



CREATE USER EDI_WEB
  IDENTIFIED BY VALUES 'B6C08CD770D872FF'
  DEFAULT TABLESPACE E$CORE
  TEMPORARY TABLESPACE TEMP
  PROFILE DEFAULT
  ACCOUNT UNLOCK;
  -- 1 Role for EDI_WEB 
  GRANT CONNECT TO EDI_WEB;
  ALTER USER EDI_WEB DEFAULT ROLE ALL;
  -- 1 System Privilege for EDI_WEB 
  BEGIN
SYS.DBMS_AQADM.GRANT_SYSTEM_PRIVILEGE (
  PRIVILEGE    => 'MANAGE_ANY',
  GRANTEE      => 'EDI_WEB',
  ADMIN_OPTION => FALSE);
END;
/



CREATE USER ZABBIX
 IDENTIFIED BY zabbix
 DEFAULT TABLESPACE USERS
 TEMPORARY TABLESPACE TEMP
 PROFILE DEFAULT
 ACCOUNT UNLOCK;
 GRANT ALTER SESSION TO ZABBIX;
 GRANT CREATE SESSION TO ZABBIX;
 GRANT CONNECT TO ZABBIX;
 ALTER USER ZABBIX DEFAULT ROLE ALL;
 GRANT SELECT ON V_$INSTANCE TO ZABBIX;
 GRANT SELECT ON DBA_USERS TO ZABBIX;
 GRANT SELECT ON V_$LOG_HISTORY TO ZABBIX;
 GRANT SELECT ON V_$PARAMETER TO ZABBIX;
 GRANT SELECT ON SYS.DBA_AUDIT_SESSION TO ZABBIX;
 GRANT SELECT ON V_$LOCK TO ZABBIX;
 GRANT SELECT ON DBA_REGISTRY TO ZABBIX;
 GRANT SELECT ON V_$LIBRARYCACHE TO ZABBIX;
 GRANT SELECT ON V_$SYSSTAT TO ZABBIX;
 GRANT SELECT ON V_$PARAMETER TO ZABBIX;
 GRANT SELECT ON V_$LATCH TO ZABBIX;
 GRANT SELECT ON V_$PGASTAT TO ZABBIX;
 GRANT SELECT ON V_$SGASTAT TO ZABBIX;
 GRANT SELECT ON V_$LIBRARYCACHE TO ZABBIX;
 GRANT SELECT ON V_$PROCESS TO ZABBIX;
 GRANT SELECT ON DBA_DATA_FILES TO ZABBIX;
 GRANT SELECT ON DBA_TEMP_FILES TO ZABBIX;
 GRANT SELECT ON DBA_FREE_SPACE TO ZABBIX;
 GRANT SELECT ON V_$SYSTEM_EVENT TO ZABBIX;






### E$XML ###

begin

  begin dbms_xmlschema.deleteschema('e$edimsg', dbms_xmlschema.delete_cascade_force); exception when others then null; end; 
  dbms_xmlschema.registerschema(
      'e$edimsg',
      --
      '<xsd:schema
           xmlns:xsd="http://www.w3.org/2001/XMLSchema"
           xmlns:xdb="http://xmlns.oracle.com/xdb"
           xdb:storeVarrayAsTable="true"
           xdb:mapUnboundedStringToLob="true"
       >
          <xsd:element name="msg" type="MSG"/>
          <xsd:element name="obj" type="OBJ"/>
          <!--           
                 msg          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="MSG" xdb:SQLType="T$EDIMSG" >
             <xsd:sequence>
               <xsd:element name="admdict"    minOccurs="0" maxOccurs="unbounded" xdb:SQLName="ADMDICTS" xdb:SQLCollType="T$ADMDICTS" type="ADMDICT" />             
               <xsd:element name="pdoc"       minOccurs="0" maxOccurs="unbounded" xdb:SQLName="PDOCS"    xdb:SQLCollType="T$PDOCS"    type="PDOC"/>
               <xsd:element name="obj"        minOccurs="0" maxOccurs="unbounded" xdb:SQLName="OBJS"     xdb:SQLCollType="T$OBJS"     type="OBJ" />             
               <xsd:element name="objgr"      minOccurs="0" maxOccurs="unbounded" xdb:SQLName="OBJGRS"   xdb:SQLCollType="T$OBJGRS"   type="OBJGR" />             
             </xsd:sequence>
             <xsd:attribute name="src" xdb:SQLName="SRC" type="C35" use="required"/>
             <xsd:attribute name="ver" xdb:SQLName="VER" type="VER" use="required"/>
          </xsd:complexType>
          <!--           
                objgr          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="OBJGR" xdb:SQLType="T$OBJGR">
             <xsd:sequence>
               <xsd:element name="obj"        minOccurs="0" maxOccurs="unbounded" xdb:SQLName="OBJS"     xdb:SQLCollType="T$OBJS"     type="OBJ" />             
             </xsd:sequence>
             <xsd:attribute name="grname"     xdb:SQLName="GRNAME" type="C15" />
          </xsd:complexType>
          <!--           
                obj          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="OBJ" xdb:SQLType="T$OBJ">
             <xsd:sequence>
               <xsd:element name="pdoc"   minOccurs="0" maxOccurs="unbounded" xdb:SQLName="PDOCS"   xdb:SQLCollType="T$PDOCS"   type="PDOC"/>
               <xsd:element name="objinh" minOccurs="0" maxOccurs="unbounded" xdb:SQLName="OBJINHS" xdb:SQLCollType="T$OBJINHS" type="OBJINH"/>
               <xsd:element name="docidx" minOccurs="0" maxOccurs="unbounded" xdb:SQLName="DOCIDXS" xdb:SQLCollType="T$DOCIDXS" type="DOCIDX"/>
               <xsd:element name="objev"  minOccurs="0" maxOccurs="unbounded" xdb:SQLName="OBJEVS"  xdb:SQLCollType="T$OBJEVS"  type="OBJEV"/>
               <xsd:element name="vars_clear" minOccurs="0" maxOccurs="1" xdb:SQLName="VARS_CLEAR" type="VARS_CLEAR" />             
               <xsd:choice>
                 <xsd:sequence>
                   <xsd:element name="doc"    minOccurs="0" maxOccurs="unbounded" xdb:SQLName="DOCS"    xdb:SQLCollType="T$DOCS"    type="DOC"/>
                   <xsd:element name="price"  minOccurs="0" maxOccurs="unbounded" xdb:SQLName="PRICES"  xdb:SQLCollType="T$PRICES"  type="PRICE"/>
                 </xsd:sequence>
                 <xsd:element name="jevent"    minOccurs="0" maxOccurs="1"         xdb:SQLName="JEVENT"     type="JEVENT"/>
                 <xsd:element name="crgparcel" minOccurs="0" maxOccurs="1"         xdb:SQLName="CRGPARCEL"  type="CRGPARCEL"/>
                 <xsd:element name="crglink"   minOccurs="0" maxOccurs="1"         xdb:SQLName="CRGLINK"    type="CRGLINK"/>
                 <xsd:element name="crgaction" minOccurs="0" maxOccurs="1"         xdb:SQLName="CRGACTION"  type="CRGACTION"/>
               </xsd:choice>
             </xsd:sequence>
             <xsd:attribute name="op"         xdb:SQLName="OP"         type="OP"    />
             <xsd:attribute name="syncby"     xdb:SQLName="SYNCBY"     type="C35"   />
             <xsd:attribute name="objid"      xdb:SQLName="OBJID"      type="N10"   />
             <xsd:attribute name="ws"         xdb:SQLName="WS"         type="N10"   />
             <xsd:attribute name="objtype"    xdb:SQLName="OBJTYPE"    type="C1"    />
             <xsd:attribute name="sconst"     xdb:SQLName="SCONST"     type="C35"   />
             <xsd:attribute name="srcid"      xdb:SQLName="SRCID"      type="C4000" />
             <xsd:attribute name="objid2var"  xdb:SQLName="OBJID2VAR"  type="C35"   />
             <xsd:attribute name="docidxpref" xdb:SQLName="DOCIDXPREF">
                <xsd:simpleType>
                   <xsd:list itemType="C15"/>
                </xsd:simpleType>
             </xsd:attribute>            
             <xsd:attribute name="fltgrants"  xdb:SQLName="FLTGRANTS"  type="FLTGRANTS" default="A" />
          </xsd:complexType>
          <!--           
                pdoc           
          -->
          <xsd:complexType xdb:maintainDOM="false" name="PDOC" xdb:SQLType="T$PDOC">
             <xsd:sequence>
               <xsd:element name="objinh" minOccurs="0" maxOccurs="unbounded"  xdb:SQLName="OBJINHS" xdb:SQLCollType="T$OBJINHS" type="OBJINH"/>
               <xsd:element name="docid"  minOccurs="0" maxOccurs="unbounded"  xdb:SQLName="DOCIDS"  xdb:SQLCollType="T$N10S" type="N10"/>
             </xsd:sequence>         
             <xsd:attribute name="docid"        xdb:SQLName="DOCID"        type="N10"                          />
             <xsd:attribute name="sconst"       xdb:SQLName="SCONST"       type="C35"                          />
             <xsd:attribute name="slot"         xdb:SQLName="SLOT"         type="N10"         use="required"   />
             <xsd:attribute name="pslot"        xdb:SQLName="PSLOT"        type="N10"                          />
             <xsd:attribute name="pslot_idx"    xdb:SQLName="PSLOT_IDX"    type="N10"         use="prohibited" />
             <xsd:attribute name="recent"       xdb:SQLName="RECENT"       type="N10"                          />
             <xsd:attribute name="unique_grand" xdb:SQLName="UNIQUE_GRAND" type="xsd:boolean"                  />
             <xsd:attribute name="syncby"       xdb:SQLName="SYNCBY"       type="C35"                          />
             <xsd:attribute name="nocalc"       xdb:SQLName="NOCBLT"       type="xsd:boolean" use="prohibited" />
             <xsd:attribute name="sync"         xdb:SQLName="SYNC"         type="N1"                           />
             <xsd:attribute name="op"           xdb:SQLName="OP"           type="OP"                           />
             <xsd:attribute name="theone4other" xdb:SQLName="THEONE4OTHER" type="xsd:boolean"                  />
             <xsd:attribute name="remove_other" xdb:SQLName="REMOVE_OTHER" type="xsd:boolean"                  />
             <xsd:attribute name="srcid"        xdb:SQLName="SRCID"        type="C4000"                        />
             <xsd:attribute name="getvar"       xdb:SQLName="GETVAR"       type="C35"                          />
             <xsd:attribute name="trfid"        xdb:SQLName="TRFID"        type="N5"                           />
          </xsd:complexType>
          <!--           
                jevent          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="JEVENT" xdb:SQLType="T$JEVENT">
             <xsd:sequence>
               <xsd:element name="transport" minOccurs="0" maxOccurs="unbounded"  xdb:SQLName="TRANSPORTS" xdb:SQLCollType="T$TRANSPORTS" type="TRANSPORT"/>
             </xsd:sequence>         
             <xsd:attribute name="jtype" xdb:SQLName="JTYPE" type="N10"/>
             <xsd:attribute name="add_name" xdb:SQLName="ADD_NAME" type="C35"/>
             <xsd:attribute name="skip" xdb:SQLName="SKIP" type="xsd:boolean"/>
             <xsd:attribute name="comments" xdb:SQLName="COMMENTS" type="CLOB"/>
             <xsd:attribute name="systype" xdb:SQLName="SYSTYPE" type="C35"/>
          </xsd:complexType>
          <!--           
                transport
          -->           
          <xsd:complexType xdb:maintainDOM="false" name="TRANSPORT" xdb:SQLType="T$TRANSPORT">
             <xsd:sequence>
               <xsd:element name="pdoc"   minOccurs="0" maxOccurs="unbounded" xdb:SQLName="PDOCS"   xdb:SQLCollType="T$PDOCS"   type="PDOC"/>
               <xsd:element name="objinh" minOccurs="0" maxOccurs="unbounded" xdb:SQLName="OBJINHS" xdb:SQLCollType="T$OBJINHS" type="OBJINH"/>
             </xsd:sequence>
             <xsd:attribute name="objid"    xdb:SQLName="OBJID" type="N10"/>
             <xsd:attribute name="syncby"   xdb:SQLName="SYNCBY" type="C35"/>
             <xsd:attribute name="op"       xdb:SQLName="OP" type="OP"/>
             <xsd:attribute name="ws"       xdb:SQLName="WS" type="N10"/>
             <xsd:attribute name="idt"      xdb:SQLName="IDT" type="DATETIME"/>
             <xsd:attribute name="odt"      xdb:SQLName="ODT" type="DATETIME"/>
          </xsd:complexType>
          <!--           
                doc          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="DOC" xdb:SQLType="T$DOC">
             <xsd:sequence>
               <xsd:element name="objinh"  minOccurs="0" maxOccurs="unbounded"  xdb:SQLName="OBJINHS"  xdb:SQLCollType="T$OBJINHS"  type="OBJINH"/>
               <xsd:element name="content" minOccurs="0" maxOccurs="unbounded"  xdb:SQLName="CONTENTS" xdb:SQLCollType="T$CONTENTS" type="CONTENT"/>
             </xsd:sequence>         
             <xsd:attribute name="docid"    xdb:SQLName="DOCID" type="N10"/>
             <xsd:attribute name="dgid"     xdb:SQLName="DGID" type="N10"/>
             <xsd:attribute name="doc_name" xdb:SQLName="DOC_NAME" type="C70"/>
             <xsd:attribute name="lng"      xdb:SQLName="LNG" type="C2"/>
             <xsd:attribute name="systype"  xdb:SQLName="SYSTYPE" type="C35"/>
             <xsd:attribute name="op"       xdb:SQLName="OP" type="OP"/>
          </xsd:complexType>
          <!--           
                content
          -->
          <xsd:complexType xdb:maintainDOM="false" name="CONTENT" xdb:SQLType="T$CONTENT">
             <xsd:simpleContent>
               <xsd:extension base="xsd:string">
                 <xsd:attribute name="systype"     xdb:SQLName="SYSTYPE"      type="C35"   />
                 <xsd:attribute name="cnttid"      xdb:SQLName="CNTTID"       type="N10"   />
                 <xsd:attribute name="briefparams" xdb:SQLName="BRIEFPARAMS"  type="C15"   />
               </xsd:extension>
             </xsd:simpleContent>
          </xsd:complexType>
          <!--           
                objev
          -->
          <xsd:complexType xdb:maintainDOM="false" name="OBJEV" xdb:SQLType="T$OBJEV">
             <xsd:attribute name="evtype"      xdb:SQLName="EVTYPE"       type="N10"      />
             <xsd:attribute name="systype"     xdb:SQLName="SYSTYPE"      type="C35"      />
             <xsd:attribute name="edt"         xdb:SQLName="EDT"          type="DATETIME" />
             <xsd:attribute name="adt"         xdb:SQLName="ADT"          type="DATETIME" />
          </xsd:complexType>
          <!--           
                docidx
          -->
          <xsd:complexType xdb:maintainDOM="false" name="DOCIDX" xdb:SQLType="T$DOCIDX">
             <xsd:attribute name="srcid"       xdb:SQLName="SRCID"        type="C15"      use="required" />
             <xsd:attribute name="word"        xdb:SQLName="WORD"         type="C70"      use="required" />
             <xsd:attribute name="spec"        xdb:SQLName="SPEC"         type="C15"       />
          </xsd:complexType>
          <!--           
                objinh          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="OBJINH" xdb:SQLType="T$OBJINH">
             <xsd:sequence>
               <xsd:element name="valueid" minOccurs="0" maxOccurs="1" xdb:SQLName="VALUE" type="ADMDICT"/>
               <xsd:element name="valuestr" minOccurs="0" maxOccurs="1" xdb:SQLName="VALUESTRLONG" type="CLOB"/>
               <xsd:element name="attrid" minOccurs="0" maxOccurs="1" xdb:SQLName="ATTR" type="ADMDICT"/>
               <xsd:element name="addr" minOccurs="0" maxOccurs="1" xdb:SQLName="ADDR" type="ADDR"/>
               <xsd:any minOccurs="0" maxOccurs="1" processContents="skip" xdb:SQLName="XMLDATA" xdb:SQLType="CLOB"/>
             </xsd:sequence>
             <!-- -->     
             <xsd:attribute name="attrid"   xdb:SQLName="ATTRID"   type="N10"   />
             <xsd:attribute name="systype"  xdb:SQLName="SYSTYPE"  type="C35"   />
             <xsd:attribute name="dtype"    xdb:SQLName="DTYPE"    type="C2"    default="IP"/>
             <xsd:attribute name="op"       xdb:SQLName="OP"       type="OP"/>
             <xsd:attribute name="fldtype"  xdb:SQLName="FLDTYPE"  type="FLDTYPE"   />
             <xsd:attribute name="valuestr" xdb:SQLName="VALUESTR" type="CLOB" />
             <xsd:attribute name="params"   xdb:SQLName="PARAMS"   type="C15" />
             <!-- -->               
             <xsd:attribute name="valueid"  xdb:SQLName="VALUEID"  type="N10"   />
             <xsd:attribute name="spnt_num" xdb:SQLName="SPNT_NUM" type="N10"   />
             <xsd:attribute name="addrid"   xdb:SQLName="ADDRID"   type="N10"   />
             <xsd:attribute name="xml"      xdb:SQLName="XML">
               <xsd:simpleType><xsd:restriction base="xsd:string">
                  <xsd:maxLength value="10"/>
                  <xsd:pattern value="valuestr"/>
               </xsd:restriction></xsd:simpleType>
             </xsd:attribute>
         </xsd:complexType>
          <!--           
                admdict          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="ADMDICT" xdb:SQLType="T$ADMDICT">
             <xsd:sequence>
               <xsd:element name="dictname" minOccurs="0" maxOccurs="unbounded" xdb:SQLName="DICTNAMES" xdb:SQLCollType="T$DICTNAMES" type="DICTNAME"/>
             </xsd:sequence>         
             <xsd:attribute name="atid"    xdb:SQLName="ATID"    type="N10"/>
             <xsd:attribute name="syncby"  xdb:SQLName="SYNCBY"  type="C35"/>
             <xsd:attribute name="op"      xdb:SQLName="OP"      type="OP"/>
             <xsd:attribute name="dtype"   xdb:SQLName="DTYPE"   type="C2"/>
             <xsd:attribute name="systype" xdb:SQLName="SYSTYPE" type="C35"/>
             <xsd:attribute name="ws"      xdb:SQLName="WS"      type="N10"/>
             <xsd:attribute name="getvar"  xdb:SQLName="GETVAR"  type="C35"/>
             <!-- some special attrs-->
             <xsd:attribute name="otype"   xdb:SQLName="OTYPE">
               <xsd:simpleType><xsd:restriction base="xsd:string">
                  <xsd:maxLength value="1"/>
                  <xsd:pattern value="M"/>
                  <xsd:pattern value="F"/>
                  <xsd:pattern value="E"/>
               </xsd:restriction></xsd:simpleType>
             </xsd:attribute>
             <xsd:attribute name="c5"        xdb:SQLName="C5"        type="C5"/>
             <xsd:attribute name="name1"     xdb:SQLName="NAME1"     type="C70"/>
             <xsd:attribute name="name2"     xdb:SQLName="NAME2"     type="C35"/>
             <xsd:attribute name="code1"     xdb:SQLName="CODE1"     type="C35"/>
             <xsd:attribute name="ctype"     xdb:SQLName="CTYPEID"   type="N10" />
             <xsd:attribute name="ctypeabbr" xdb:SQLName="CTYPEABBR" type="C35" />
          </xsd:complexType>
          <!--           
                dictname          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="DICTNAME" xdb:SQLType="T$DICTNAME">
             <xsd:attribute name="nametype" xdb:SQLName="NAMETYPE" type="C1"  use="required"/>
             <xsd:attribute name="lng"      xdb:SQLName="LNG"      type="C2"  use="required"/>
             <xsd:attribute name="name"     xdb:SQLName="NAME"     type="C70" use="required"/>
          </xsd:complexType>
          <!--           
                price          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="PRICE" xdb:SQLType="T$PRICE">
             <xsd:attribute name="shprid"  xdb:SQLName="SHPRID"  type="N10"/>
             <xsd:attribute name="sconst"  xdb:SQLName="SCONST"  type="C35"/>
             <xsd:attribute name="value"   xdb:SQLName="VALUE"   type="PRICEVAL" use="required"/>
          </xsd:complexType>
          <!--           
                addr          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="ADDR" xdb:SQLType="T$ADDR">
             <xsd:attribute name="addrtext"  xdb:SQLName="ADDRTEXT"  type="C350" />
             <xsd:attribute name="city"      xdb:SQLName="CITY"      type="C35"  />
             <xsd:attribute name="zip"       xdb:SQLName="ZIP"       type="C15"  />
             <xsd:attribute name="state"     xdb:SQLName="STATE"     type="C35"  />
             <xsd:attribute name="street"    xdb:SQLName="STREET"    type="C70"  />
             <xsd:attribute name="c2"        xdb:SQLName="C2"        type="C2"   />
             <xsd:attribute name="vatnumber" xdb:SQLName="VATNUMBER" type="C35"  />
          </xsd:complexType>
          <!--           
                crgparcel          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="CRGPARCEL" xdb:SQLType="T$CRGPARCEL">
             <xsd:sequence>
                <xsd:element name="ctype" minOccurs="0" maxOccurs="1" xdb:SQLName="CTYPE" type="ADMDICT"/>
             </xsd:sequence>         
             <xsd:attribute name="params"    xdb:SQLName="PARAMS"    type="C15" />
             <xsd:attribute name="ctype"     xdb:SQLName="CTYPEID"   type="N10" />
             <xsd:attribute name="ctypeabbr" xdb:SQLName="CTYPEABBR" type="C35" />
          </xsd:complexType>
          <!--           
                crgaction          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="CRGACTION" xdb:SQLType="T$CRGACTION">
             <xsd:sequence>
                <xsd:element name="ctype"  minOccurs="0" maxOccurs="1" xdb:SQLName="CTYPE"  type="ADMDICT"/>
                <xsd:element name="op"     minOccurs="0" maxOccurs="1" xdb:SQLName="OP"     type="ADMDICT"/>
                <xsd:element name="fcid"   minOccurs="0" maxOccurs="1" xdb:SQLName="FCID"   type="CRGCARGO"/>
                <xsd:element name="tcid"   minOccurs="0" maxOccurs="1" xdb:SQLName="TCID"   type="CRGCARGO"/>
             </xsd:sequence>         
             <xsd:attribute name="params"      xdb:SQLName="PARAMS"     type="C15" />
             <xsd:attribute name="ctype"       xdb:SQLName="CTYPEID"    type="N10" />
             <xsd:attribute name="ctypeabbr"   xdb:SQLName="CTYPEABBR"  type="C35" />
             <xsd:attribute name="pactid"      xdb:SQLName="PACTID"     type="N10" />
             <xsd:attribute name="pcallid"     xdb:SQLName="PCALLID"    type="N10" />
             <xsd:attribute name="op"          xdb:SQLName="OPID"       type="N10" />
             <xsd:attribute name="var2params"  xdb:SQLName="VAR2PARAMS" type="C35" />
          </xsd:complexType>
          <!--           
                crglink          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="CRGLINK" xdb:SQLType="T$CRGLINK">
             <xsd:attribute name="var2params"  xdb:SQLName="VAR2PARAMS" type="C35" />
          </xsd:complexType>
          <!--           
                crgcargo          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="CRGCARGO" xdb:SQLType="T$CRGCARGO">
             <xsd:sequence>
                <xsd:element name="ctype"  minOccurs="0" maxOccurs="1" xdb:SQLName="CTYPE"  type="ADMDICT"/>
             </xsd:sequence>          
             <xsd:attribute name="refnumber" xdb:SQLName="REFNUMBER" type="C35" />
             <xsd:attribute name="ctype"     xdb:SQLName="CTYPEID"   type="N10" />
             <xsd:attribute name="ctypeabbr" xdb:SQLName="CTYPEABBR" type="C35" />
          </xsd:complexType>
          <!--           
                vars_clear           
          -->
          <xsd:complexType xdb:maintainDOM="false" name="VARS_CLEAR" xdb:SQLType="T$VARS_CLEAR">
             <xsd:attribute name="ns"        xdb:SQLName="NS"      type="C35"  use="required" />
             <xsd:attribute name="names"     xdb:SQLName="NAMES"   type="C35"  />
          </xsd:complexType>
          <!--
                simple types
          -->
          <xsd:simpleType name="N1"><xsd:restriction base="xsd:nonNegativeInteger"><xsd:totalDigits value="1"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="N5"><xsd:restriction base="xsd:nonNegativeInteger"><xsd:totalDigits value="5"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="N10"><xsd:restriction base="xsd:nonNegativeInteger"><xsd:totalDigits value="10"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C1"><xsd:restriction base="xsd:string"><xsd:maxLength value="1"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C2"><xsd:restriction base="xsd:string"><xsd:maxLength value="2"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C3"><xsd:restriction base="xsd:string"><xsd:maxLength value="3"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C5"><xsd:restriction base="xsd:string"><xsd:maxLength value="5"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C15"><xsd:restriction base="xsd:string"><xsd:maxLength value="15"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C35"><xsd:restriction base="xsd:string"><xsd:maxLength value="35"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C70"><xsd:restriction base="xsd:string"><xsd:maxLength value="70"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C350"><xsd:restriction base="xsd:string"><xsd:maxLength value="350"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C4000"><xsd:restriction base="xsd:string"><xsd:maxLength value="4000"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="CLOB"><xsd:restriction base="xsd:string"/></xsd:simpleType>
          <xsd:simpleType name="DATETIME"><xsd:restriction base="xsd:dateTime"/></xsd:simpleType>
          <!--
                more special
          -->
          <xsd:simpleType name="VER"><xsd:restriction base="xsd:string"><xsd:maxLength value="1"/><xsd:pattern value="1"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="PRICEVAL"><xsd:restriction base="xsd:decimal"><xsd:totalDigits value="10"/><xsd:fractionDigits value="2"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="OP"><xsd:restriction base="xsd:string">
            <xsd:maxLength value="10"/>
            <xsd:pattern value="add"/>
            <xsd:pattern value="addnew"/>
            <xsd:pattern value="addupd"/>
            <xsd:pattern value="upd"/>
            <xsd:pattern value="del"/>
            <xsd:pattern value="inh"/>
            <xsd:pattern value="void"/>
          </xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="FLTGRANTS"><xsd:restriction base="xsd:string">
            <xsd:maxLength value="1"/>
            <xsd:pattern value="A"/>
            <xsd:pattern value="R"/>
            <xsd:pattern value="W"/>
            <xsd:pattern value=" "/><!-- null in db-->
          </xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="FLDTYPE"><xsd:restriction base="xsd:string">
            <xsd:maxLength value="1"/>
            <xsd:pattern value="N"/> <!-- number -->
            <xsd:pattern value="D"/> <!-- date/time -->
          </xsd:restriction></xsd:simpleType>
      </xsd:schema>',
      -- 
      false,
      true,
      false,
      false,
      owner => 'E$XML'
  );
end;









BEGIN
  begin DBMS_XMLSCHEMA.deleteschema('e$cc', DBMS_XMLSCHEMA.DELETE_CASCADE_FORCE); exception when others then null; end; 
  DBMS_XMLSCHEMA.registerschema(
      'e$cc',
      --
      '<xsd:schema
           xmlns:xsd="http://www.w3.org/2001/XMLSchema"
           xmlns:xdb="http://xmlns.oracle.com/xdb"
           xdb:storeVarrayAsTable="true"
           xdb:mapUnboundedStringToLob="true"
       >
          <xsd:element name="cc"       type="CC"/>
          <xsd:element name="depgr"    xdb:SQLName="DEPGRS"  xdb:SQLCollType="T$DEPGRS" type="DEPGR" />             
          <!--           
                 cc          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="CC" xdb:SQLType="T$CC" >
             <xsd:sequence>
               <xsd:element name="meta"     minOccurs="0" maxOccurs="1"         xdb:SQLName="META"      type="XMLDATA"/>
               <xsd:element name="data"     minOccurs="0" maxOccurs="1"         xdb:SQLName="DATA"      type="BLOB"/>
               <xsd:element name="relation" minOccurs="0" maxOccurs="unbounded" xdb:SQLName="RELATIONS" xdb:SQLCollType="T$RELATIONS"    type="RELATION" />             
             </xsd:sequence>
             <xsd:attribute name="ver"          xdb:SQLName="VER"         type="VER"  use="required"/>
             <xsd:attribute name="ccid"         xdb:SQLName="CCID"        type="N10"  use="prohibited"/>
             <xsd:attribute name="theref"       xdb:SQLName="THEREF"      type="MD5"  />
             <xsd:attribute name="format"       xdb:SQLName="FORMAT"      type="C35"  use="required"/>
             <xsd:attribute name="mimetype"     xdb:SQLName="MIMETYPE"    type="C150"  use="required"/>
             <xsd:attribute name="md5"          xdb:SQLName="MD5" />
             <xsd:attribute name="deps"         xdb:SQLName="DEPS">
                <xsd:simpleType>
                   <xsd:list itemType="SN10"/>
                </xsd:simpleType>
             </xsd:attribute>
             <xsd:attribute name="keepifvalid"  xdb:SQLName="KEEPIFVALID" type="DATETIME" xdb:SQLType="DATE" />
             <xsd:attribute name="lastget"      xdb:SQLName="LASTGET"     type="DATETIME" xdb:SQLType="DATE" use="prohibited"/>
          </xsd:complexType>
          <!--           
                relation          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="RELATION" xdb:SQLType="T$RELATION">
             <xsd:attribute name="gist"    xdb:SQLName="GIST"    type="GIST" use="required"/><!-- ? -->
             <xsd:attribute name="theref"  xdb:SQLName="THEREF"  type="MD5"  use="required"/>
             <xsd:attribute name="format"  xdb:SQLName="FORMAT"  type="C35"  use="required"/>
          </xsd:complexType>
          <!--           
                depgr          
          -->
          <xsd:complexType xdb:maintainDOM="false" name="DEPGR" xdb:SQLType="T$DEPGR">
             <xsd:sequence>
               <xsd:element name="depend" minOccurs="0" maxOccurs="unbounded" xdb:SQLName="DEPENDS" xdb:SQLCollType="T$DEPENDS" type="N10" />
             </xsd:sequence>
             <xsd:attribute name="depsmd5" xdb:SQLName="DEPSMD5" type="MD5"/>
          </xsd:complexType>
          <!--           
                xmldata          
          -->
          <xsd:complexType name="XMLDATA" xdb:SQLType="CLOB">
             <xsd:sequence>
               <xsd:any minOccurs="0" maxOccurs="unbounded" processContents="skip" />
             </xsd:sequence>
          </xsd:complexType>
          <!--
                simple types
          -->
          <xsd:simpleType name="N1"><xsd:restriction base="xsd:positiveInteger"><xsd:totalDigits value="1"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="N3"><xsd:restriction base="xsd:positiveInteger"><xsd:totalDigits value="3"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="N10"><xsd:restriction base="xsd:positiveInteger"><xsd:totalDigits value="10"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="SN10"><xsd:restriction base="xsd:integer"><xsd:totalDigits value="10"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C1"><xsd:restriction base="xsd:string"><xsd:maxLength value="1"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C2"><xsd:restriction base="xsd:string"><xsd:maxLength value="2"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C5"><xsd:restriction base="xsd:string"><xsd:maxLength value="5"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C15"><xsd:restriction base="xsd:string"><xsd:maxLength value="15"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C35"><xsd:restriction base="xsd:string"><xsd:maxLength value="35"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C70"><xsd:restriction base="xsd:string"><xsd:maxLength value="70"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="C150"><xsd:restriction base="xsd:string"><xsd:maxLength value="150"/></xsd:restriction></xsd:simpleType>          
          <xsd:simpleType name="C4000"><xsd:restriction base="xsd:string"><xsd:maxLength value="4000"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="CLOB"><xsd:restriction base="xsd:string"/></xsd:simpleType>
          <xsd:simpleType name="BLOB"><xsd:restriction base="xsd:hexBinary"/></xsd:simpleType>
          <xsd:simpleType name="DATETIME"><xsd:restriction base="xsd:dateTime"/></xsd:simpleType>
          <!--
                more special
          -->
          <xsd:simpleType name="VER"><xsd:restriction base="xsd:string"><xsd:maxLength value="1"/><xsd:pattern value="1"/></xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="GIST"><xsd:restriction base="xsd:string">
            <xsd:maxLength value="1"/>
            <xsd:pattern value="B"/>
            <xsd:pattern value="L"/>
          </xsd:restriction></xsd:simpleType>
          <xsd:simpleType name="MD5"><xsd:restriction base="xsd:string">
            <xsd:pattern value="[\da-f]{32}"/>
            <xsd:minLength value="32"/> <!-- force as char(32) -->
            <xsd:maxLength value="32"/>
          </xsd:restriction></xsd:simpleType>
      </xsd:schema>',
      -- 
      false,
      TRUE,
      FALSE,
      false,
      owner => 'E$XML'
  );
END;






### E$SYS ###



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



### E$CORE ###



drop PUBLIC SYNONYM SEQ;
CREATE PUBLIC SYNONYM SEQ FOR E$CORE.SEQ;
CREATE PUBLIC SYNONYM TABLE_NUMBER FOR E$CORE.TABLE_NUMBER;
CREATE PUBLIC SYNONYM FVDYNBND FOR E$CORE.FVDYNBND;
CREATE PUBLIC SYNONYM TABLE_FVDYNBND FOR E$CORE.TABLE_FVDYNBND;
CREATE PUBLIC SYNONYM FVDYNPARAM FOR E$CORE.FVDYNPARAM;
CREATE PUBLIC SYNONYM TABLE_FVDYNPARAM FOR E$CORE.TABLE_FVDYNPARAM;
CREATE PUBLIC SYNONYM DYNSQL2 FOR E$CORE.DYNSQL2;
CREATE PUBLIC SYNONYM UPDATE_CLOB FOR E$CORE.UPDATE_CLOB;
CREATE PUBLIC SYNONYM CHARLIST FOR E$CORE.CHARLIST;
CREATE PUBLIC SYNONYM TABLE_VARCHAR FOR E$CORE.TABLE_VARCHAR;
CREATE PUBLIC SYNONYM TOLISTSORTED FOR E$CORE.TOLISTSORTED;
CREATE PUBLIC SYNONYM TDYN_NUMBER FOR E$CORE.TDYN_NUMBER;
CREATE PUBLIC SYNONYM TDYN_VARCHAR FOR E$CORE.TDYN_VARCHAR;
CREATE PUBLIC SYNONYM TDYN_DATE FOR E$CORE.TDYN_DATE;
CREATE PUBLIC SYNONYM TOLISTDISTINCT FOR E$CORE.TOLISTDISTINCT;
CREATE PUBLIC SYNONYM XTPKNUMFLOAT FOR E$CORE.XTPKNUMFLOAT;
CREATE PUBLIC SYNONYM TINTLIST FOR E$CORE.TINTLIST;
CREATE PUBLIC SYNONYM TCHARS FOR E$CORE.TCHARS;
CREATE PUBLIC SYNONYM ABVARCHAR FOR E$CORE.ABVARCHAR;
CREATE PUBLIC SYNONYM TLOCK FOR E$CORE.TLOCK;
CREATE PUBLIC SYNONYM TLOCKS FOR E$CORE.TLOCKS;
CREATE PUBLIC SYNONYM TABLE_ABVARCHAR FOR E$CORE.TABLE_ABVARCHAR;
CREATE PUBLIC SYNONYM LNG FOR E$CORE.LNG;
CREATE PUBLIC SYNONYM VOID FOR E$CORE.VOID;
CREATE PUBLIC SYNONYM SCONST FOR E$CORE.SCONST;
CREATE PUBLIC SYNONYM ERR FOR E$CORE.ERR;
CREATE PUBLIC SYNONYM BRANCHID FOR E$CORE.BRANCHID;
CREATE PUBLIC SYNONYM LBY FOR E$CORE.LBY;
CREATE PUBLIC SYNONYM LCK FOR E$CORE.LCK;
CREATE PUBLIC SYNONYM UTL FOR E$CORE.UTL;
CREATE PUBLIC SYNONYM ADC FOR E$CORE.ADC;
CREATE PUBLIC SYNONYM C$DT FOR E$CORE.C$DT;
CREATE PUBLIC SYNONYM C$EQNUM FOR E$CORE.C$EQNUM;
CREATE PUBLIC SYNONYM C$PFLEX FOR E$CORE.C$PFLEX;
CREATE PUBLIC SYNONYM C$RNG FOR E$CORE.C$RNG;
CREATE PUBLIC SYNONYM C$SCH FOR E$CORE.C$SCH;
CREATE PUBLIC SYNONYM C$TMP FOR E$CORE.C$TMP;
CREATE PUBLIC SYNONYM CTX FOR E$CORE.CTX;
CREATE PUBLIC SYNONYM DBAU FOR E$CORE.DBAU;
CREATE PUBLIC SYNONYM LCKV FOR E$CORE.LCKV;
CREATE PUBLIC SYNONYM XMLU FOR E$CORE.XMLU;
CREATE PUBLIC SYNONYM AZ09 FOR E$CORE.AZ09;
CREATE PUBLIC SYNONYM B10 FOR E$CORE.B10;
CREATE PUBLIC SYNONYM CONST FOR E$CORE.CONST;
CREATE PUBLIC SYNONYM HS FOR E$CORE.HS;
CREATE PUBLIC SYNONYM NVL2P FOR E$CORE.NVL2P;
CREATE PUBLIC SYNONYM NVL3 FOR E$CORE.NVL3;
CREATE PUBLIC SYNONYM NZ FOR E$CORE.NZ;
CREATE PUBLIC SYNONYM TOLIST FOR E$CORE.TOLIST;
CREATE PUBLIC SYNONYM XTPKNUM FOR E$CORE.XTPKNUM;
CREATE PUBLIC SYNONYM XTPKNUMNUM FOR E$CORE.XTPKNUMNUM;
CREATE PUBLIC SYNONYM XTPKNUMVAR FOR E$CORE.XTPKNUMVAR;
CREATE PUBLIC SYNONYM XTPKVAR FOR E$CORE.XTPKVAR;
CREATE PUBLIC SYNONYM XTPKVARNUM FOR E$CORE.XTPKVARNUM;
CREATE PUBLIC SYNONYM TABLE_XTPKVARNUM FOR E$CORE.TABLE_XTPKVARNUM;
CREATE PUBLIC SYNONYM TABLE_XTPKNUMNUM FOR E$CORE.TABLE_XTPKNUMNUM;
CREATE PUBLIC SYNONYM TABLE_XTPKNUMVAR FOR E$CORE.TABLE_XTPKNUMVAR;
CREATE PUBLIC SYNONYM TABLE_XTPKVAR FOR E$CORE.TABLE_XTPKVAR;
CREATE PUBLIC SYNONYM TABLE_XTPKNUM FOR E$CORE.TABLE_XTPKNUM;
CREATE PUBLIC SYNONYM SVP_SET FOR E$CORE.SVP_SET;
CREATE PUBLIC SYNONYM KERNEL_SVP FOR E$CORE.KERNEL_SVP;
CREATE PUBLIC SYNONYM XTPKVARNUMVAR FOR E$CORE.XTPKVARNUMVAR;
CREATE PUBLIC SYNONYM TABLE_XTPKVARNUMVAR FOR E$CORE.TABLE_XTPKVARNUMVAR;
CREATE PUBLIC SYNONYM XTPKNUMNUMNUM FOR E$CORE.XTPKNUMNUMNUM;
CREATE PUBLIC SYNONYM TABLE_XTPKNUMNUMNUM FOR E$CORE.TABLE_XTPKNUMNUMNUM;
CREATE PUBLIC SYNONYM FILENAME FOR E$CORE.FILENAME;
CREATE PUBLIC SYNONYM XTPKNUMVARNUM FOR E$CORE.XTPKNUMVARNUM;
CREATE PUBLIC SYNONYM TABLE_XTPKNUMVARNUM FOR E$CORE.TABLE_XTPKNUMVARNUM;
CREATE PUBLIC SYNONYM TCMS_LNAVS FOR E$CORE.TCMS_LNAVS;
CREATE PUBLIC SYNONYM UTL_LOB FOR E$CORE.UTL_LOB;
CREATE PUBLIC SYNONYM TCMS_LNAV FOR E$CORE.TCMS_LNAV;
CREATE PUBLIC SYNONYM PLSQL_PROFILER_DATA FOR E$CORE.PLSQL_PROFILER_DATA;
CREATE PUBLIC SYNONYM PLSQL_PROFILER_UNITS FOR E$CORE.PLSQL_PROFILER_UNITS;
CREATE PUBLIC SYNONYM PLSQL_PROFILER_RUNS FOR E$CORE.PLSQL_PROFILER_RUNS;
CREATE PUBLIC SYNONYM PLSQL_PROFILER_RUNNUMBER FOR E$CORE.PLSQL_PROFILER_RUNNUMBER;
CREATE PUBLIC SYNONYM Q$ADM_PROFILER FOR E$CORE.Q$ADM_PROFILER;
CREATE PUBLIC SYNONYM UTL_JAVA FOR E$CORE.UTL_JAVA;
CREATE PUBLIC SYNONYM TABLE_TABLE_NUMBER FOR E$CORE.TABLE_TABLE_NUMBER;
CREATE PUBLIC SYNONYM TOLISTCNT FOR E$CORE.TOLISTCNT;
CREATE PUBLIC SYNONYM XTPKNUMNUMVAR FOR E$CORE.XTPKNUMNUMVAR;
CREATE PUBLIC SYNONYM TABLE_XTPKNUMNUMVAR FOR E$CORE.TABLE_XTPKNUMNUMVAR;
CREATE PUBLIC SYNONYM BLOB2CLOB FOR E$CORE.BLOB2CLOB;
CREATE PUBLIC SYNONYM CLOB2BLOB FOR E$CORE.CLOB2BLOB;
CREATE PUBLIC SYNONYM TDYNSQL FOR E$CORE.TDYNSQL;
CREATE PUBLIC SYNONYM TABLE_FVPARAM FOR E$CORE.TABLE_FVPARAM;
CREATE PUBLIC SYNONYM FVBND FOR E$CORE.FVBND;
CREATE PUBLIC SYNONYM TABLE_FVBND FOR E$CORE.TABLE_FVBND;
CREATE PUBLIC SYNONYM FVPARAMS FOR E$CORE.FVPARAMS;
CREATE PUBLIC SYNONYM TABLE_FVPARAMS FOR E$CORE.TABLE_FVPARAMS;
CREATE PUBLIC SYNONYM FVBNDS FOR E$CORE.FVBNDS;
CREATE PUBLIC SYNONYM TABLE_FVBNDS FOR E$CORE.TABLE_FVBNDS;
CREATE PUBLIC SYNONYM FVPARAM FOR E$CORE.FVPARAM;
CREATE PUBLIC SYNONYM DYNSQL FOR E$CORE.DYNSQL;
CREATE PUBLIC SYNONYM TABLE_XTPKNUMFLOAT FOR E$CORE.TABLE_XTPKNUMFLOAT;
CREATE PUBLIC SYNONYM D09 FOR E$CORE.D09;
CREATE PUBLIC SYNONYM BASE64 FOR E$CORE.BASE64;
CREATE PUBLIC SYNONYM XTPKNUMNUMNUMNUM FOR E$CORE.XTPKNUMNUMNUMNUM;
CREATE PUBLIC SYNONYM XTPKVARVAR FOR E$CORE.XTPKVARVAR;
CREATE PUBLIC SYNONYM TABLE_XTPKVARVAR FOR E$CORE.TABLE_XTPKVARVAR;
CREATE PUBLIC SYNONYM SVP FOR E$CORE.KERNEL_SVP;
CREATE PUBLIC SYNONYM TABLE_VARCHAR FOR E$CORE.TABLE_VARCHAR;
CREATE PUBLIC SYNONYM TPARAMS FOR E$CORE.TABLE_VARCHAR;

CREATE OR REPLACE TYPE E$CORE.TABLE_VARCHAR AS TABLE OF VARCHAR2(8000);


CREATE OR REPLACE CONTEXT E$CORE USING E$CORE.CTX ACCESSED GLOBALLY;
CREATE OR REPLACE CONTEXT E$CORE$LBY USING E$CORE.LBY;


### E$SYS ###


CREATE OR REPLACE PROCEDURE SYS.RESET_ALL_PACKAGES IS
BEGIN
  DBMS_SESSION.RESET_PACKAGE;
END RESET_ALL_PACKAGES;




#########
 EXPORT
#########

col curscn format 99999999999999999999999
select to_char(dbms_flashback.get_system_change_number,'xxxxxxxxxxxxxxxxxxxxxx'),
dbms_flashback.get_system_change_number curscn from dual;

expdp SYSTEM schemas=E\$CORE directory=export FLASHBACK_SCN=42059512286 dumpfile=ecore_new.dump logfile=ecore_new.dump.log
expdp SYSTEM schemas=E\$TOCEAN directory=export FLASHBACK_SCN=33497565554 dumpfile=etocean.dump logfile=etocean.dump.log

#export NLS_LANG=AMERICAN_AMERICA.AL32UTF8; imp system BUFFER=10000000 RECORDLENGTH=64000 file=tocean_cc_21.06.dump3 FROMUSER=E\$TOCEAN TOUSER=E\$TOCEAN 
#export NLS_LANG=AMERICAN_AMERICA.AL32UTF8; time exp USERID=E\$TOCEAN BUFFER=10000000 RECORDLENGTH=64000 DIRECT=yes file=/media/storage/database/oracle/wk10/devel/export/tocean_cc_21.06.dump3
###cc_content

### LOGIN AS E$TOCEAN ###
create view v$cc_content_export as
select C.xmldata from cc_content c









#########
 IMPORT
#########
## DROP VIEWS, PACKAGES, SEQUENCE, TYPE, !!!!!

impdp SYSTEM schemas=E\$CORE directory=export dumpfile=ecore.dump logfile=ecore.import.log table_exists_action=replace
impdp SYSTEM schemas=E\$TT directory=export dumpfile=etocean.dump logfile=etocean.import.log table_exists_action=replace


#SCHEMA & TBS remap
#  impdp SYSTEM schemas=E\$EPN directory=import dumpfile=02.08_eepn.dump logfile=eepn.import.log remap_schema=E\$EPN:E\$WEB REMAP_TABLESPACE=E\$EPN:E\$WEB
impdp E\$TT schemas=E\$MANN directory=import dumpfile=mann_22.04.16.dump logfile=bws_to_alc.import.log remap_schema=E\$MANN:E\$TT REMAP_TABLESPACE=E\$MANN:E\$TT

drop table E$TOCEAN.cc_content



#####login as E$XML#####



#if OID problem - drop all of types owned by E$XML



#####login as E$TOCEAN#####

drop table cc_content;

CREATE DATABASE LINK xml_content_link_source
USING 'source.WORLD';
 
CREATE DATABASE LINK xml_content_link_me
USING 'me.WORLD';


CREATE TABLE E$TOCEAN.CC_CONTENT of xmltype
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


    create index E$TOCEAN.CCREL_REF_idx on E$TOCEAN.CC_RELATION(THEREF, FORMAT);


/* old schema */

CREATE OR REPLACE FORCE VIEW V$CC_CONTENT_EXPORT
AS
select value(C).getstringval() data from cc_content c;




/* new schema */

create table V$CC_CONTENT_EXPORT_DST as select to_char(data) data from V$CC_CONTENT_EXPORT@xml_content_link_source;


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
    insert into CC_CONTENT(xmldata)
    select e$xml.t$cc(AOBJ.VER, AOBJ.CCID, AOBJ.THEREF, AOBJ.FORMAT, AOBJ.MIMETYPE, AOBJ.MD5, AOBJ.DEPS, AOBJ.KEEPIFVALID, AOBJ.LASTGET, AOBJ.META, AOBJ.DATA, AOBJ.relations)
    from dual;
  end loop;
  commit;
end; 
/


    ALTER TABLE E$TOCEAN.CC_DEPEND ADD (
      CONSTRAINT CCDEPEND_CC_FK
    FOREIGN KEY (CCID)
    REFERENCES E$TOCEAN.CC_CONTENT ("XMLDATA"."CCID")
	ON DELETE CASCADE,
      CONSTRAINT CCDEPEND_FROMCC_FK
    FOREIGN KEY (FROMCCID)
    REFERENCES E$TOCEAN.CC_CONTENT ("XMLDATA"."CCID"));





  -- 45 Object Privileges for E$CORE 
    GRANT EXECUTE ON CTXSYS.CTX_DDL TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.DBA_APPLY TO E$CORE;
    GRANT SELECT ON SYS.DBA_APPLY_ERROR TO E$CORE;
    GRANT SELECT ON SYS.DBA_CAPTURE TO E$CORE;
    GRANT SELECT ON SYS.DBA_OBJECTS TO E$CORE;
    GRANT SELECT ON SYS.DBA_PROCEDURES TO E$CORE WITH GRANT OPTION;
    GRANT SELECT, UPDATE ON SYS.DBA_PROPAGATION TO E$CORE;
    GRANT SELECT ON SYS.DBA_QUEUE_SCHEDULES TO E$CORE;
    GRANT SELECT ON SYS.DBA_SOURCE TO E$CORE WITH GRANT OPTION;
    GRANT SELECT, UPDATE ON SYS.DBA_STREAMS_TABLE_RULES TO E$CORE;
    GRANT SELECT ON SYS.DBA_SYNONYMS TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.DBA_TABLES TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.DBA_TYPES TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.DBA_VIEWS TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_APPLY_ADM TO E$CORE;
    GRANT EXECUTE ON SYS.DBMS_AQ TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_AQADM TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_AQ_BQVIEW TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_CAPTURE_ADM TO E$CORE;
    GRANT EXECUTE ON SYS.DBMS_CRYPTO TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_FLASHBACK TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_LOB TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_LOCK TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_PROPAGATION_ADM TO E$CORE;
    GRANT EXECUTE ON SYS.DBMS_RANDOM TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_RLS TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_RULE_ADM TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_SESSION TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_STREAMS_ADM TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_SYSTEM TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_UTILITY TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.GV_$GLOBAL_TRANSACTION TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.RESET_ALL_PACKAGES TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$LOCK_TBL TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$PK TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$PROCEDURES TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$TAB_IDX_COLS TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$TRANSACTIONS TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$TRANSACTIONS2 TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$WHO_LOCK_ME TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$WHO_LOCK_SOMEONE TO E$CORE WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.UTL_RAW TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.V_$DBLINK TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.V_$GLOBBLTONTEXT TO E$CORE WITH GRANT OPTION;
    GRANT SELECT ON SYS.V_$SESSION TO E$CORE;



  -- 51 Object Privileges for E$TOCEAN 
    GRANT EXECUTE ON CTXSYS.CTX_DDL TO E$TOCEAN;
    GRANT EXECUTE ON E$CORE.ADC TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON E$CORE.ADM_CHK_PARAM TO E$TOCEAN WITH GRANT OPTION;
    GRANT DELETE, INSERT, SELECT ON E$CORE.ADM_DEFERRED_CHECK TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.CTX TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.DYNSQL2 TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.ERR TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON E$CORE.KERNEL_LBY TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON E$CORE.KERNEL_MYLBY TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON E$CORE.KERNEL_SVP TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.LBY TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.LCK TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.LCKV TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.P$CC TO E$TOCEAN;
    GRANT DELETE, INSERT, SELECT, UPDATE ON E$CORE.PLSQL_PROFILER_DATA TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON E$CORE.PLSQL_PROFILER_RUNNUMBER TO E$TOCEAN WITH GRANT OPTION;
    GRANT DELETE, INSERT, SELECT, UPDATE ON E$CORE.PLSQL_PROFILER_RUNS TO E$TOCEAN WITH GRANT OPTION;
    GRANT DELETE, INSERT, SELECT, UPDATE ON E$CORE.PLSQL_PROFILER_UNITS TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON E$CORE.S$ADM_ADC TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON E$CORE.S$ADM_SES TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.SEQ TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.STAT_EXEC TO E$TOCEAN;
    GRANT EXECUTE ON E$CORE.TABLE_VARCHAR TO E$TOCEAN;
    GRANT EXECUTE ON E$CORE.UPDATE_CLOB TO E$TOCEAN;
    GRANT EXECUTE ON E$CORE.UTL TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON E$CORE.UTL_JAVA TO E$TOCEAN;
    GRANT EXECUTE ON E$CORE.XMLU TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_AQ TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_AQADM TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_AQ_BQVIEW TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_CRYPTO TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_FLASHBACK TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_LOB TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_LOCK TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_RANDOM TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_RLS TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_RULE_ADM TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_SESSION TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_STREAMS_ADM TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_SYSTEM TO E$TOCEAN;
    GRANT EXECUTE ON SYS.DBMS_UTILITY TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON SYS.GV_$GLOBAL_TRANSACTION TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.RESET_ALL_PACKAGES TO E$TOCEAN;
    GRANT SELECT ON SYS.TT$LOCK_TBL TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$PK TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$PROCEDURES TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$TAB_IDX_COLS TO E$TOCEAN;
    GRANT SELECT ON SYS.TT$TRANSACTIONS2 TO E$TOCEAN WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.UTL_RAW TO E$TOCEAN WITH GRANT OPTION;
    GRANT SELECT ON SYS.V_$DBLINK TO E$TOCEAN;
    GRANT SELECT ON SYS.V_$GLOBBLTONTEXT TO E$TOCEAN;




  -- 31 Object Privileges for E$XML 
    GRANT EXECUTE ON CTXSYS.CTX_DDL TO E$XML;
    GRANT EXECUTE ON E$CORE.P$CC TO E$XML;
    GRANT SELECT ON SYS.DBA_APPLY TO E$XML;
    GRANT SELECT ON SYS.DBA_APPLY_ERROR TO E$XML;
    GRANT SELECT ON SYS.DBA_CAPTURE TO E$XML;
    GRANT SELECT ON SYS.DBA_OBJECTS TO E$XML;
    GRANT SELECT, UPDATE ON SYS.DBA_PROPAGATION TO E$XML;
    GRANT SELECT, UPDATE ON SYS.DBA_STREAMS_TABLE_RULES TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_APPLY_ADM TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_AQADM TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_AQ_BQVIEW TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_CAPTURE_ADM TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_FLASHBACK TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_LOCK TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_PROPAGATION_ADM TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_RLS TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_RULE_ADM TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_SESSION TO E$XML WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.DBMS_STREAMS_ADM TO E$XML;
    GRANT EXECUTE ON SYS.DBMS_SYSTEM TO E$XML;
    GRANT SELECT ON SYS.GV_$GLOBAL_TRANSACTION TO E$XML WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.RESET_ALL_PACKAGES TO E$XML;
    GRANT SELECT ON SYS.TT$LOCK_TBL TO E$XML WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$PK TO E$XML WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$PROCEDURES TO E$XML WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$TAB_IDX_COLS TO E$XML;
    GRANT SELECT ON SYS.TT$TRANSACTIONS TO E$XML WITH GRANT OPTION;
    GRANT SELECT ON SYS.TT$TRANSACTIONS2 TO E$XML WITH GRANT OPTION;
    GRANT EXECUTE ON SYS.UTL_RAW TO E$XML;
    GRANT SELECT ON SYS.V_$DBLINK TO E$XML;
    GRANT SELECT ON SYS.V_$GLOBBLTONTEXT TO E$XML WITH GRANT OPTION;





  -- 98 Object Privileges for EDI_WEB 
    GRANT EXECUTE ON E$CORE.LBY TO EDI_WEB;
    GRANT EXECUTE ON E$CORE.LCKV TO EDI_WEB;
    GRANT EXECUTE ON E$CORE.SCONST TO EDI_WEB;
    GRANT EXECUTE ON E$CORE.SVP_SET TO EDI_WEB;
    GRANT EXECUTE ON E$CORE.TABLE_XTPKVARNUMVAR TO EDI_WEB;
    GRANT EXECUTE ON E$CORE.TABLE_XTPKVARVAR TO EDI_WEB;
    GRANT EXECUTE ON E$CORE.TCHARLISTTYPE TO EDI_WEB;
    GRANT EXECUTE ON E$CORE.TLOCKS TO EDI_WEB;
    GRANT SELECT ON E$CORE.V$KERNEL_TRAN TO EDI_WEB;
    GRANT EXECUTE ON E$CORE.XTPKVARNUMVAR TO EDI_WEB;
    GRANT EXECUTE ON E$CORE.XTPKVARVAR TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$AIS TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$CMPRLS TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$CORE TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$CP TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$DOC TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$EPN TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$ERR TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$GIS TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$HISTORY TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$LOG TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$NOTICE TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$PRINT TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$REG TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$SCHED TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$SSN TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$VCALL TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.A$XTEE TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.FULLNAME TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$ADM TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$BCH2 TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$CC TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$CR TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$CRI TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$DEMON TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$DICT TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$DNUM TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$DYN2 TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$ERR TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$LNG TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$MENU TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$MT TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.I$UREG TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.KERNEL TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.LNG TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.RLS TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.SCONST TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.TABLE_TOBJATTR TO EDI_WEB;
    GRANT EXECUTE ON E$TOCEAN.TOBJATTR TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_BYLIST TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_CHK_PARAM TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DEFERRED_CHECK TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICTRLS_LSS TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_CH TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_FLT TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_FLT_LIST TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_FLT_SIMPLE TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_LIST TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_LSS TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_NAME TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_NAME_FLT TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_NAME_LNG TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_DICT_TYPE TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_LOCK_TBL TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$ADM_WS TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CMS_HOST TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CMS_MIMETYPES TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CMS_SITE TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CMS_SITE_HOSTS TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CMS_SITE_LNG TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CRI_CHOBJINH_VAL TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CRI_OBJINH TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CRI_OBJINHCC TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CR_MCA TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CR_OBJ TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CR_OBJATID TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CR_OBJREL TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CR_OBJTREL TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CR_OBJTYPE TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$CR_OBJ_WS TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$DOC_INDEX TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$DOC_INH_PARAMS TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$DOC_OBJ_CH TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$LNG_LANGUAGE TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$LNG_TRANSLATE TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$MENU_FAV TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$MENU_GO TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$MT_USER TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$MT_USER_DT TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$MT_USER_HIST TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$MT_USER_SU TO EDI_WEB;
    GRANT SELECT ON E$TOCEAN.V$MT_USER_WS TO EDI_WEB;
    GRANT EXECUTE ON SYS.RESET_ALL_PACKAGES TO EDI_WEB;
    GRANT SELECT ON SYS.TT$TAB_IDX TO EDI_WEB;
    GRANT SELECT ON SYS.TT$TAB_IDX_COLS TO EDI_WEB;
    GRANT SELECT ON SYS.TT$TAB_IDX_FK TO EDI_WEB;
    GRANT SELECT ON SYS.TT$TAB_IDX_PB TO EDI_WEB;



    GRANT DELETE, INSERT, SELECT, UPDATE ON E$CORE.PLSQL_PROFILER_DATA TO SESSION_MANAGER;
    GRANT SELECT ON E$CORE.PLSQL_PROFILER_RUNNUMBER TO SESSION_MANAGER;
    GRANT DELETE, INSERT, SELECT, UPDATE ON E$CORE.PLSQL_PROFILER_RUNS TO SESSION_MANAGER;
    GRANT DELETE, INSERT, SELECT, UPDATE ON E$CORE.PLSQL_PROFILER_UNITS TO SESSION_MANAGER;
    GRANT ALTER, DELETE, INSERT, SELECT, UPDATE, ON COMMIT REFRESH, QUERY REWRITE, DEBUG, FLASHBACK ON E$CORE.TOAD_PLAN_TABLE TO SESSION_MANAGER;
    GRANT SELECT ON SYS.ALL_USERS TO SESSION_MANAGER;
    GRANT SELECT ON SYS.DBA_CONTEXT TO SESSION_MANAGER;
    GRANT SELECT ON SYS.DBA_DATA_FILES TO SESSION_MANAGER;
    GRANT SELECT ON SYS.DBA_FREE_SPACE TO SESSION_MANAGER;
    GRANT SELECT ON SYS.GV_$PROCESS TO SESSION_MANAGER;
    GRANT SELECT ON SYS.GV_$SESSION TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$ACCESS TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$EVENTMETRIC TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$EVENT_NAME TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$LOCK TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$OPEN_CURSOR TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$PARAMETER TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$PROCESS TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$ROLLNAME TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$SESSION TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$SESSION_EVENT TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$SESSION_LONGOPS TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$SESSION_WAIT TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$SESSTAT TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$SESS_IO TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$SQL TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$SQLAREA TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$SQLTEXT_WITH_NEWLINES TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$STATNAME TO SESSION_MANAGER;
    GRANT SELECT ON SYS.V_$TRANSACTION TO SESSION_MANAGER;
    GRANT ADVISOR TO SESSION_MANAGER;
    GRANT ALTER SYSTEM TO SESSION_MANAGER;
    GRANT ALTER SESSION TO SESSION_MANAGER;
    GRANT CREATE MATERIALIZED VIEW TO SESSION_MANAGER;
    GRANT SESSION_MANAGER TO SYS WITH ADMIN OPTION;
    GRANT SESSION_MANAGER TO E$TOCEAN;






    grant EXECUTE on E$CORE.TABLE_VARCHAR to PUBLIC;
    grant EXECUTE on E$CORE.TINTLIST to PUBLIC;
    grant EXECUTE on E$CORE.TCHARS to PUBLIC;
    grant EXECUTE on E$CORE.ABVARCHAR to PUBLIC;
    grant EXECUTE on E$CORE.TLOCK to PUBLIC;
    grant EXECUTE on E$CORE.TOLISTTYPE to PUBLIC;
    grant EXECUTE on E$CORE.XTPKNUM to PUBLIC;
    grant EXECUTE on E$CORE.XTPKNUMNUM to PUBLIC;
    grant EXECUTE on E$CORE.XTPKNUMVAR to PUBLIC;
    grant EXECUTE on E$CORE.XTPKVAR to PUBLIC;
    grant EXECUTE on E$CORE.XTPKVARNUM to PUBLIC;
    grant EXECUTE on E$CORE.XTPKVARNUMVAR to PUBLIC;
    grant EXECUTE on E$CORE.XTPKNUMNUMNUM to PUBLIC;
    grant EXECUTE on E$CORE.XTPKNUMVARNUM to PUBLIC;
    grant EXECUTE on E$CORE.TCMS_LNAV to PUBLIC;
    grant EXECUTE on E$CORE.XTPKNUMNUMVAR to PUBLIC;
    grant EXECUTE on E$CORE.FVBND to PUBLIC;
    grant EXECUTE on E$CORE.XTPKNUMFLOAT to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_NUMBER to PUBLIC;
    grant EXECUTE on E$CORE.FVDYNBND to PUBLIC;
    grant EXECUTE on E$CORE.FVDYNPARAM to PUBLIC;
    grant EXECUTE on E$CORE.FVPARAM to PUBLIC;
    grant EXECUTE on E$CORE.TCHARLISTTYPE to PUBLIC;
    grant EXECUTE on E$CORE.TOLISTSORTEDTYPE to PUBLIC;
    grant EXECUTE on E$CORE.TDYN_NUMBER to PUBLIC;
    grant EXECUTE on E$CORE.TDYN_VARCHAR to PUBLIC;
    grant EXECUTE on E$CORE.TDYN_DATE to PUBLIC;
    grant EXECUTE on E$CORE.TOLISTDISTINCTTYPE to PUBLIC;
    grant EXECUTE on E$CORE.XTPKNUMNUMNUMNUM to PUBLIC;
    grant EXECUTE on E$CORE.XTPKVARVAR to PUBLIC;
    grant EXECUTE on E$CORE.TLOCKS to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_ABVARCHAR to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKNUM to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKNUMNUM to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKNUMVAR to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKVAR to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKVARNUM to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKVARNUMVAR to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKNUMNUMNUM to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKNUMVARNUM to PUBLIC;
    grant EXECUTE on E$CORE.TCMS_LNAVS to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKNUMNUMVAR to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_FVBND to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKNUMFLOAT to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_FVDYNBND to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_FVDYNPARAM to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_FVPARAM to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_XTPKVARVAR to PUBLIC;
    grant EXECUTE on E$CORE.TABLE_TABLE_NUMBER to PUBLIC;
    grant EXECUTE on E$CORE.TOLISTCNTTYPE to PUBLIC;
    grant EXECUTE on E$CORE.BASE64 to PUBLIC;
    grant EXECUTE on E$CORE.C$DT to PUBLIC;
    grant EXECUTE on E$CORE.C$EQNUM to PUBLIC;
    grant EXECUTE on E$CORE.C$PFLEX to PUBLIC;
    grant EXECUTE on E$CORE.C$RNG to PUBLIC;
    grant EXECUTE on E$CORE.C$SCH to PUBLIC;
    grant EXECUTE on E$CORE.C$TMP to PUBLIC;
    grant EXECUTE on E$CORE.DBAU to PUBLIC;
    grant EXECUTE on E$CORE.ERR to PUBLIC;
    grant EXECUTE on E$CORE.UTL_LOB to PUBLIC;
    grant EXECUTE on E$CORE.AZ09 to PUBLIC;
    grant EXECUTE on E$CORE.B10 to PUBLIC;
    grant EXECUTE on E$CORE.BLOB2CLOB to PUBLIC;
    grant EXECUTE on E$CORE.CHARLIST to PUBLIC;
    grant EXECUTE on E$CORE.CLOB2BLOB to PUBLIC;
    grant EXECUTE on E$CORE.CONST to PUBLIC;
    grant EXECUTE on E$CORE.D09 to PUBLIC;
    grant EXECUTE on E$CORE.FILENAME to PUBLIC;
    grant EXECUTE on E$CORE.HS to PUBLIC;
    grant EXECUTE on E$CORE.LNG to PUBLIC;
    grant EXECUTE on E$CORE.NVL2P to PUBLIC;
    grant EXECUTE on E$CORE.NVL3 to PUBLIC;
    grant EXECUTE on E$CORE.NZ to PUBLIC;
    grant EXECUTE on E$CORE.SCONST to PUBLIC;
    grant EXECUTE on E$CORE.TOLIST to PUBLIC;
    grant EXECUTE on E$CORE.TOLISTCNT to PUBLIC;
    grant EXECUTE on E$CORE.TOLISTDISTINCT to PUBLIC;
    grant EXECUTE on E$CORE.TOLISTSORTED to PUBLIC;
    grant EXECUTE on E$CORE.VOID to PUBLIC;
    grant EXECUTE on E$TOCEAN.SYSTPuoC2p/N6FovgQMRYzaJkbw== to PUBLIC;
    grant EXECUTE on E$TOCEAN.SYSTPux8+o9CP317gQMRYzaITiA== to PUBLIC;
    grant EXECUTE on E$TOCEAN.SYSTPuoC2p/N/FovgQMRYzaJkbw== to PUBLIC;
    grant EXECUTE on E$XML.T$ADDR to PUBLIC;
    grant EXECUTE on E$XML.T$CONTENT to PUBLIC;
    grant EXECUTE on E$XML.T$CONTENTS to PUBLIC;
    grant EXECUTE on E$XML.T$CRGLINK to PUBLIC;
    grant EXECUTE on E$XML.T$DEPENDS to PUBLIC;
    grant EXECUTE on E$XML.T$DEPGR to PUBLIC;
    grant EXECUTE on E$XML.T$DICTNAME to PUBLIC;
    grant EXECUTE on E$XML.T$DICTNAMES to PUBLIC;
    grant EXECUTE on E$XML.T$DOCIDX to PUBLIC;
    grant EXECUTE on E$XML.T$DOCIDXS to PUBLIC;
    grant EXECUTE on E$XML.T$MTATTR to PUBLIC;
    grant EXECUTE on E$XML.T$MTATTRS to PUBLIC;
    grant EXECUTE on E$XML.T$N10S to PUBLIC;
    grant EXECUTE on E$XML.T$OBJEV to PUBLIC;
    grant EXECUTE on E$XML.T$OBJEVS to PUBLIC;
    grant EXECUTE on E$XML.T$PRICE to PUBLIC;
    grant EXECUTE on E$XML.T$PRICES to PUBLIC;
    grant EXECUTE on E$XML.T$RELATION to PUBLIC;
    grant EXECUTE on E$XML.T$RELATIONS to PUBLIC;
    grant EXECUTE on E$XML.T$VARS_CLEAR to PUBLIC;
    grant EXECUTE on E$XML.T$ADMDICT to PUBLIC;
    grant EXECUTE on E$XML.T$ADMDICTS to PUBLIC;
    grant EXECUTE on E$XML.T$CC to PUBLIC;
    grant EXECUTE on E$XML.T$CRGCARGO to PUBLIC;
    grant EXECUTE on E$XML.T$CRGPARCEL to PUBLIC;
    grant EXECUTE on E$XML.T$OBJINH to PUBLIC;
    grant EXECUTE on E$XML.T$OBJINHS to PUBLIC;
    grant EXECUTE on E$XML.T$PDOC to PUBLIC;
    grant EXECUTE on E$XML.T$PDOCS to PUBLIC;
    grant EXECUTE on E$XML.T$TRANSPORT to PUBLIC;
    grant EXECUTE on E$XML.T$TRANSPORTS to PUBLIC;
    grant EXECUTE on E$XML.T$CRGACTION to PUBLIC;
    grant EXECUTE on E$XML.T$DOC to PUBLIC;
    grant EXECUTE on E$XML.T$DOCS to PUBLIC;
    grant EXECUTE on E$XML.T$JEVENT to PUBLIC;
    grant EXECUTE on E$XML.T$OBJ to PUBLIC;
    grant EXECUTE on E$XML.T$OBJS to PUBLIC;
    grant EXECUTE on E$XML.T$OBJGR to PUBLIC;
    grant EXECUTE on E$XML.T$OBJGRS to PUBLIC;
    grant EXECUTE on E$XML.T$EDIMSG to PUBLIC;
    grant SELECT on E$CORE.EQ_NUM_C to PUBLIC;
    grant SELECT on E$CORE.EQ_NUM_C4 to PUBLIC;
    grant SELECT on E$CORE.KERNEL_SVP to PUBLIC;




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


begin dbms_stats.gather_schema_stats ( ownname          => 'E$TOCEAN' ); end;
/


