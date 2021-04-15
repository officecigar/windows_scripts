#comment 5 - Get DNS IP from Server & search order
$srvDNS = Read-Host "Enter server to get DNS IP & search order"
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $srvDNS -Filter “IPEnabled=TRUE” | Select DnsServerSearchOrder