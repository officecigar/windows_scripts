<#
.SYNOPSIS
add service acct to the server !!! FUN STUFF
.EXAMPLE
'one', 'two', 'three' Netwmi.ps1
.EXAMPLE
Netwmi.ps1 -computername localhost
.EXAMPLE
Netwmi.ps1 -computeername one, two, three
.EXAMPLE
get-content <ServerList.txt> or <ServerList.csv> | addservice_local_server.ps1
.PARAMETER computername
one or more computername, or IP address... peace to America!
#>



[cmdletbinding()]
 
Param(
[Parameter (Mandatory=$true,ValuefromPipeline=$true)]
[string []]$computername,
[string]$errorlogpath ='c:\temp\svraccterrors.log'
 
 
)



begin{}
process{
    foreach ($computer in $computername) {


        Write-Verbose "about to query $computer"
        try    {
                $who = Get-WMIObject Win32_ComputerSystem -computername $computer| Select-Object -ExpandProperty name 
        }catch {
                $computer | Out-File $errorlogpath -append
        }
                $Domain = Get-WmiObject -Class Win32_ComputerSystem -computername $computer




    Install-WindowsFeature -Name "RSAT-AD-PowerShell"
    Import-Module -Name "ActiveDirectory"
    Install-ADServiceAccount -Identity "s_$env:COMPUTERNAME"
                
                
                
                $props = @{'computername' = $computer;
                           
                           'Server Name we founded :' = $who;
                           'DOMAIN'= $Domain.domain;}


                   
                $obj = New-Object -TypeName PSObject -Property $props
    
           Write-Output $obj | Format-Table -AutoSize

           
        }
}
End{}
