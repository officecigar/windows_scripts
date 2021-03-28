#comment 11 - test connection to remote server
$server = Read-Host "enter server to tracert"
Test-NetConnection -ComputerName $server -TraceRoute 