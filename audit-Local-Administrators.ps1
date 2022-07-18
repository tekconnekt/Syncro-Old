Import-Module $env:SyncroModule
$oldFile = "C:\temp\a-old.txt"
$newFile = "C:\temp\a-new.txt"

if(!(test-path C:\temp)){
  mkdir C:\temp
}

$obj_group = [ADSI]"WinNT://localhost/Administrators,group"
$members= @($obj_group.psbase.Invoke("Members")) | foreach{([ADSI]$_).InvokeGet("Name")}
Write-Output "Current local Administrators: $members"

$oldFilePresent = Test-Path -Path $oldFile
$newFilePresent = Test-Path -Path $newFile

#1. if both exist, delete old and move new to old
#2. if old exists, write new and do comparison
#3. otherwise, write new, and move it to old to setup good state for next run

if($oldFilePresent -And $newFilePresent){
   del $oldFile
   mv $newFile $oldFile
} 
if($oldFilePresent){
   "Current local Administrators: $members" | Out-File -filepath $newFile 
   $comparison = compare-object (get-content $newFile) (get-content $oldFile)
   if($comparison){
       $comparison | out-file C:\temp\diff.txt
       rmm-alert -Category "local_administrators_changed" -Body "Local Administrators group has changed! check out $(get-content C:\temp\diff.txt)"
   }   
} ELSE {  
  "Current local Administrators: $members" | Out-File -filepath $newFile     
  mv $newFile $oldFile
}









