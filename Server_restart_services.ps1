

$serviceS_restart = Get-Content -Path c:\temp\Your_server_List.txt
                              #enter your name here    # or un comment the line below 
$services_name = Read-Host " enter your service name " # enter your service name

Foreach ($service_restart in $serviceS_restart) {
Get-Service -Name $services_name  -ComputerName $service_restart | Restart-Service

}