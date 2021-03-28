<#
.SYNOPSIS
get server info to trouble shoot it Updates & Logs !!! FUN STUFF
.EXAMPLE
'one', 'two', 'three' TroubleShoot.ps1
.EXAMPLE
TroubleShoot.ps1 -computername localhost
.EXAMPLE
TroubleShoot.ps1 -computeername one, two, three
.EXAMPLE
get-content <ServerList.txt> or <ServerList.csv> | TroubleShoot.ps1
.PARAMETER computername
one or more computername, or IP address... peace to America!
.LINK
        http://www.mr-itpro.com
 #>


[CmdletBinding(HelpURI='http://google.com')]
 Param(
                [Parameter(Mandatory=$true,ValuefromPipeline=$true, HelpMessage="Please enter the Server name or IP address you want to view info about")]
                [string []]$computername,
                [string]$errorlogpath ='c:\temp\Trouble_Shoot_.log'
 
 
)



begin{
$host.UI.RawUI.WindowTitle = "Trouble Shooting Info "

#$day = Read-Host "how many days do you want to go back for patches"


Write-Host "Please wait this may take a few Minutes..."
    
}




process{



    foreach ($computer in $computername) {


        #Write-Verbose "about to query $computer"
        try    {
                $who = Get-WMIObject Win32_ComputerSystem -computername $computer| Select-Object -ExpandProperty name 
        
               } catch {
                            $computer | Out-File $errorlogpath -append
                        }
                    $starttime =Get-Date
                    $myTop10process=  Get-Process | Sort CPU -descending | Select -first 10 -Property ID,ProcessName,CPU | format-table -autosize
                    #$configs= Get-WindowsFeature | ? { $_.Installed } | ft -AutoSize  
                    $mem=[math]::Round((Get-WmiObject -Class Win32_ComputerSystem  -computer $computer ).TotalPhysicalMemory/1GB) 

                     Write-Host ""
                    
                    #Get-HotFix -ComputerName $computer |?{$_.InstalledOn -gt ((Get-Date).AddDays(-$day))} | ft -AutoSize

                    $patchUpdates = Get-Hotfix  -ComputerName $computer  | ?{$_.InstalledOn -gt "12/31/2019" }  | Sort-Object -Descending InstalledOn | select -first 03 | select Hotfixid , installedon

                    $processesors = Get-WmiObject –class Win32_processor -ComputerName $computer   | select Name, NumberOfCores,NumberOfEnabledCore,NumberOfLogicalProcessors | ft -AutoSize 

                    $logviewError = Get-EventLog -ComputerName $computer -LogName System  -after ([datetime]::Today)   | Where-Object {$_.EntryType -like 'Error' } | ft -AutoSize 

                    $logviewCritical = Get-EventLog -ComputerName $computer -LogName System  -after ([datetime]::Today) | Where-Object{$_.EntryTypentryType -like 'Critical'} | ft -AutoSize 

                    $logviewWarning = Get-EventLog -ComputerName $computer -LogName System  -after ([datetime]::Today)   | Where-Object {$_.EntryType -like 'Warning' } | ft -AutoSize 


                    $LastBootUpTime = gwmi Win32_OperatingSystem -ComputerName $computer  -AsJob
                    Wait-Job $LastBootUpTime.Id   -Timeout 7   # times out after 7 seconds
                    $LastBootUpTime= Receive-Job $LastBootUpTime.Id | Select -Exp LastBootUpTime 
                    $myboot = [System.Management.ManagementDateTimeConverter]::ToDateTime($LastBootUpTime)



                    
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
                    write-host "last reboot/uptime... $myboot"




                    Write-Host "#######################" -ForegroundColor DarkGreen
                    write-Host "Top 10 process running"  
                    Write-Host "#######################" -ForegroundColor DarkGreen
                    write-output $myTop10process
                   












           
        }
}
End{

                    $endtime =Get-Date
                    $total= $endtime -$starttime
                    Write-host "Total Script time to run $total" -ForegroundColor Yellow |ft -AutoSize 

}