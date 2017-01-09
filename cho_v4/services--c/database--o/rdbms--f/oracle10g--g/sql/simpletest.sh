#!/bin/bash
set -e
/usr/bin/sleep 30
/media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g/ee--s/product/10g/bin/sqlplus -l "/ as sysdba" @/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/simpletest.sql
