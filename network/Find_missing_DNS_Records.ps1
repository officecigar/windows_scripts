#comment 15 find missing DNS records do this before clearing cache
#Get DNS IP from Server & search order
$srvDNS = Read-Host "Enter server name"
$srvDNS 
Write-Host "pullinsg missing records ...please wait"
Start-Sleep -Seconds 7 
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $srvDNS -Filter “IPEnabled=TRUE” | Select DnsServerSearchOrder
Get-DnsClientCache | Format-List -Property * -Force
$MISSINGDNSREC=  Get-DnsClientCache | ? status -eq 9501 | sort Entry |ft -AutoSize
$MISSINGDNSREC