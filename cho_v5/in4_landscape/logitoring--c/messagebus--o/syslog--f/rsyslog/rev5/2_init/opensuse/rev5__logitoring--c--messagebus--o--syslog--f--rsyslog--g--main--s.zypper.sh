#!/bin/sh

##REPO
#zypper --gpg-auto-import-keys --non-interactive ar -cf HTTP

##PACKAGE
zypper --gpg-auto-import-keys --non-interactive in --oldpackage rsyslog-module-elasticsearch rsyslog-module-relp rsyslog-module-mmnormalize rsyslog-diag-tools