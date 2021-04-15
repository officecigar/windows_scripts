#comment 10 - #test port # to remote server
$portnumber = Read-Host "enter port Number"
$server = Read-Host "enter Server Name"
test-NetConnection -ComputerName $server -Port $portnumber -InformationLevel "Detailed"


