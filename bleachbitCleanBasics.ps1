Import-Module $env:SyncroModule

#this places it in C:\temp\Bleachbit-Portable
Expand-Archive C:\temp\bleachbit-portable.zip -DestinationPath C:\temp

$Params = "-c firefox.vacuum"
$ParsedParams = $Params.Split(" ")
& "C:\temp\Bleachbit-Portable\bleachbit_console.exe" $ParsedParams

write-host "Finished doing firefox.vacuum"