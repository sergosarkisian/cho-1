CLASS=$1
PRODUCT=$2
TYPE=$3
INSTANCE=$4

if [[ !-z $INSTANCE ]]; then
    NAMING="rev5_$PRODUCT_$TYPE@$INSTANCE"
else
    NAMING="rev5_$PRODUCT_$TYPE"
fi

rm -f /etc/systemd/system/rev5_$NAMING.service
cp /media/sysdata/rev5/techpool/ontology/$CLASS/$PRODUCT/_rev5/5_systemd/rev5_$NAMING.service 	/etc/systemd/system/

systemctl daemon-reload
systemctl enable rev5_$NAMING.service && systemctl restart rev5_$NAMING.service 
systemctl status rev5_$NAMING.service 
