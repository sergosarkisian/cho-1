#### Common functionality of data_safety--c--file_backup--o--infrastructure--f--bareos DSL

## Bugs
* bareos webui - login problem
* labling problem in case of reuse "recycle\prune" pool

## Re-work/organize
* rev5 init (pg scripts)
* bareos-webui placement (as code & as php-ZendFramework2-*)
* Run After/Before concept in all backups
* Filesets for common services (....)
* Template for Restore job (Add Preﬁx, Add suffix, Regex Where)


## New 
* Implement "Write Bootstrap = <directory> in JobDefs resource "
* mysql dump (all db & per-dbs)
* oracle dump (rman & expdb)
* pg dump (all db & per-schema)
* new job init script

## Understand the concept/options
* Scratch Pool
* bscan
* Verify Job
* Migrate job ( Migration High Bytes, Selection Pattern, Selection Type )
* Virtual backups (Consolidations)
* Backup-driven snapshots
* Audit (Audit Events, Auditing)
* Statistics (Collect Statistics, Collect Device Statistics, Collect Job Statistics)
* LMDB usage (Always Use LMDB = yes)
* Allowed Job Command
* Auth Type = MD5
* Log Timestamp Format 
* Console ACL's
* 9.12 Proﬁle Resource
* Run After Failed Job
* Timezones for clients

#### INTEGRATION## Logitoring
* Use "8.2.6 Variable Expansion" as reference model
* zabbix notification using messages
* Zabbix templates (LLD)
* ES templates
* syslog -> Syslog = localhost all

## Security
* Test Dir-SD, Dir-FD, FD-SD channel encryption
* Encrypted backups - "Chapter 28 - Data Encryption" 

## Service
* Timer for misc bareos everyday jobs -  "Console = "update stats days=3" 
* systemd services for Dir, SD
* systemd services for two FD types - shared & per-service

## Logitoring
* Use "8.2.6 Variable Expansion" as reference model
* zabbix notification using messages
* Zabbix templates (LLD)
* ES templates
* syslog -> Syslog = localhost all


## Data safety
* Backup self-PG instance

-----
# Tags
#B - Bugs, #R - Re-work, #N - New