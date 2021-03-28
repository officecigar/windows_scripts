#comment 2 - Get routes for a specified interface
Get-NetIPAddress | select  ifindex, ipaddress| FT -AutoSize 
$interfaceNumber = Read-Host "enter interface number"
Get-NetRoute –InterfaceIndex $interfaceNumber