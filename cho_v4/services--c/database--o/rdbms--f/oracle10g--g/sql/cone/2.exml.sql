connect "E$XML"/"&&exmlPassword"
set echo on
spool /media/storage/as/oracle/logs/cone/2.exml

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

spool off
