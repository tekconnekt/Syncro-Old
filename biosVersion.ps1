Import-Module $env:SyncroModule
$bversion=$(Get-WmiObject -Class "Win32_Bios").SMBIOSBIOSVersion
Set-Asset-Field -Subdomain "SUBDOMAINHERE" -Name "BiosVersion" -Value $bversion