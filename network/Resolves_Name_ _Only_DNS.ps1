#comment 8 - This example resolves a name using only DNS. LLMNR and NetBIOS queries are not issued.
$dnsresolver = Read-Host "Enter server to Resolve DnsName or www.bing.com"
Resolve-DnsName -Name $dnsresolver -DnsOnly
    