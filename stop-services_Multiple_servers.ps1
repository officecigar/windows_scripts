<#
 .SYNOPSIS
 Gets COMPUTER stop different services(s) on differentserver(s) !!! FUN STUFF
 .EXAMPLE
 'one', 'two', 'three' stop-different_services_different_servers.ps1
 .EXAMPLE
 stop-different_services_different_servers.ps1 -computername localhost
 .EXAMPLE
 stop-different_services_different_servers.ps1-computername one, two, three
 .EXAMPLE
 get-content <ServerList.txt> or <ServerList.csv> | Netwmi.ps1
 .PARAMETER computername
 one or more computername, or IP address... peace to America!
 #>

[cmdletbinding()]

Param(
[Parameter (Mandatory=$true,ValuefromPipeline=$true)]
[string []]$computername,
[string]$errorlogpath ='c:\temp\stopservice_errors.log'


)begin{
$host.UI.RawUI.WindowTitle = "Stop different a service on servers"
import-Module ActiveDirectory 



}
process{
foreach ($computer in $computername) {

        Write-Verbose "about to query $computer"
         try    {
                    $IDExist =$true
                        $who = Get-WMIObject Win32_ComputerSystem -computername $computer| Select-Object -ExpandProperty name ​
                        $who

                     $service = Read-Host "Enter name of service"
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