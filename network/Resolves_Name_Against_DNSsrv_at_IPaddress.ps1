#comment 7 - This example resolves a name against the DNS server at 10.0.0.1.
$dnsresolver = Read-Host "Enter the DNS server"
$IPaddess = Read-Host "Enter IP to resolve against"
Resolve-DnsName -Name $dnsresolver -Server $serversIP