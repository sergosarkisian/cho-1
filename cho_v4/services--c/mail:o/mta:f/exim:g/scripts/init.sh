#/bin/bash

sqlite_path=$1
time=`date +%s`

sed -i "s/EXIM_ARGS=.*/EXIM_ARGS=\"-bd -q10m -L exim\"/" /etc/sysconfig/exim

mkdir -p $sqlite_path

## $sqlite_path/mail.sqlite
sqlite3 $sqlite_path/mail.sqlite << EOF


CREATE TABLE  accounts  (
   id INTEGER,
   tag  TEXT NOT NULL DEFAULT 'notag',
   username TEXT NOT NULL,
   domain TEXT NOT NULL,
   password TEXT NOT NULL DEFAULT '200820e3227815ed1756a6b531e7e0d2',
   quota INTEGER DEFAULT '1000',
   created timestamp default (strftime('%s', 'now')),
   modified timestamp default (strftime('%s', 'now')),
   active INTEGER NOT NULL DEFAULT '1',
  PRIMARY KEY(id)
);
CREATE UNIQUE INDEX  users_unique  on  accounts  ( username , domain );


CREATE TABLE  domains  (
   id INTEGER,
   tag  TEXT NOT NULL DEFAULT 'notag',   
   domain TEXT NOT NULL,
   type TEXT NOT NULL DEFAULT 'delivery',
   created timestamp default (strftime('%s', 'now')),
   modified timestamp default (strftime('%s', 'now')),
   active INTEGER NOT NULL DEFAULT '1', 
  PRIMARY KEY(id)
);
CREATE UNIQUE INDEX  domains_unique  on  domains  ( domain );



CREATE TABLE  aliases  (
   id INTEGER,
   tag  TEXT NOT NULL DEFAULT 'notag',   
   account TEXT NOT NULL,
   alias_username TEXT NOT NULL,
   alias_domain TEXT NOT NULL,
   created timestamp default (strftime('%s', 'now')),
   modified timestamp default (strftime('%s', 'now')),
   active INTEGER NOT NULL DEFAULT '1',  
  PRIMARY KEY(id)
);
CREATE UNIQUE INDEX aliases_unique  on  aliases  ( account , alias_username , alias_domain );


CREATE TABLE  destinations  (
   id INTEGER,
   tag  TEXT NOT NULL DEFAULT 'notag',   
   account TEXT NOT NULL,
   destination_username TEXT NOT NULL,
   destination_domain TEXT NOT NULL,
   router TEXT NOT NULL DEFAULT 'common',      
   transport TEXT NOT NULL DEFAULT 'lmtp_over_smtp',   
   created timestamp default (strftime('%s', 'now')),
   modified timestamp default (strftime('%s', 'now')),
   active INTEGER NOT NULL DEFAULT '1', 
  PRIMARY KEY(id)
);
CREATE UNIQUE INDEX destinations_unique  on  destinations  ( account , destination_username , destination_domain );


CREATE TABLE  relay_from  (
   id INTEGER,
   ip TEXT,
   created timestamp default (strftime('%s', 'now')),
   modified timestamp default (strftime('%s', 'now')),
   active INTEGER NOT NULL DEFAULT '1',
   PRIMARY KEY(id)
);
CREATE UNIQUE INDEX  relay_from_unique  on  relay_from  ( ip );


CREATE TABLE  accesslists  (
   id INTEGER,
   ip TEXT,
   from_hashed TEXT,
   type TEXT,
   expires INTEGER NOT NULL DEFAULT '0',
   created timestamp default (strftime('%s', 'now')),
   modified timestamp default (strftime('%s', 'now')),
   active INTEGER NOT NULL DEFAULT '1',
   PRIMARY KEY(id)   
);
CREATE UNIQUE INDEX  accesslists_unique  on  accesslists  ( ip, from_hashed, type );


CREATE TABLE  greylist_resenders  (
   host TEXT,
   helo TEXT,
   time INTEGER,
  PRIMARY KEY (host, helo)
);


CREATE TABLE  greylist_current  (
   id TEXT,
   expire INTEGER,
   host TEXT,
   helo TEXT,
  PRIMARY KEY(id)  
);


EOF


chmod -R 777 $sqlite_path