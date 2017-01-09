#!/bin/bash
set -e
/usr/bin/sleep 30
sqlplus -e -l "/ as sysdba" @/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/simpletest.sql
