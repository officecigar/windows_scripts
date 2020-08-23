<#
.SYNOPSIS
Think powershell think Mr-ITpro.com !!! FUN STUFF
.EXAMPLE
'one', 'two', 'three' TonyB_default.ps1
.EXAMPLE
TonyB_default.ps1 -computername localhost
.EXAMPLE
TonyB_default.ps1 -computername one, two, three
.EXAMPLE
get-content <Somelist.txt> or <anylist.csv> | TonyB_default.ps1
.PARAMETER computername
one or more computername, or IP address... peace to America!
.LINK
       https://github.com/officecigar/windows_scripts/blob/master/serverhealth5.ps1
 #>

#################################################################################
# get all the servers in your domain
#
################################################################################
$starttime = Get-Date
$whatdomain = Get-ADDomain | Select-Object dnsroot | ForEach-Object {$_.dnsroot}

$adserverlist = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' ` -Properties dnshostname | Sort-Object -Property Operatingsystem |Select-Object -Property dnshostname | ForEach-Object {$_.dnshostname   }
$adserverlist | ft -AutoSize -HideTableHeaders | Out-File "C:\temp\$whatdomain.serverlist.txt"
$ServerInputFile = "C:\temp\$whatdomain.serverlist.txt"
sleep 3

#################################################################################
# server list is in being imported and beginning grabbing number of CPU, total ram count, C:\ drive Frees DISK space, averages for CPU usage, & averages for memory  usage
#
################################################################################
$ServerList = Get-Content "C:\temp\$whatdomain.serverlist.txt"                  
$ReportFilePath = "C:\temp\$whatdomain.Report.html"
$Result = @()


ForEach($ComputerName in $ServerList)
{$ComputerName

  if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet){
   
   $PingStatus= "Up"
  }
  else{
    
     $PingStatus= "Down"
  }

  $Timeout = 10 
  $timer = [Diagnostics.Stopwatch]::StartNew()
  $timer.Stop()

if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
$AVGProc = Get-WmiObject -computername  $ComputerName win32_processor | Measure-Object -property LoadPercentage -Average  | Select Average 
Write-Host "throw 'Action did not complete before timeout period."

} else {
Write-Verbose -Message 'Action completed before the timeout period.'
}

if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
$vol = Get-WmiObject -Class win32_Volume -ComputerName $ComputerName -Filter "DriveLetter = 'C:'" | Select-object @{Name = "C PercentUsed"; Expression = {“{0:N2}”   -f ($_.freespace/1GB) } } 
Write-Host "throw 'Action did not complete before timeout period."

} else {
Write-Verbose -Message 'Action completed before the timeout period.'
}


if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
$OS = gwmi -Class win32_operatingsystem -computername $ComputerName | Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }}

Write-Host "throw 'Action did not complete before timeout period."

} else {
Write-Verbose -Message 'Action completed before the timeout period.'
}

if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
$totalVol = Get-WmiObject -class Win32_Volume -ComputerName $ComputerName -Filter "DriveLetter = 'C:'"  | Select-Object @{Name="C Capacity";Expression = {“{0:N2}”  -f ($_.Capacity/1GB) }} 
Write-Host "throw 'Action did not complete before timeout period."

} else {
Write-Verbose -Message 'Action completed before the timeout period.'
}


if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
$lastpatch = Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $ComputerName | Select-object -Property installedon | ForEach-Object {$_.installedon   }  | select -last 03 | Sort-Object -Descending 

Write-Host "throw 'Action did not complete before timeout period."

} else {
Write-Verbose -Message 'Action completed before the timeout period.'
}

if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
$LatestPatchInformation = Get-WmiObject -Class Win32_QuickFixEngineering -ComputerName $ComputerName | Select-object -Property hotfixid | ForEach-Object {$_.hotfixid   }  | select -Last 03 | Sort-Object -Descending 

Write-Host "throw 'Action did not complete before timeout period."

} else {
Write-Verbose -Message 'Action completed before the timeout period.'
}

if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
$LastBootUpTime= Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName  | Select -Exp LastBootUpTime 

Write-Host "throw 'Action did not complete before timeout period."

} else {
Write-Verbose -Message 'Action completed before the timeout period.'
}


if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
$myboot = [System.Management.ManagementDateTimeConverter]::ToDateTime($LastBootUpTime)

Write-Host "throw 'Action did not complete before timeout period."

} else {
Write-Verbose -Message 'Action completed before the timeout period.'
}

$totalCPuCount = Get-WmiObject -class Win32_ComputerSystem -ComputerName $ComputerName 


if ($timer.Elapsed.TotalSeconds -gt $Timeout) {
$Sockets=$totalCPuCount.numberofprocessors

Write-Host "throw 'Action did not complete before timeout period."

} else {
Write-Verbose -Message 'Action completed before the timeout period.'
}


$Cores=$totalCPuCount.numberoflogicalprocessors



$PysicalMemory = [Math]::Round((Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName).TotalPhysicalMemory/1GB)



$windowsVersions =(Get-WmiObject -class Win32_OperatingSystem -ComputerName $ComputerName).Caption

  

 $virtualorPhysical = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName | Select-Object Manufacturer | ForEach-Object {$_.Manufacturer} 
 $virtual ="VMware, Inc."
 $virtual1 ="Manufacturer : VMware, Inc."
 
  if (Compare-Object "$virtualorPhysical" "$virtual" )
  {
   
   "$virtualorPhysical"

  }
 
  else{
    
   "$virtualorPhysical"
  }
 


 



#################################################################################
# building new object classes for HTML 
#
################################################################################

 
$starttime

$Result += [PSCustomObject] @{

        ServerName = "$ComputerName"

        CPULoad = $AVGProc.Average

        MemLoad = $OS.MemoryUsage

        CDrive = $vol.'C PercentUsed'

        CCapacity = $totalVol.'C Capacity'

        TotalCPUCount= $Cores

        totalMemCount= $PysicalMemory

        LAstBootTime=$myboot

        OSVersion= $windowsVersions
        
        patched_date=$lastpatch 

        PINGtest = $PingStatus

        VirtulorPhysical = $virtualorPhysical

        LastKB = $LatestPatchInformation
        

    }

 
#################################################################################
# building HTML file with the Columns &  loading the data into HTML file
#
################################################################################
    $OutputReport = "<HTML><TITLE>$whatdomain Server Health Report </TITLE>
                     <BODY>
                     <font color =""#99000"">
                     <H2><B>Current Domain: $whatdomain </B></H2></font>
                     <H2><B>Daily Health Check Report</B></H2></font>
                     <Table border=2 cellpadding=4 cellspacing=3>
                     <TR bgcolor=D1D0CE align=center>
                       <TD><B>Server</B></TD>
                       <TD><B>Current Avg. CPU Usage</B></TD>
                       <TD><B>Current Avg. Memory Usage</B></TD>
                       <TD><B>Total Free DiskSpace C:\</B></TD>
                       <TD><B>Total Diskspace Capacity of C:\ </B></TD>
                       <TD><B>Total Number  CPUs</B></TD>
                        <TD><B>Total RAM</B></TD>
                        <TD><B>Last Reboot Time</B></TD>
                         <TD><B>OS Version</B></TD>
                         
                        <TD><B>Server Up or Down</B></TD> 
                        <TD><B>Virtual or Physical</B></TD> 
                        
                        <TD><B>Last KB</B></TD>
                        <TD><B>Last Patch date</B></TD>
                          
                         
                                                 
                       </TR>"

                       

    Foreach($Entry in $Result)

    {

          #change the raw-data to %s

          $CPUAsPercent = "$($Entry.CPULoad)%"

          $MemAsPercent = "$($Entry.MemLoad)%"

          $CDriveAsPercent = "$($Entry.CDrive)"
          $CCapacitydrive = "$($Entry.CCapacity)"


          $TCPUCount="$($Entry.TotalCPUCount)"

          $TMemCount= "$($Entry.totalMemCount)"

          $mybootime = "$($Entry.LAstBootTime)"

          $patcheddate = "$($Entry.patched_date)"

          $OSVersion = "$($Entry.OSVersion)"

          $PingStatus = "$($Entry.PINGtest)"

          $virtualorPhysical="$($Entry.VirtulorPhysical)"

          $LatestPatchInformation ="$($Entry.LastKB)"


          $OutputReport += "<TR><TD>$($Entry.Servername)</TD>"

#################################################################################
# loading the data into HTML file
#
################################################################################
# check CPU load

          if(($Entry.CPULoad) -ge 60)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($CPUAsPercent)</TD>"

          }

          elseif((($Entry.CPULoad) -ge 50) -and (($Entry.CPULoad) -lt 59))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($CPUAsPercent)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($CPUAsPercent)</TD>"

          }

         

 
#################################################################################
# check RAM load

          if(($Entry.MemLoad) -ge 70)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($MemAsPercent)</TD>"

          }

          elseif((($Entry.MemLoad) -ge 50) -and (($Entry.MemLoad) -lt 59))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($MemAsPercent)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($MemAsPercent)</TD>"

          }

 
#################################################################################
# check C: Drive Usage

          if(($Entry.CDrive) -le 1.00)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($CDriveAsPercent)</TD>"

          }

          elseif((($Entry.CDrive) -ge 2.0) -and (($Entry.CDrive) -lt 1.50))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($CDriveAsPercent)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($CDriveAsPercent)</TD>"

          }





################################################################################
# C  drive capacity  

          if(($Entry.CCapacity) -le 2)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($CCapacitydrive)</TD>"

          }

          elseif((($Entry.CCapacity) -gt 2) -and (($Entry.CCapacity) -le 10))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($CCapacitydrive)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($CCapacitydrive)</TD>"

          } 
 

#################################################################################
# check CPU Count

          if(($Entry.TotalCPUCount) -lt 2)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($TCPUCount)</TD>"

          }

          elseif((($Entry.TCPUCount) -ge 2) -and (($Entry.TCPUCount) -lt 4))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($TCPUCount)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($TCPUCount)</TD>"

          }

 

#################################################################################
# check Total Memory

          if(($Entry.totalMemCount) -lt 2)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($TMemCount)</TD>"

          }

          elseif((($Entry.totalMemCount) -ge "2") -and (($Entry.totalMemCount) -le 4))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($TMemCount)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($TMemCount)</TD>"

           }




#################################################################################
# # My last boot up time

          if(($Entry.LAstBootTime) -le 3)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($mybootime)</TD>"

          }

          elseif((($Entry.LAstBootTime) -ge 3) -and (($Entry.LAstBootTime) -lt 3))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($mybootime)</TD>"


          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($mybootime)</TD>"

          }

 

#################################################################################
## OS Version
              

            if(($Entry.OSVersion) -eq  " Microsoft Windows Server 2008 Standard")
          

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($OSVersion)</TD>"

          }

          elseif((($Entry.OSVersion) -ne "Microsoft Windows Server 2019 Datacenter Evaluation") -and (($Entry.OSVersion) -ne "Microsoft Windows Server 2016 Standard Evaluation"))
          
          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($OSVersion)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($OSVersion)</TD>"

           }



#################################################################################
# Server ping test

          if(($Entry.PINGtest) -ne "UP")

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($PingStatus)</TD>"

          }

          elseif((($Entry.PINGtest) -gt 1.0) -and (($Entry.PINGtest) -lt 1.90))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($PingStatus)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($PingStatus)</TD>"

          }



#################################################################################
# Is it Virtual or Physical

          if(($Entry.VirtulorPhysical) -ne "VMware, Inc.")

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($virtualorPhysical)</TD>"

          }

          elseif((($Entry.VirtulorPhysical) -ne "VMware, Inc.") -and (($Entry.VirtulorPhysical) -ne  "Nutanix"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($virtualorPhysical)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($virtualorPhysical)</TD>"

          }

#################################################################################
# last KB

          if(($Entry.LastKB) -like " ")
           
          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($LatestPatchInformation)</TD>"

          }

          elseif((($Entry.LastKB) -ne "@{HotFix*") -and (($Entry.LastKB) -ne "HotFix"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($LatestPatchInformation)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($LatestPatchInformation)</TD>"

          }



#################################################################################
# check PATCHED 

          if(($Entry.patched_date) -ge 3)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($patcheddate)</TD>"

          }

          elseif((($Entry.patched_date) -ge 3) -and (($Entry.patched_date) -lt 3))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($patcheddate)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($patcheddate)</TD>"

          }








#################################################################################
#  






          $OutputReport += "</TR>"

    }

 sleep 2

    $OutputReport += "</Table></BODY>
    <p>Script started at: $starttime </p>
    <p>Script ended at:   $endtime</p> 
    <p>Script total time: $total</p></font>
   </HTML>"


}

 

$OutputReport | out-file $ReportFilePath

$endtime =Get-Date
$total= $endtime -$starttime
Write-host "Total Script time to run $total" -ForegroundColor Yellow | ft -AutoSize 

Invoke-Expression $ReportFilePath
