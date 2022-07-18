Import-Module $env:SyncroModule

add-type -AssemblyName System.Web

$minLength = 15 ## characters
$maxLength = 20 ## characters
$length = Get-Random -Minimum $minLength -Maximum $maxLength
$nonAlphaChars = 5
$Password = [System.Web.Security.Membership]::GeneratePassword($length, $nonAlphaChars)
$Username = "AdminUser_CHANGEME"

Set-Asset-Field -Subdomain $subdomain -Name "LocalAdminPW" -Value $Password
write-host "Set the custom field value to $Password"

$group = "Administrators"
$KeyPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

    Write-Host "Creating new local user $Username."
    & NET USER $Username $Password /add /y /expires:never
    
    Write-Host "Adding local user $Username to $group."
    & NET LOCALGROUP $group $Username /add

}
else {
    Write-Host "Setting password for existing local user $Username."
    $existing.SetPassword($Password)
}

Write-Host "Ensuring password for $Username never expires."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE

New-Item -Path "$KeyPath" -Name SpecialAccounts | Out-Null
New-Item -Path "$KeyPath\SpecialAccounts" -Name UserList | Out-Null
New-ItemProperty -Path "$KeyPath\SpecialAccounts\UserList" -Name $Username -Value 0 -PropertyType DWord | Out-Null