#/bin/bash

sqlite_path=$1
mkdir -p $sqlite_path

## $sqlite_path/mail.sqlite
sqlite3 /etc/exim/db.sqlite << EOF

CREATE TABLE accounts
(
  id serial NOT NULL,
  username text NOT NULL,
  password text NOT NULL DEFAULT '200820e3227815ed1756a6b531e7e0d2',
  CONSTRAINT accounts_pkey PRIMARY KEY (id)
);



CREATE TABLE domains
(
  id serial NOT NULL,
  name text NOT NULL,
  type text NOT NULL,
  rcv_from text NOT NULL DEFAULT 'all',
  CONSTRAINT domains_id PRIMARY KEY (id),
  CONSTRAINT domains_name_key UNIQUE (name)
);

  

CREATE TABLE router
(
  id serial NOT NULL,
  src text NOT NULL,
  from_domain integer NOT NULL,
  from_user text NOT NULL,
  to_domain integer NOT NULL,
  to_user text NOT NULL,
  transport text NOT NULL,
  inactive boolean DEFAULT false,
  CONSTRAINT router_id PRIMARY KEY (id),
  CONSTRAINT router_from_domain_fkey FOREIGN KEY (from_domain)
      REFERENCES domains (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT router_to_domain_fkey FOREIGN KEY (to_domain)
      REFERENCES domains (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

-- Table: relay_from

-- DROP TABLE relay_from;

CREATE TABLE relay_from
(
  id serial NOT NULL,
  src text NOT NULL,
  ip text NOT NULL,
  CONSTRAINT relay_from_pkey PRIMARY KEY (id)
);
  

-- Table: accesslists

-- DROP TABLE accesslists;

CREATE TABLE accesslists
(
  id serial NOT NULL,
  src text NOT NULL,
  ip text NOT NULL,
  hdr_from text NOT NULL,
  type text NOT NULL,
  CONSTRAINT accesslists_pkey PRIMARY KEY (id)
);

--CREATE UNIQUE INDEX accesslists_unique  ON accesslists;
CREATE TABLE greylist
(
  id INTEGER  PRIMARY KEY AUTOINCREMENT,
  relay_ip TEXT default NULL,
  sender_type TEXT CHECK( sender_type IN ('NORMAL','BOUNCE') ) NOT NULL default 'NORMAL',
  sender TEXT default NULL,
  recipient TEXT default NULL,
  block_expires TEXT NOT NULL default '0000-00-00 00:00:00',
  record_expires TEXT NOT NULL default '9999-12-31 23:59:59',
  create_time TEXT NOT NULL default '0000-00-00 00:00:00',
  TYPE TEXT CHECK( TYPE IN ('AUTO','MANUAL') ) NOT NULL default 'MANUAL',
    passcount INTEGER NOT NULL default '0',
  last_pass TEXT NOT NULL default '0000-00-00 00:00:00',
  blockcount INTEGER NOT NULL default '0',
  last_block TEXT NOT NULL default '0000-00-00 00:00:00'
);


--UNIQUE relay_ip (relay_ip,sender,recipient,sender_type),

CREATE TABLE greylist_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  listid INTEGER NOT NULL default '0',
  timestamp TEXT NOT NULL default '0000-00-00 00:00:00',
  kind TEXT CHECK( kind IN ('deferred','accepted') ) NOT NULL default 'deferred'
);
EOF


chmod -R 777 $sqlite_path
