#comment 9 - local IPaddress
Get-NetIPAddress    | select  ifindex, ipaddress|FT -AutoSize