#netstat
Get-NetTCPConnection
Get-NetIPAddress –AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress, Type 