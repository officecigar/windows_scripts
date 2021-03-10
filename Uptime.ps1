 <#
 .SYNOPSIS
 Gets COMPUTER UP Time server  STATUS !!! FUN STUFF
 .EXAMPLE
 'one', 'two', 'three' UPTime.ps1
 .EXAMPLE
 UPTime.ps1 -computername localhost
 .EXAMPLE
 UPTime.ps1 -computername one, two, three
 .EXAMPLE
 get-content <ServerList.txt> or <ServerList.csv> | Netwmi.ps1
 .PARAMETER computername
 one or more computername, or IP address... peace to America!
 #>
 Param(
[Parameter (Mandatory=$true,ValuefromPipeline=$true)]
[string[]] $computername,
[string] $errorlogpath = 'c:\temp\server_Uptime_errors.log'


)begin{
$host.UI.RawUI.WindowTitle = "UP Time"

}
 
process{
foreach ($computer in $computername) {
    
                                 Write-Verbose "about to query $computer"
         try    {
                    $serverislive =$true
                    $who = Get-WMIObject Win32_ComputerSystem -computername $computer | Select-Object -ExpandProperty name ​
                                
                    
                 
                                     $EndTime = get-date 
                                     $StartTime = gwmi win32_operatingsystem -computername $computer | %{ $_.ConvertToDateTime($_.LastBootUpTime) }
                                     $Server_uptime = New-TimeSpan -Start $StartTime -End $EndTime 
                 } catch {
                    $serverislive = $false
                    Write-Verbose "$computer failed wrting to $errorlogpath  "
                    Write-Verbose " Error was $MyErr"
                    $computer | Out-File $errorlogpath -append         

  
                } 
                                 

                                     $props = @{ 'Number of Hours '= $Server_uptime.Minutes ;
                                                 'Number of Minutes '=$Server_uptime.Hours ; 
                                                 'Number of Days ' = $Server_uptime.Days ; }
                                                  
                                                 #'server computername' = $who ;
                                                 #'server name you entered ' = $computer ;}


                            
                                     $obj = New-Object -TypeName PSObject -Property $props

                                       $allthing = $Server_uptime | select Days, Hours, Minutes | Format-Table -AutoSize

                                 $allthing1 =  $who  , $allthing 
                                 Write-Host " "
                                 Write-Output  $allthing1 


     }
 }
 end{}
