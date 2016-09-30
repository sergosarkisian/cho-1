#requires -version 2.0

Function Add-OSCStartup
{
	[Cmdletbinding(SupportsShouldProcess=$true)]
	Param
	(
		[Parameter(Mandatory=$true,Position=0)]
		[Alias('p')][String]$ItemPath,
		[Parameter(Mandatory=$false,Position=1)]
		[Alias('cc')][Switch]$ComputerConfiguration
	)
	
	If (Test-Path -Path $ItemPath)
	{
		#To get the item name
		$ItemName = (Get-Item -Path $ItemPath).Name

		If ($ComputerConfiguration)
		{
			$ComputerConfigDestination = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\StartUp"
			AddItemToStartup -ItemPath $ItemPath -Destination $ComputerConfigDestination
		}
		Else
		{
			$UserConfigDestination = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
			AddItemToStartup -ItemPath $ItemPath -Destination $UserConfigDestination
		}
	}
	Else
	{
	
		$ItemPath = "C:\Program Files (x86)\stunnel\stunnel.exe"
				$ItemName = (Get-Item -Path $ItemPath).Name

		If ($ComputerConfiguration)
		{
			$ComputerConfigDestination = "$env:ALLUSERSPROFILE\Microsoft\Windows\Start Menu\Programs\StartUp"
			AddItemToStartup -ItemPath $ItemPath -Destination $ComputerConfigDestination
		}
		Else
		{
			$UserConfigDestination = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
			AddItemToStartup -ItemPath $ItemPath -Destination $UserConfigDestination
		}
	}
}

Function AddItemToStartup([String]$ItemPath,[String]$Destination)
{
	Try
	{
		Copy-Item -Path $ItemPath -Destination $Destination
		Write-Host "Add '$ItemName' to Startup successfully." -ForegroundColor Green
	}
	Catch
	{
		Write-Host "Failed to add '$ItemName' to Startup." -ForegroundColor Red
	}
}
