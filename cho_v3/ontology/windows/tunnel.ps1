#### ADD HOSTS RECORDS ####
ac -Encoding UTF8  C:\Windows\system32\drivers\etc\hosts "127.1.1.1 remote`n127.1.1.1 $hostname"
####

#### AUTO LOOPBACK INTERFACE CREATION SCRIPT ####

# rename the existing NIC to "net"
$id = (Get-WmiObject Win32_NetworkAdapter -Filter "ServiceName='netvsc'").NetConnectionID
netsh int set int name = $id newname = "net"

.\devcon -r install $env:windir\Inf\Netloop.inf *MSLOOP

# rename the loopback NIC to "tunnel"
$id = (Get-WmiObject Win32_NetworkAdapter -Filter "Description='Microsoft Loopback Adapter'").NetConnectionID
netsh int set int name = $id newname = "tunnel"
netsh int ip set interface "tunnel" metric=254
)

# Set the "Register this connection's address in DNS" to unchecked
$nic.SetDynamicDNSRegistration($false)

# disable bindings
.\nvspbind /d "net" ms_tcpip6 
.\nvspbind /d "tunnel" ms_msclient
.\nvspbind /d "tunnel" ms_pacer
.\nvspbind /d "tunnel" ms_server
.\nvspbind /d "tunnel" ms_tcpip6
.\nvspbind /d "tunnel" ms_lltdio
.\nvspbind /d "tunnel" ms_rspndr

# Assign an IP address, subnet mask, and gateway
$ip = "127.1.1.1"
$mask = "255.255.255.252"
$gw = "127.1.1.2"
$nic.EnableStatic($ip,$mask)
$nic.SetGateways($gw)

# Set the binding order
.\nvspbind /++ "net" *

#### 

#### DISABLE LOCAL SAMBA ####
sc config smb start= demand
sc config LanmanServer start= demand
####