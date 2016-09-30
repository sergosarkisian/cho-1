 #!/bin/bash
###
##Monitoring - app.proc.single
###

if [[ -z "$1" ]]; then exit 1; fi

PID=`/sbin/pidofproc $1`

OUT="/proc/$PID/stat"
echo "#PROC\n"
cat $OUT

echo "#MEMORY\n"
OUT="/proc/$PID/mstat"
cat $OUT