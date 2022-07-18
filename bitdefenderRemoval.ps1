Import-Module $env:SyncroModule

C:\Temp\BEST_uninstallTool.exe /bdparams /password=$uninstallpass

Log-Activity -Message "Bitdefender Removed Via Script" -EventName "Uninstall Bitdefender"