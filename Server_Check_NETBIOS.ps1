<#
.SYNOPSIS
Gets COMPUTER BIOS STATUS !!! FUN STUFF
.EXAMPLE
'one', 'two', 'three' Netwmi.ps1
.EXAMPLE
Netwmi.ps1 -computername localhost
.EXAMPLE
Netwmi.ps1 -computeername one, two, three
.EXAMPLE
get-content <ServerList.txt> or <ServerList.csv> | Netwmi.ps1
.PARAMETER computername
one or more computername, or IP address... peace to America!
#>



[cmdletbinding()]
 
Param(
[Parameter (Mandatory=$true,ValuefromPipeline=$true)]
[string []]$computername,
[string]$errorlogpath ='c:\temp\errors.log'
 
 
)



begin{$host.UI.RawUI.WindowTitle = "Check Netbios"

      }
process{
    foreach ($computer in $computername) {
        Write-Verbose "about to query $computer"
        try    {
                $who = Get-WMIObject Win32_ComputerSystem -computername $computer| Select-Object -ExpandProperty name -ErrorAction 
        }catch {
                $computer |Out-File $errorlogpath -append
        }
                $Domain = Get-WmiObject -Class Win32_ComputerSystem -computername $computer
                $netBT = Get-WmiObject -Class Win32_NetworkAdapterConfiguration -computername $computer | Where {$_.IPEnabled -eq "true"} | select TcpipNetbiosOptions
                $props = @{'computername' = $computer
                  'Netbios Status' = if ($netBT.TcpipNetbiosOptions -eq "2") {'DISABLED' } Else  {'ENABLED'} ;   
                   
                   'Server Name' = $who;
                   'DOMAIN'= $Domain.domain;}
                   
                $obj = New-Object -TypeName PSObject -Property $props
    
           Write-Output $obj

           
        }

      
}
End{



}