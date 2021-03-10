<#
.SYNOPSIS
get server info to trouble shoot it Updates & Logs !!! FUN STUFF
.EXAMPLE
'one', 'two', 'three' TroubleShootLogs.ps1
.EXAMPLE
TroubleShootLogs.ps1 -computername localhost
.EXAMPLE
TroubleShootLogs.ps1 -computeername one, two, three
.EXAMPLE
get-content <ServerList.txt> or <ServerList.csv> | TroubleShootLogs.ps1
.PARAMETER computername
one or more computername, or IP address... peace to America!
#>



[cmdletbinding()]
 
Param(
[Parameter (Mandatory=$true,ValuefromPipeline=$true)]
[string []]$computername,
[string]$errorlogpath ='c:\temp\Trouble_Shoot_.log'
 
 
)



begin{
$host.UI.RawUI.WindowTitle = "Trouble Shooting "

$day = Read-Host "how many days do you want to go back for patches"

}




process{
    foreach ($computer in $computername) {


        Write-Verbose "about to query $computer"
        try    {
                $who = Get-WMIObject Win32_ComputerSystem -computername $computer| Select-Object -ExpandProperty name 
        
               } catch {
                            $computer | Out-File $errorlogpath -append
                        }
                    $starttime =Get-Date
                   
                    $configs= Get-WindowsFeature | ? { $_.Installed } | ft -AutoSize  
                    $mem=[math]::Round((Get-WmiObject -Class Win32_ComputerSystem  -computer $computer ).TotalPhysicalMemory/1GB) 

                     Write-Host ""
                    
                    Get-HotFix -ComputerName $computer |?{$_.InstalledOn -gt ((Get-Date).AddDays(-$day))} | ft -AutoSize

                    $patchUpdates = (get-hotfix -ComputerName $computer -Description update*  | sort installedon)[-1] | ft -AutoSize


                    $processesors = Get-WmiObject –class Win32_processor -ComputerName $computer   | select Name, NumberOfCores,NumberOfEnabledCore,NumberOfLogicalProcessors | ft -AutoSize 

                    $logviewError = Get-EventLog -ComputerName $computer -LogName System  -after ([datetime]::Today)   | Where-Object {$_.EntryType -like 'Error' } | ft -AutoSize 

                    $logviewCritical = Get-EventLog -ComputerName $computer -LogName System  -after ([datetime]::Today) | Where-Object{$_.EntryTypentryType -like 'Critical'} | ft -AutoSize 

                    $logviewWarning = Get-EventLog -ComputerName $computer -LogName System  -after ([datetime]::Today)   | Where-Object {$_.EntryType -like 'Warning' } | ft -AutoSize 


                    Write-Host ""
                    Write-Host "#######################" -ForegroundColor DarkGreen
                    write-output $computer 
                    Write-Host "#######################" -ForegroundColor DarkGreen

                    Write-Output $processesors

                    Write-Output "$mem GB of Ram on $computer"

                    write-output $configs

                    write-output $computer  $patchSecurity
                    write-output $patchUpdates 

                    write-output $logviewCritical
                    write-output $logviewWarning
                    write-output $logviewError


           
        }
}
End{

                    $endtime =Get-Date
                    $total= $endtime -$starttime
                    Write-host "Total Script time to run $total" -ForegroundColor Yellow |ft -AutoSize 

}