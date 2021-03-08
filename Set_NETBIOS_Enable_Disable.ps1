<#
 .SYNOPSIS
 Gets COMPUTER Set NetBIOS STATUS !!! FUN STUFF
 .EXAMPLE
 'one', 'two', 'three' Set_Netbios.ps1
 .EXAMPLE
 Set_Netbio.ps1 -computername localhost
 .EXAMPLE
 Set_Netbio.ps1 -computeername one, two, three
 .EXAMPLE
 get-content <ServerList.txt> or <ServerList.csv> | Set_Netbio.ps1
 .PARAMETER computername
 one or more computername, or IP address... peace to America!
 #>





[cmdletbinding()]

Param(
[Parameter (Mandatory=$true,ValuefromPipeline=$true)]
[string []]$computername,
[string]$errorlogpath ='c:\temp\Set_netbios_errors.log'


)

begin{
$host.UI.RawUI.WindowTitle = "Set Netbios"
$grab = Read-Host "Please enter 1 to Enable or 2 for Disable."
}
process{
foreach ($computer in $computername) {
        
                                         Write-Verbose "about to query $computer"
         try    {
                    $serverislive =$true

                        $who = Get-WMIObject Win32_ComputerSystem -computername $computer| Select-Object -ExpandProperty name ​
        

                    } catch {
                                $serverislive = $false
                                Write-Verbose "$computer failed wrting to $errorlogpath  "
                                Write-Verbose " Error was $MyErr"
                                $computer | Out-File $errorlogpath -append         

                            } 


        
                        $IgotInput= $grab

                        $nic = Get-WmiObject Win32_NetworkAdapterConfiguration -computername $computer -filter "ipenabled = 'true'" | Select-Object -ExcludeProperty *
                        $nicview = $nic.SetTcpipNetbios($IgotInput) | select "-"
                        

                        $who = Get-WMIObject Win32_ComputerSystem -computername $computer| Select-Object -ExpandProperty name ​
                        
                        $netBT =Get-WmiObject -Class Win32_NetworkAdapterConfiguration -computername $computer | Where {$_.IPEnabled -eq "true"} | select TcpipNetbiosOptions
                        $Domain = Get-WmiObject -Class Win32_ComputerSystem -computername $computer


                $props = @{'computername' = $computer;
                            
                            'Netbios Status' = $netBT.TcpipNetbiosOptions;  
                            'DOMAIN'= $Domain.domain; 
                            'ServerName'=$who;}
   
                $obj = New-Object -TypeName PSObject -Property $props
    
       Write-output $obj 
     }
 }
 end{}
