$sixtyFourBit = Test-Path -Path "C:\Program Files (x86)"

if($sixtyFourBit){
 Start-Process -FilePath "C:\temp\bginfo64.exe" -ArgumentList "C:\temp\syncro-bginfo.bgi /silent /timer0 /nolicprompt" 
}
else {
  Start-Process -FilePath "C:\temp\bginfo.exe" -ArgumentList "C:\temp\syncro-bginfo.bgi /silent /timer0 /nolicprompt"    
}

