﻿#################################################################################
# get all the servers in your domain and output to a txt file and clean txt file by removing spaces and blanks lines.
#
################################################################################
$adserverlist = Get-ADComputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' ` -Properties Name| Sort-Object -Property Operatingsystem |Select-Object -Property Name
#$adserverlist = Get-ADComputer -Filter {OperatingSystem -like "*windows*server*"} -Properties * | sort name | ft Name
$adserverlist | ft -AutoSize -HideTableHeaders | Out-File "C:\temp\00serverlist.txt"
Get-Content -path C:\temp\00ServerList.txt | Select-Object -Skip 1  | Out-File C:\temp\01ServerList.txt

$InputFile = 'C:\temp\01ServerList.txt'
sleep 3
write-host "Please wait cleaning up text file by removing spaces... file name le $InputFile"
$content = Get-Content $InputFile
$content | Foreach {$_.TrimEnd()  } | Set-Content C:\temp\ServerList.txt

write-host ""
write-host "Cleaning is finished!"
sleep 2
start-process "cmd.exe" "/c C:\temp\blanlines.bat"
sleep 5


#################################################################################
# server list is in being imported and beginning grabbing number of CPU, total ram count, C:\ drive Frees DISK space, averages for CPU usage, & averages for memory  usage
#
################################################################################
$ServerListFilePath = "C:\temp\serverlist.txt"
$ServerList = Get-Content $ServerListFilePath -ErrorAction SilentlyContinue
$ReportFilePath = "C:\temp\Report.html"
$Result = @()


ForEach($ComputerName in $ServerList)
{

$AVGProc = Get-WmiObject -computername $ComputerName win32_processor | Measure-Object -property LoadPercentage -Average | Select Average

$OS = gwmi -Class win32_operatingsystem -computername $ComputerName | Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }}

$vol = Get-WmiObject -Class win32_Volume -ComputerName $ComputerName -Filter "DriveLetter = 'C:'" |

Select-object @{Name = "C PercentUsed"; Expression = {“{0:N2}”   -f ($_.freespace/1GB) } }

$lastpatch = Get-WmiObject -ComputerName $ComputerName Win32_Quickfixengineering | select  @{Name="InstalledOn";Expression={$_.InstalledOn -as [datetime]}} | Sort-Object -Property Installedon | select-object -property installedon -last 1
$lastpatch =Get-Date $lastpatch.InstalledOn -format MM-dd-yyyy

$LastBootUpTime= Get-WmiObject Win32_OperatingSystem -ComputerName $ComputerName  | Select -Exp LastBootUpTime

$myboot = [System.Management.ManagementDateTimeConverter]::ToDateTime($LastBootUpTime)

$totalCPuCount = Get-WmiObject -class Win32_ComputerSystem -ComputerName $ComputerName
$Sockets=$totalCPuCount.numberofprocessors
$Cores=$totalCPuCount.numberoflogicalprocessors

$PysicalMemory = [Math]::Round((Get-WmiObject -Class Win32_ComputerSystem -ComputerName $ComputerName).TotalPhysicalMemory/1GB)

$windowsVersions =(Get-WmiObject -class Win32_OperatingSystem -ComputerName $ComputerName).Caption

  if (Test-Connection -ComputerName $ComputerName -Count 1 -ErrorAction SilentlyContinue){
   #$pingServer+= "$ComputerName,up"
   $PingStatus= "Up"
  }
  else{
    #$pingServer+= "$ComputerName,down"
     $PingStatus= "Down"
  }
  


#################################################################################
# building new object classes for HTML 
#
################################################################################

$company = "CHC"

$Result += [PSCustomObject] @{

        ServerName = "$ComputerName"

        CPULoad = $AVGProc.Average

        MemLoad = $OS.MemoryUsage

        CDrive = $vol.'C PercentUsed'

        TotalCPUCount= $Cores

        totalMemCount= $PysicalMemory

        LAstBootTime=$myboot

        OSVersion= $windowsVersions
        
        patched_date=$lastpatch 

        PINGtest = $PingStatus

        

    }

 
#################################################################################
# building HTML file with the Columns &  loading the data into HTML file
#
################################################################################
    $OutputReport = "<HTML><TITLE>Server Health Report</TITLE>

                     <BODY>

                     <font color =""#99000"">

                     <H2>$company Weekly Server Health Check Report</H2></font>

                     <Table border=2 cellpadding=4 cellspacing=3>

                     <TR bgcolor=D1D0CE align=center>

                       <TD><B>Server</B></TD>

                       <TD><B>Avg.CPU Usage</B></TD>

                       <TD><B> Avg. Memory Usage</B></TD>

                       <TD><B>Free DiskSpace c:\</B></TD>

                       <TD><B>Total #  CPUs</B></TD>

                        <TD><B>Total RAM</B></TD>

                        <TD><B>Last Boot Time</B></TD>

                         <TD><B>OS Version</B></TD>
                         
                        <TD><B>Server up or down</B></TD> 
                        
                        <TD><B>Last Patch date</B></TD>

                          
                         
                                                 
                       </TR>"

                       

    Foreach($Entry in $Result)

    {

          #change the raw-data to %s

          $CPUAsPercent = "$($Entry.CPULoad)%"

          $MemAsPercent = "$($Entry.MemLoad)%"

          $CDriveAsPercent = "$($Entry.CDrive)"

          $TCPUCount="$($Entry.TotalCPUCount)"

          $TMemCount= "$($Entry.totalMemCount)"

          $mybootime = "$($Entry.LAstBootTime)"

          $patched_date = "$($Entry.patched_date)"

          $OSVersion = "$($Entry.OSVersion)"

          $PingStatus = "$($Entry.PINGtest)"

          $OutputReport += "<TR><TD>$($Entry.Servername)</TD>"

#################################################################################
# loading the data into HTML file
#
################################################################################

          # check CPU load

          if(($Entry.CPULoad) -eq '%')

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($CPUAsPercent)</TD>"

          }

          elseif((($Entry.CPULoad) -ge 100) -and (($Entry.CPULoad) -lt 90))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($CPUAsPercent)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($CPUAsPercent)</TD>"

          }

         

 

          # check RAM load

          if(($Entry.MemLoad) -eq "10")

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($MemAsPercent)</TD>"

          }

          elseif((($Entry.MemLoad) -ge 79) -and (($Entry.MemLoad) -lt 90))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($MemAsPercent)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($MemAsPercent)</TD>"

          }

 

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

 

 

          # check CPU Count

          if(($Entry.TotalCPUCount) -ge 99)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($TCPUCount)</TD>"

          }

          elseif((($Entry.TCPUCount) -ge 1) -and (($Entry.TCPUCount) -lt 1))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($TCPUCount)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($TCPUCount)</TD>"

          }

 

          # check Total Memory

          if(($Entry.totalMemCount) -lt 2)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($TMemCount)</TD>"

          }

          elseif((($Entry.totalMemCount) -ge "2.1") -and (($Entry.totalMemCount) -lt 3))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($TMemCount)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($TMemCount)</TD>"

           }
          # My last boot up time

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

 

           # OS Version
              

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





# check PATCHED 

          if(($Entry.patched_date) -ge 3)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($patched_date)</TD>"

          }

          elseif((($Entry.patched_date) -ge 3) -and (($Entry.patched_date) -lt 3))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($patched_date)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($patched_date)</TD>"

          }




















          $OutputReport += "</TR>"

    }

 

    $OutputReport += "</Table></BODY></HTML>"

}

 

$OutputReport | out-file $ReportFilePath

Invoke-Expression $ReportFilePath