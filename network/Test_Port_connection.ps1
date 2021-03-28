#comment 10 - #test port # to remote server
$portnumber = Read-Host "enter port number"
$server = Read-Host "enter Server number"
test-NetConnection -ComputerName $server -Port $portnumber -InformationLevel "Detailed"


