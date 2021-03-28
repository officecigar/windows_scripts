###########################################
#comment : get list of servers from text file  
$removeDefenders = Get-Content -Path c:\temp\defenderserverlist.txt

#comment grab each server in the list above 
foreach($removeDefender in $removeDefenders) {
Uninstall-WindowsFeature -Name "Windows-Defender" -ComputerName $removeDefender

#comment : restart server after defender is removed
Restart-Computer -ComputerName $removeDefender -Force


}
############################################ 
