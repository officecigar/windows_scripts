#comment : get list of servers from text file 

$removeDefenders = Get-Content -Path c:\temp\defenderserverlist.txt

#comment grab each server in the list above 
foreach($verify in $removeDefenders) {

#comment : check to see if the role /feature is removed
Get-WindowsFeature -Name "Windows-Defender" -ComputerName $verify | select  name , installed 


}
