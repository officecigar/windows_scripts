#comment 6 - This example resolves a name using the default options.
$dnsresolver = Read-Host "Enter server to Resolve DnsName or www.bing.com"
Resolve-DnsName –Name $dnsresolver