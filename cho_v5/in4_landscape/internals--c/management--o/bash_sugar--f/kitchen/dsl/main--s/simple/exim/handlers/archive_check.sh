#!/bin/bash

msgid=$1
CONF_PATH="/etc/faster/cmdb/techpool/exim/common"
EXIM_PATH="/var/spool/exim/scan"

#CONF_PATH="/medial/EDSS/sys/cmdb/techpool/exim/common"
#EXIM_PATH="/medial/EDSS/dev/!tmp"

EXT_DANGER=`cat $CONF_PATH/data/mime/ext_danger|grep -v "{"|sed -e 's/'"^.*.\\."'/./' -e 's/\\\N/\$|\\\/'|tr -d '\n'`
EXT_ARCH=`cat $CONF_PATH/data/mime/ext_arch|sed -e 's/'"^.*.\\."'/./' -e 's/\\\N/\$|\\\/'|tr -d '\n'`

# Prevents compressed files inside compressed 
EXT_DANGER_FULL=`echo ${EXT_DANGER}${EXT_ARCH}|sed -e "s/\$|\$//"`


#cd in msg dir
if [ ! -z "$msgid" ]; then
    if [ -d $EXIM_PATH/$msgid ]; then
        cd $EXIM_PATH/$msgid
    else
        echo -n "Directory $EXIM_PATH/$msgid with msgid $msgid is not exist\n"
        exit 1
    fi
fi

# Get filelist
 IFS=$'\n'; for i in $(find . -type f | egrep -i ".${EXT_ARCH}$"); do

# Test to see if the file is OK
	/usr/bin/7z e -so > /dev/null -p123 "$i" 2> /dev/null
	if [ "$?" -ne "0" ]; then
		echo -n '* The file <'"$i"'> is not a valid archive!\n'
		exit 1
	fi
	
   EXTFILE=`echo "$i" | sed -e 's/.*\.//' | tr [A-Z] [a-z]`
   case "${EXTFILE}" in
     tar)
        GET_FILELIST=`tar --list -f  "$i" 2> /dev/null`
        ;;
     tgz|gz)
        GET_FILELIST=`tar --list -zf "$i" 2> /dev/null`
        ;;
     bz2)
        GET_FILELIST=`tar --list -jf "$i" 2> /dev/null`
        ;;
     *)
        GET_FILELIST=`/usr/bin/7z l "$i"|awk '{ORS=" "; for(i=6;i<=NF;i++) print $i;print "\n"}'|grep 'Name' -A 1000|sed -e 's/Name//' -e 's/folders//'`
   esac

	# See if there dangers in the same content
	for i in $GET_FILELIST; do   
		CHECK_FILELIST=`echo "$i" |tr -d ' '| egrep -i "${EXT_DANGER_FULL}$"`
		if [ ! -z "$CHECK_FILELIST" ]; then
			echo -e 'Danger file(s) in archive <'"$i"'>: '$CHECK_FILELIST'\n'
			exit 1
		fi
    
    done
done
exit 0