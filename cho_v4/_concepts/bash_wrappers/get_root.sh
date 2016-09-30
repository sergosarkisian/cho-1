#!/bin/bash
echo  "Enter root permissions reason (ZID/ESID/text): "
read REASON

if [[ $REASON = '' || -z "$REASON" || ${#REASON} -lt 12 ]]; then
	echo "Please fill up reason correctly"
	exit 1;
else
	logger -p auth.warning -t "get_root"  "@cee: {\"msg_class\":\"security\", \"msg_view\":\"ssh\", \"type\":\"sudo\", \"user\":\"$SUDO_USER\", \"reason\":\"$REASON\"}"
	/usr/bin/su - root 
fi

