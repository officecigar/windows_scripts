Param(

[Parameter (Mandatory=$true,ValuefromPipeline=$true)]
[string []]$computername,
[string]$errorlogpath ='c:\temp\sql_check_error.log'
 
 
)



begin{
  $host.UI.RawUI.WindowTitle = "SQL Version Check"
  $starttime =Get-Date
  Write-host "script start time $starttime "  -ForegroundColor yellow |ft -AutoSize 

}




process{
    foreach ($computer in $computername) {


        Write-Verbose "about to query $computer"
        try    {
                $who = Get-WMIObject Win32_ComputerSystem -computername $computer| Select-Object -ExpandProperty name 
        $who
               } catch {
                            $computer | Out-File $errorlogpath -append
                        }
                            Write-Host ""
                            Write-host "#######################" -ForegroundColor darkGreen
                            Write-host $computer  -ForegroundColor Yellow 
                            Write-host "#######################" -ForegroundColor darkGreen
                               
                                  Invoke-Command $computer -scriptblock {

                                  IF (Test-path 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL') {
                                            write-host “SQL is INSTALLED ”

                                             $SQLinst = (get-itemproperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server').InstalledInstances
                                    foreach ($SQL in $SQLinst)
                                    {
                                       $p = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL').$SQL
                                       (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Edition
                                       (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$p\Setup").Version
                                       }

                                                                  } Else {
                                            write-host “SQL is NOT installed”

                                                                                              
                                                                    }

        }
    }
}

End{
 Write-Output ""
  $endtime =Get-Date
  $total= $endtime -$starttime
  Write-host "Total time for this script to run is  $total"  -ForegroundColor yellow |ft -AutoSize 
Write-Output ""
}