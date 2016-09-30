#
# Set your ORACLE environment variable here 
# ORACLE_HOME - Used here and in /etc/init.d/oracle (ora_environment())
# ORACLE_SID - Your Oracle System Identifier 
#
  ORACLE_BASE=/media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g/ee--s
  ORACLE_HOME=$ORACLE_BASE/product/10g
  ORACLE_HOME_LISTNER=$ORACLE_HOME
  ORACLE_SID=wk10
  export ORACLE_BASE ORACLE_HOME ORACLE_SID ORACLE_HOME_LISTNER

#
# Login environment variable settings for Oracle
# The code below is done ONLY if the user is "oracle": 
# 

if [ `id -un` == "oracle" ]; then

  # Get settings, if file(s) exist(s). If not, we simply use defaults.
  if test -f /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g/ee--s/product/10g/oracle.vars; then
    # new location as of SL 8.0 is directory /etc/sysconfig/
    . /media/storage/ts/services--c/database--o/rdbms--f/oracle10g--g/ee--s/product/10g/oracle.vars
  else
    if test -f /etc/rc.config.d/oracle.rc.config; then
      # location is directory /etc/rc.config.d/
      . /etc/rc.config.d/oracle.rc.config
    else
      if test -f /etc/rc.config; then
      # old SuSE location was to have everything in one file
      . /etc/rc.config
      fi
    fi
  fi


  TNS_ADMIN=$ORACLE_HOME/network/admin
  # Set ORA_NLSxx depending on 9i or 10g
  test -d $ORACLE_HOME/ocommon/nls/admin/data && export ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data
  test -d $ORACLE_HOME/nls/data && export ORA_NLS10=$ORACLE_HOME/nls/data

  PATH=$PATH:$ORACLE_HOME/bin
  LD_LIBRARY_PATH=${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$ORACLE_HOME/lib:$ORACLE_HOME/ctx/lib
  CLASSPATH=$ORACLE_HOME/JRE:$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib:$ORACLE_HOME/network/jlib

  export PATH LD_LIBRARY_PATH CLASSPATH TNS_ADMIN

  # ORACLE_TERM=xterm; export ORACLE_TERM
  # NLS_LANG=AMERICAN_AMERICA.UTF8; export NLS_LANG

  unset JAVA_BINDIR JAVA_HOME

  # core dump file size
  ulimit -c ${MAX_CORE_FILE_SIZE_SHELL:-0} 2>/dev/null

  # max number of processes for user
  ulimit -u ${PROCESSES_MAX_SHELL:-16384} 2>/dev/null

  # max number of open files for user
  ulimit -n ${FILE_MAX_SHELL:-65536} 2>/dev/null

fi
