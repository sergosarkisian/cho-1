#####login as E$XML#####

 drop table x$types
 
create table x$types (txt clob) 

select   replace(t.txt, 'CREATE OR REPLACE TYPE E$XML."' || U.TYPE_NAME || '" AS OBJECT', 'CREATE OR REPLACE TYPE E$XML."' || U.TYPE_NAME || '" OID ''' || u.type_oid || ''' AS OBJECT') t
from (
   select column_value txt, rownum rn
     from table(utl.splitc((select txt from x$types), chr(10)))
    ) t
      left join user_types u on u.type_name = translate(regexp_substr(t.txt, '"[^"]+"'), '+"', '+')
   where length(t.txt) > 1          
 order by t.rn
 
