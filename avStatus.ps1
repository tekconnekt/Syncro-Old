#Import Syncro Function so we can create an RMM alert if out of date
Import-Module $env:SyncroModule

#Call Antivirus function to check if it is up to date or not
function Get-AntiVirusProduct {
[CmdletBinding()]
param (
[parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
[Alias('name')]
$computername=$env:computername
)

$AntiVirusProduct = Get-WmiObject -Namespace root\SecurityCenter2 -Class AntiVirusProduct  -ComputerName $computername

#Switch to determine the status of antivirus definitions and real-time protection.
$string = $AntiVirusProduct.productState
$avstat = $string -split ', '
#switch ($AntiVirusProduct.productState) {
switch ($avstat[0]) {
    "262144" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
    "262160" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
    "266240" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
    "266256" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
    "393216" {$defstatus = "Up to date" ;$rtstatus = "Disabled"}
    "393232" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
    "393488" {$defstatus = "Out of date" ;$rtstatus = "Disabled"}
    "397312" {$defstatus = "Up to date" ;$rtstatus = "Enabled"}
    "397328" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
    "397584" {$defstatus = "Out of date" ;$rtstatus = "Enabled"}
    "331776" {$defstatus = "Up to Date" ;$rtstatus = "Enabled"}
    default {$defstatus = "Unknown" ;$rtstatus = "Unknown"}
    }

#Create hash-table for each computer
$ht = @{}
$ht.Computername = $computername
$ht.Name = $AntiVirusProduct.displayName
$ht.ProductExecutable = $AntiVirusProduct.pathToSignedProductExe
$ht.'Definition Status' = $defstatus
$ht.'Real-time Protection Status' = $rtstatus
$ht.'code' = $AntiVirusProduct.productState

# will still return if it is unknown, etc. if it is unknown look at the code it returns, then look up the status
# and add it above
New-Object -TypeName PSObject -Property $ht

if ($defstatus -ne "Up to Date" -or $rtstatus -ne "Enabled"){
    Rmm-Alert -Category 'av_out_of_date' -Body 'AV is out of date!'
} 
}
Get-AntiVirusProduct