#!/bin/bash
declare -A XEN_IP_ARR        
declare -A XEN_MAC_ARR        
declare -A XEN_NETMASK_ARR        
declare -A XEN_MTU_ARR        
declare -A XEN_COOKIE_ARR        

DOMID=`xenstore-read domid`
NET_COUNT=$((`xenstore-list /local/domain/$DOMID/rev5/net|wc -l`))
NET_COUNT_Z=$((NET_COUNT -1))

NET_CURR=0
while [ "$NET_CURR" -lt "$NET_COUNT" ]
do
    XEN_IP_ARR[$NET_CURR]=`xenstore-read /local/domain/$DOMID/rev5/net/$NET_CURR/ip`
    XEN_MAC_ARR[$NET_CURR]=`xenstore-read /local/domain/$DOMID/rev5/net/$NET_CURR/mac_low`
    XEN_NETMASK_ARR[$NET_CURR]=`xenstore-read /local/domain/$DOMID/rev5/net/$NET_CURR/netmask`
    XEN_MTU_ARR[$NET_CURR]=`xenstore-read /local/domain/$DOMID/rev5/net/$NET_CURR/mtu`
    XEN_COOKIE_ARR[$NET_CURR]=`xenstore-read /local/domain/$DOMID/rev5/net/$NET_CURR/cookie`
    
let "NET_CURR +=1"
done

