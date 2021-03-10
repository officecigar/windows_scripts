
<#
 .SYNOPSIS
 Gets COMPUTER Stop same service(s)  !!! FUN STUFF
 .EXAMPLE
 'one', 'two', 'three' stop-same_service_across_servers.ps1
 .EXAMPLE
 stop-same_service_across_servers.ps1 -computername localhost
 .EXAMPLE
 stop-same_service_across_servers.ps1 -computername one, two, three
 .EXAMPLE
 get-content <ServerList.txt> or <ServerList.csv> | Netwmi.ps1
 .PARAMETER computername
 one or more computername, or IP address... peace to America!
 #>

[cmdletbinding()]

Param(
[Parameter (Mandatory=$true,ValuefromPipeline=$true)]
[string []]$computername,
[string]$errorlogpath ='c:\temp\stop-same_service_across_servers_errors.log'


)begin{
$host.UI.RawUI.WindowTitle = "stop the same service on servers"
import-Module ActiveDirectory 

$service = Read-Host "Enter name of service"

}
process{
foreach ($computer in $computername) {

        Write-Verbose "about to query $computer"
         try    {
                    $IDExist =$true
                        $who = Get-WMIObject Win32_ComputerSystem -computername $computer| Select-Object -ExpandProperty name ​
                        $who

                     
                     Get-Service -ComputerName $computer -Name  $service | stop-Service 
                     $service

                 } catch    {
                           
                             $IDExist = $false
                             Write-Verbose "$computer failed wrting to $errorlogpath  "
                             Write-Verbose " Error was $MyErr"
                             $computer | Out-File $errorlogpath -append         

                           }    

                                }
 }
 end{}