alter table mysql.user         modify User         char(80)  binary not null default '';
alter table mysql.db           modify User         char(80)  binary not null default '';
alter table mysql.tables_priv  modify User         char(80)  binary not null default '';
alter table mysql.columns_priv modify User         char(80)  binary not null default '';
alter table mysql.procs_priv   modify User         char(80)  binary not null default '';
alter table mysql.proc         modify definer      char(141) collate utf8_bin not null default '';
alter table mysql.event        modify definer      char(141) collate utf8_bin not null default '';
alter table mysql.proxies_priv modify User         char(80)  COLLATE utf8_bin not null default '';
alter table mysql.proxies_priv modify Proxied_user char(80)  COLLATE utf8_bin not null default '';
alter table mysql.proxies_priv modify Grantor      char(141) COLLATE utf8_bin not null default '';
alter table mysql.servers      modify Username     char(80)                   not null default '';
alter table mysql.procs_priv   modify Grantor      char(141) COLLATE utf8_bin not null default '';
alter table mysql.tables_priv  modify Grantor      char(141) COLLATE utf8_bin not null default '';

flush privileges; 
