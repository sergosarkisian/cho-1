#! /bin/sh


MKDIR=/bin/mkdir


# Get settings, if file(s) exist(s). If not, we simply use defaults.
if test -f /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/oracle.vars ; then
    . /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/oracle.vars 
fi


# 
# Get and check environment (e.g. ORACLE_HOME)
# 
ora_environment()
{
  test -f /etc/profile.d/oracle.sh && . /etc/profile.d/oracle.sh
 # Check, If Oracle SW is installed, before spitting too many warnings
 if [ ! -f /etc/oratab -a ! -d "$ORACLE_HOME" ]; then
    echo "${warn}Oracle Database Software not yet installed!$norm"
    echo
 else
  if [ ! -z "$ORACLE_HOME" -a ! -d "$ORACLE_HOME" ]; then
    echo "${warn}ORACLE_HOME directory $ORACLE_HOME does not exist!$norm"
    echo "Unsetting ORACLE_HOME, will try to determine it from system..."
    unset ORACLE_HOME
  fi

  # Try /etc/oratab if it's not set in /etc/profile.d/oracle.sh
  test -z "$ORACLE_HOME" && test -f /etc/oratab &&                        \
    ORACLE_HOME=`awk -F: '/^[^#].*:.+:[YN]/ {if ($2!="") print $2; exit}' </etc/oratab` &&   \
    echo && echo "ORACLE_HOME not set, but I found this in /etc/oratab: $ORACLE_HOME" && echo

  if [ -z "$ORACLE_HOME" ]; then
    echo "${warn}ORACLE_HOME environment variable not set.$norm"
    echo "Check /etc/profile.d/oracle.sh and /etc/oratab"
  fi

  if [ ! -d "$ORACLE_HOME" ]; then
    echo "${warn}Cannot find ORACLE_HOME directory $ORACLE_HOME.$norm"
    echo "Environment settings are wrong! Check /etc/profile.d/oracle.sh"
  fi

  test -z "$ORACLE_OWNER" && ORACLE_OWNER="oracle"

  echo
  fi





  test -d "${TNS_ADMIN}" || TNS_ADMIN="$ORACLE_HOME/network/admin"

  if [ "$1" = "start" ]; then
    echo -n " ${extd}SETTINGS $1 from /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/oracle.vars $norm"
    if [ ! -f /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/oracle.vars  ]; then
      echo " - ${warn}!!! MISSING !!!$norm"
    else
      echo
    fi
    echo " - Set Kernel Parameters for Oracle:   ${SET_ORACLE_KERNEL_PARAMETERS:-no}"
    echo " - Start Oracle Listener:              ${START_ORACLE_DB_LISTENER:-no}"
    echo " - Start Oracle Database:              ${START_ORACLE_DB:-no}"
  fi
}


# Here we finally get to do the real work.
case "$1" in
  start)
    echo
    echo "#############################################################################"
    echo "#                 Begin of   O R A C L E   startup section                  #"
    echo "#############################################################################"
    echo
    ora_environment start

    # 
    # Check if we really have all the Oracle components we are told to start
    # 
 
    if [ ! -x $ORACLE_HOME/bin/dbstart -a ${START_ORACLE_DB:-no} = "yes" ]; then
      echo "${warn}Can't find needed file: dbstart - Setting START_ORACLE_DB = no $norm"
      START_ORACLE_DB="cannot";
    fi

    if [ ! -x $ORACLE_HOME/bin/lsnrctl -a ${START_ORACLE_DB_LISTENER:-no} = "yes" ]; then
      echo "${warn}Can't find needed file: lsnrctl - Setting START_ORACLE_DB_LISTENER = no $norm"
      START_ORACLE_DB_LISTENER="cannot";
    fi
     

 
    if [ ! -x $ORACLE_HOME/bin/isqlplusctl -a ${START_ORACLE_DB_ISQLPLUS:-no} = "yes" ]; then
      echo "${warn}Can't find needed file: isqlplusctl - Setting START_ORACLE_DB_ISQLPLUS = no $norm"
      START_ORACLE_DB_ISQLPLUS="cannot";
    fi

    echo

    # Set kernel parameters for Oracle
    if [ "${SET_ORACLE_KERNEL_PARAMETERS:-no}" == "yes" ]; then
      echo
      echo "Setting kernel parameters for Oracle, see file"
      if test -f /media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/oracle.vars ; then
        echo "/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/init/oracle.vars  for explanations."
      else
        echo "/etc/rc.config.d/oracle.rc.config for explanations."
      fi
      echo
    
      if  [ ! -d /proc/sys/kernel222 ]; then ## BUG
          echo; echo "No sysctl kernel interface - cannot set kernel parameters."; echo
      else
        # Set shared memory parameters
        echo -n "${extd}Shared memory:$norm    "
        test -f /proc/sys/kernel/shmmax && echo -n "  SHMMAX=${SHMMAX:-3294967296}"
        test -f /proc/sys/kernel/shmmax && echo ${SHMMAX:-3294967296} > /proc/sys/kernel/shmmax
        test -f /proc/sys/kernel/shmmni && echo -n "  SHMMNI=${SHMMNI:-4096}"
        test -f /proc/sys/kernel/shmmni && echo ${SHMMNI:-4096}       > /proc/sys/kernel/shmmni
        test -f /proc/sys/kernel/shmall && echo    "  SHMALL=${SHMALL:-2097152}"
        test -f /proc/sys/kernel/shmall && echo ${SHMALL:-2097152}    > /proc/sys/kernel/shmall
        test -f /proc/sys/kernel/shmall || echo
    
        # Set the semaphore parameters:
        # see Oracle release notes for Linux for how to set these values
        # SEMMSL, SEMMNS, SEMOPM, SEMMNI
        echo -n "${extd}Semaphore values:$norm "
        test -f /proc/sys/kernel/sem && echo -n "  SEMMSL=${SEMMSL:-1250}"
        test -f /proc/sys/kernel/sem && echo -n "  SEMMNS=${SEMMNS:-32000}"
        test -f /proc/sys/kernel/sem && echo -n "  SEMOPM=${SEMOPM:-100}"
        test -f /proc/sys/kernel/sem && echo    "  SEMMNI=${SEMMNI:-256}"
        test -f /proc/sys/kernel/sem && echo ${SEMMSL:-1250} ${SEMMNS:-32000} ${SEMOPM:-100} ${SEMMNI:-128} > /proc/sys/kernel/sem
        test -f /proc/sys/kernel/sem || echo

        echo -n "${extd}Other values:$norm     "
        test -f /proc/sys/fs/file-max && echo -n "  FILE_MAX_KERNEL=${FILE_MAX_KERNEL:-6815744}"  
        test -f /proc/sys/fs/file-max && echo ${FILE_MAX_KERNEL:-6815744} > /proc/sys/fs/file-max  
        test -f /proc/sys/net/ipv4/ip_local_port_range && echo "  IP_LOCAL_PORT_RANGE=${IP_LOCAL_PORT_RANGE:-"9000 65500"}"  
        test -f /proc/sys/net/ipv4/ip_local_port_range && echo ${IP_LOCAL_PORT_RANGE:-"9000 65500"} > /proc/sys/net/ipv4/ip_local_port_range
        test -f /proc/sys/net/core/rmem_default && echo -n "  RMEM_DEFAULT=${RMEM_DEFAULT:-262144}"
        test -f /proc/sys/net/core/rmem_default && echo ${RMEM_DEFAULT:-262144} > /proc/sys/net/core/rmem_default
        test -f /proc/sys/net/core/wmem_default && echo -n "  WMEM_DEFAULT=${WMEM_DEFAULT:-262144}"
        test -f /proc/sys/net/core/wmem_default && echo ${WMEM_DEFAULT:-262144} > /proc/sys/net/core/wmem_default
        test -f /proc/sys/net/core/rmem_max && echo -n "  RMEM_MAX=${RMEM_MAX:-4194304}"
        test -f /proc/sys/net/core/rmem_max && echo ${RMEM_MAX:-4194304} > /proc/sys/net/core/rmem_max
        test -f /proc/sys/net/core/wmem_max && echo -n "  WMEM_MAX=${WMEM_MAX:-1048586}"
        test -f /proc/sys/net/core/wmem_max && echo ${WMEM_MAX:-1048586} > /proc/sys/net/core/wmem_max
        test -f /proc/sys/vm/vm_mapped_ratio && echo -n "  VM_MAPPED_RATIO=${VM_MAPPED_RATIO:-100}"
        test -f /proc/sys/vm/vm_mapped_ratio && echo ${VM_MAPPED_RATIO:-250} > /proc/sys/vm/vm_mapped_ratio
# aio-max-size is obsolete in 2.6 & it's changed to aio-max-nr 
        test -f /proc/sys/fs/aio-max-nr && echo "  AIO_MAX_SIZE=${AIO_MAX_SIZE:-1048576}"
        test -f /proc/sys/fs/aio-max-nr && echo ${AIO_MAX_SIZE:-1048576} > /proc/sys/fs/aio-max-nr
        test -f /proc/sys/fs/aio-max-nr || echo

# HUGEPAGES
        echo -n "${extd}Huge Pages:$norm     "
        # on SLES9
        test -f /proc/sys/vm/disable_cap_mlock && echo 1 > /proc/sys/vm/disable_cap_mlock

        # on SLES10
        test -f /proc/sys/vm/hugetlb_shm_group && echo -n "    SHM_GROUP=${SHM_GROUP}"
        SHM_GROUP_GID=`cat /etc/group | grep -w ${SHM_GROUP} |awk -F: '{ print $3 }'`
        test -f /proc/sys/vm/hugetlb_shm_group && echo ${SHM_GROUP_GID} > /proc/sys/vm/hugetlb_shm_group

        test -f /proc/sys/vm/nr_hugepages && echo -n "    NR_HUGE_PAGES=${NR_HUGE_PAGES:-0}"
        test -f /proc/sys/vm/nr_hugepages && echo ${NR_HUGE_PAGES:-0} > /proc/sys/vm/nr_hugepages

        echo

        echo -n "${extd}ULIMIT values:$norm    "
        echo    "  MAX_CORE_FILE_SIZE_SHELL=${MAX_CORE_FILE_SIZE_SHELL:-0}"
        ulimit -c ${MAX_CORE_FILE_SIZE_SHELL:-0}
        echo -n "                    FILE_MAX_SHELL=${FILE_MAX_SHELL:-65536}"
        ulimit -n ${FILE_MAX_SHELL:-65536}
        echo    "  PROCESSES_MAX_SHELL=${PROCESSES_MAX_SHELL:-16384}"
        ulimit -u ${PROCESSES_MAX_SHELL:-16384}

        # Check if shmmax is really set to what we want - on some systems and
        # certain settings the result could be shmmax=0 if you set it to e.g. 4GB!
        if [ `cat /proc/sys/kernel/shmmax` != "${SHMMAX:-3294967296}" ]; then
          echo "${warn}---- WARNING - SHMMAX could not be set properly ----$norm"
          echo "   Tried to set it to: ${SHMMAX:-3294967296}"
          echo "   Value is now:       `cat /proc/sys/kernel/shmmax`"
          echo "   You might try again with a lower value."
        fi
      fi
      echo

        # Check for /etc/sysctl.conf settings (see 'man sysctl') for conflicting kernel settings
        test -s /etc/sysctl.conf &&   \
        {
          echo "Checking sysctl.conf to overwrite previous kernel settings..."
          for i in kernel.shmmax kernel.shmmni kernel.shmall kernel.sem vm.nr_hugepages vm.hugetlb_shm_group\
                net.core.rmem_default net.core.rmem_max net.core.wmem_default net.core.wmem_max \
                fs.file-max net.ipv4.ip_local_port_range vm.vm_mapped_ratio fs.aio-max-nr ; do
                    line=`grep $i /etc/sysctl.conf | sed 's/\ //g'`
            name=`echo $line | cut -d'=' -f 1`
            value=`echo $line | cut -d'=' -f 2`
            if [ -n "$line" ]; then
              echo "   sysctl value $name=$value restored."
                USE_SYSCTL="yes"
            fi
          done
        }

        if [ "$USE_SYSCTL" = "yes" ]; then
              sysctl -q -p
        fi
      echo

      echo -n "Kernel parameters set for Oracle: "
      echo
      echo
    fi

    

  

    echo -n "  - Starting Listener..."
       export ORACLE_HOME=$ORACLE_HOME TNS_ADMIN=$TNS_ADMIN; $ORACLE_HOME/bin/lsnrctl start 

 
    

    echo
    echo "  + Starting Database(s)..."
     cat /etc/oratab | while read LINE
      do
        case $LINE in
          \#*) # skip over comment-line in oratab
           ;;
          *)
          # Proceed only if third field is 'Y'.
          if [ "`echo $LINE | awk -F: '{print $3}' -`" = "N" ] ; then
             ORACLE_SID=`echo $LINE | awk -F: '{print $1}' -`
             ORACLE_HOME=`echo $LINE | awk -F: '{print $2}' -`
             echo; echo -n "No start entry for SID $ORACLE_SID at $ORACLE_HOME in /etc/oratab"
          fi
         
          ;;
        esac
      done
 
      echo -n "    "
        # bz#353957
        ORACLE_VERSION=`$ORACLE_HOME/bin/sqlplus -v | awk '{split($3, V, "."); print V[1]}'`
        if [[ $ORACLE_VERSION == "11" ]]; then
                echo "Oracle DB exec string: export ORACLE_HOME=$ORACLE_HOME TNS_ADMIN=$TNS_ADMIN; $ORACLE_HOME/bin/dbstart $ORACLE_HOME"
                export ORACLE_HOME=$ORACLE_HOME TNS_ADMIN=$TNS_ADMIN; $ORACLE_HOME/bin/dbstart $ORACLE_HOME
        else
                echo "Oracle DB exec string: export ORACLE_HOME=$ORACLE_HOME TNS_ADMIN=$TNS_ADMIN; $ORACLE_HOME/bin/dbstart"        
                export ORACLE_HOME=$ORACLE_HOME TNS_ADMIN=$TNS_ADMIN; $ORACLE_HOME/bin/dbstart
        fi
      echo -n "    Status of Oracle database(s) start:"
      echo
    
    while true; do
        sleep 1000000000
    done
    ;;
  stop)
    echo
    echo "#############################################################################"
    echo "#                 Begin of   O R A C L E   shutdown section                 #"
    echo "#############################################################################"
    echo
    ora_environment stop

    echo "Shutting down Oracle services (only those running)"; echo

    test -x $ORACLE_HOME/bin/lsnrctl        && echo -n "Shutting down Listener: " && (export ORACLE_HOME=$ORACLE_HOME TNS_ADMIN=$TNS_ADMIN; $ORACLE_HOME/bin/lsnrctl stop; )

    test -x $ORACLE_HOME/bin/dbshut       && echo -n "Shutting down Database: " && (export ORACLE_HOME=$ORACLE_HOME TNS_ADMIN=$TNS_ADMIN; $ORACLE_HOME/bin/dbshut ; )


    ;;
 status)
    echo
    echo "#############################################################################"
    echo "#                  Begin of   O R A C L E   status section                  #"
    echo "#############################################################################"
    echo
    ora_environment status

    echo "${extd}Kernel Parameters$norm"
    echo -n "Shared memory:"
    echo -n "  SHMMAX=" `cat /proc/sys/kernel/shmmax`
    echo -n "  SHMMNI=" `cat /proc/sys/kernel/shmmni`
    echo    "  SHMALL=" `cat /proc/sys/kernel/shmall`
    echo -n "Semaphore values:"
    echo    "  SEMMSL, SEMMNS, SEMOPM, SEMMNI: " `cat /proc/sys/kernel/sem`
    echo


    if [ -x $ORACLE_HOME/bin/oracle ]; then
      echo "${extd}Database-Instances$norm"
      # loop over the instances (very simple !!!)
      IFS=:
      grep -v '^\(#\|$\)' /etc/oratab | while read sid ohome autostart ; do
        state=up
        #export ORACLE_SID=$sid; sqlplus /nolog" <<-! 2>/dev/null | grep ORA-01034 >/dev/null && state=down connect / as sysdba show sga !
        echo "Instance $sid is $state (autostart: $autostart)"
      done
      echo
    fi
    
    if [ -x $ORACLE_HOME/bin/lsnrctl ]; then
      state=up
      $ORACLE_HOME/bin/lsnrctl status | grep "[nN]o [lL]istener" >/dev/null && state=down
      echo "${extd}TNS-Listener:$norm $state"
      echo
    fi

   

    echo "${extd}Process list for user oracle:$norm"
    ps U oracle
    ps ax | grep oracm | grep -v grep
    ;;
 simplecheck)
    ora_environment simplecheck
    set -e
    /usr/bin/sleep 30
   $ORACLE_HOME/bin/sqlplus -l "/ as sysdba" @/media/sysdata/in4/cho/cho_v4/services--c/database--o/rdbms--f/oracle10g--g/sql/simpletest.sql 
 ;;
  *)
    echo "Usage: $0 {start|stop|status|restart}"
    exit 1
esac

echo
echo "#############################################################################"
echo "#                      End of   O R A C L E   section                       #"
echo "#############################################################################"
echo

# Global return value of this script is "success", always. We have too many
# individual return values...

