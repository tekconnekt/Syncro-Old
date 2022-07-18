Import-Module $env:SyncroModule
$Username = "KayS"
$Password = "PBSLchangeme123"
$SubDomain = "workgroup"

$group = "users"
$KeyPath = "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\Winlogon"

$adsi = [ADSI]"WinNT://$env:COMPUTERNAME"
$existing = $adsi.Children | where {$_.SchemaClassName -eq 'user' -and $_.Name -eq $Username }

if ($existing -eq $null) {

    Write-Host "Creating new local user $Username."
    & NET USER $Username $Password /add /y /expires:never
    
    Write-Host "Adding local user $Username to $group."
    & NET LOCALGROUP $group $Username /add
    Rmm-Alert -Category 'Automation' -Body 'Local user Account Added'
    Set-Asset-Field -Subdomain $SubDomain -Name "LocaluserAccount" -Value $UserName
}
else {
    Write-Host "Setting password for existing local user $Username."
    $existing.SetPassword($Password)
}

Write-Host "Ensuring password for $Username never expires."
& WMIC USERACCOUNT WHERE "Name='$Username'" SET PasswordExpires=FALSE
