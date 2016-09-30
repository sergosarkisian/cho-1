#!/bin/bash
erlc -o /run/erl-zabbix /media/sysdata/rev5/techpool/ontology/logitoring/erl-zabbix/erlang/*.erl
#LC_ALL="" erl -run monitoring start periodic:diskfree -run init stop -noshell
exit 0