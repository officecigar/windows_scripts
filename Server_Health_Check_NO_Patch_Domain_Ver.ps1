﻿<#
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
$host.UI.RawUI.WindowTitle = "Server Health Check NO Patch Domain Version." 

$starttime = Get-Date
$whatdomain = Get-ADDomain | Select-Object dnsroot | ForEach-Object {$_.dnsroot}


$ServerCount=(Get-ADComputer -Filter 'operatingsystem -like "Windows *server*" -and enabled -eq "true"').count
$adserverlist = Get-ADComputer -Filter 'operatingsystem -like "Windows *server*" -and enabled -eq "true"' ` -Properties dnshostname | Sort-Object -Property Operatingsystem |Select-Object -Property dnshostname | ForEach-Object {$_.dnshostname   }
$adserverlist | ft -AutoSize -HideTableHeaders | Out-File "C:\temp\$whatdomain.serverlist.txt"
$ServerList =  Get-Content "C:\temp\$whatdomain.serverlist.txt"




#$ServerList = Get-Content "C:\temp\testserverlist.txt"    ##input              
$ReportFilePath = "C:\temp\$whatdomain.serverlist.Report.html"  #output file
$Result = @()

ForEach($ComputerName in $ServerList)
{$ComputerName

  if (Test-Connection -ComputerName $ComputerName -Count 1 -Quiet){
   
   $PingStatus= "Up"
  }
  else{
    
     $PingStatus= "Down"
  }

#################################################################################
# running commandlets as job to bypass some RPC errors to speed the script up 
#
################################################################################
$AVGProc =  gwmi win32_processor -computername $ComputerName -AsJob 
Wait-Job $AVGProc.Id   -Timeout 5 # times out after 5 seconds
 #Measure-Object -property LoadPercentage -Average | Select Average 
 $AVGProc = Receive-Job $AVGProc.Id | Measure-Object -property LoadPercentage -Average | Select Average 

 $vol = gwmi -Class win32_Volume -ComputerName $ComputerName -Filter "DriveLetter = 'C:'" -AsJob 
 Wait-Job $vol.Id   -Timeout 5 # times out after 5 seconds 
 $vol = Receive-Job $vol.Id | Select-object @{Name = "C PercentUsed"; Expression = {“{0:N2}”   -f ($_.freespace/1GB) } } 

$OS = gwmi -Class win32_operatingsystem -computername $ComputerName -AsJob 
Wait-Job $OS.Id   -Timeout 5 # times out after 5 seconds
$OS= Receive-Job $OS.Id |  Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }}

$totalVol = gwmi -class Win32_Volume -ComputerName $ComputerName -Filter "DriveLetter = 'C:'"  -AsJob
Wait-Job $totalVol.Id   -Timeout 5 # times out after 5 seconds
$totalVol= Receive-Job $totalVol.Id | Select-Object @{Name="C Capacity";Expression = {“{0:N2}”  -f ($_.Capacity/1GB) }} 




$lastpatch = gwmi -Class Win32_QuickFixEngineering -ComputerName $ComputerName | Select-object -Property installedon | ForEach-Object {$_.installedon  } | Sort-Object -Descending | select -last 03 
$LatestPatchInformation = gwmi -Class Win32_QuickFixEngineering -ComputerName $ComputerName | Select-object -Property Hotfixid | ForEach-Object {$_.Hotfixid   }  | Sort-Object -Descending | select -last 03 




<#$lastpatch = gwmi -Class Win32_QuickFixEngineering -ComputerName $ComputerName | Select-object -Property installedon | ForEach-Object {$_.installedon   }  | select -last 03 | Sort-Object -Descending 
$LPD =Get-HotFix -ComputerName $ComputerName  
$lastpatch = gwmi -Class Win32_QuickFixEngineering -ComputerName $ComputerName | Select-object -Property installedon | ForEach-Object {$_.installedon  } | Sort-Object -Descending | Select-Object -first 03 

$LatestPatchInformation = gwmi -Class Win32_QuickFixEngineering -ComputerName $ComputerName | Select-object -Property Hotfixid | ForEach-Object {$_.Hotfixid   }  | select -last 03 | Sort-Object -Descending 
#$LPD | where {$_.InstalledOn -gt "01/01/201" } | Select-Object Hotfixid -First 3



#Select-object -Property hotfixid | ForEach-Object {$_.hotfixid -and $_.InstalledOn  }  | select -Last 03 | Sort-Object -Descending 
#>

$LastBootUpTime = gwmi Win32_OperatingSystem -ComputerName $ComputerName  -AsJob
Wait-Job $LastBootUpTime.Id   -Timeout 7   # times out after 7 seconds
$LastBootUpTime= Receive-Job $LastBootUpTime.Id | Select -Exp LastBootUpTime 





$myboot = [System.Management.ManagementDateTimeConverter]::ToDateTime($LastBootUpTime)

$totalCPuCount = gwmi -class Win32_ComputerSystem -ComputerName $ComputerName -AsJob
Wait-Job $totalCPuCount.Id   -Timeout 5   # times out after 5 seconds

$totalCPuCount= Receive-Job $totalCPuCount.Id
$Sockets=$totalCPuCount.numberofprocessors 
$Cores=$totalCPuCount.numberoflogicalprocessors
$PysicalMemory = [Math]::Round((gwmi -Class Win32_ComputerSystem -ComputerName $ComputerName).TotalPhysicalMemory/1GB) 

$ips = (Test-Connection $ComputerName -Count 1).IPV4Address 
$ips.IPAddressToString

$windowsVersions =(gwmi -class Win32_OperatingSystem -ComputerName $ComputerName).Caption

$virtualorPhysical = gwmi -Class Win32_ComputerSystem -ComputerName $ComputerName -AsJob
Wait-Job $virtualorPhysical.Id   -Timeout 5 # times out after 5 seconds
$virtualorPhysical= Receive-Job $virtualorPhysical.Id | Select-Object Manufacturer | ForEach-Object {$_.Manufacturer} 
$virtual ="VMware, Inc."
 
  if (Compare-Object "$virtualorPhysical" "$virtual" )
  {
   
   "$virtualorPhysical"

  }
 
  else{
    
   "$virtualorPhysical"
  }
 

 #get-services to verify server is up and running
  $clustered = Get-Service -name clussvc -ComputerName $ComputerName 
  $clustered.Status 
  $netlogonservice = Get-Service  'Netlogon' -ComputerName  $ComputerName 
 $netlogonservice.Status
  $netbackupservice1 = get-service 'NetBackup Client Service' -ComputerName $ComputerName 
  $netbackupservice1.status
  $netbackupservice2 = get-service 'NetBackup Legacy Client Service' -ComputerName $ComputerName 
  $netbackupservice2.status           
  $netbackupservice3 = get-service 'NetBackup Legacy Network Service' -ComputerName $ComputerName       
  $netbackupservice3.status
  $winrmservice =  Get-Service -name WinRM -ComputerName $ComputerName 
  $winrmservice.Status


  $RDP =  Get-Service  TermService -ComputerName $ComputerName  
  $RDP.Status

  $mcafee =  Get-Service  masvc -ComputerName $ComputerName   
  $mcafee.Status

  $IBMTIVOLI =  Get-Service  KNTCMA_Primary -ComputerName $ComputerName  
  $IBMTIVOLI.Status
  
  $WinFirewall =  Get-Service 'Windows Firewall' -ComputerName $ComputerName  
  $WinFirewall.Status
  
   $LocaluserWPS = Get-WmiObject  -Class Win32_UserAccount -ComputerName $ComputerName -Filter "LocalAccount='True'" | Where {$_.name -eq "WPS"}  | ForEach-Object {$_.name   }
  $LocaluserWPS

  $Localuseracct = Get-WmiObject  -Class Win32_UserAccount -ComputerName $ComputerName -Filter "LocalAccount='True'" | Where {$_.name -eq "Trueagent"}  | ForEach-Object {$_.name   }
  $Localuseracct 

  $WinCollect =  Get-Service -name WinCollect -ComputerName $ComputerName  
  $WinCollect.Status
 
 
  $BLADESvc =  Get-Service -Name RSCDsvc -ComputerName $ComputerName  
  $BLADESvc.status



#################################################################################
# building new object classes for HTML 
#
################################################################################

 
write-host ""

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

        ipv4Address = $ips.IPAddressToString 
        
        Cluster = $clustered.Status

  
  netlogonservice = $netlogonservice.Status
 
  netbackupservice1 = $netbackupservice1.status
  
  netbackupservice2 = $netbackupservice2.status           
       
  netbackupservice3 = $netbackupservice3.status
  
  winrmservice = $winrmservice.Status
  RDP = $RDP.Status
  mcafee = $mcafee.Status
  IBMTIVOLI = $IBMTIVOLI.Status
  WinFirewall = $WinFirewall.Status
  BLADELOGICIC = $BLADESvc.Status
  Localuseracct = $Localuseracct
  WinCollect = $WinCollect.Status
  LocaluserWPS = $LocaluserWPS

    }

 
#################################################################################
# building HTML file with the Columns &  loading the data into HTML file
#
################################################################################
    $OutputReport = "<HTML><TITLE>$whatdomain Server Health Report </TITLE>
                     <body style=""background-color:powderblue"">
                     
                     <font color =""#99000"">
                     <H2><B>Current Domain: $whatdomain & Total Server Count: $ServerCount</B></H2></font>
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
                        <TD><B>Cluster Service</B></TD>  

                        <TD><B>Netlogon Service</B></TD>  
                        <TD><B>NetBackup Client Service </B></TD>  
                        <TD><B>NetBackup Legacy Client Service</B></TD>  
                        <TD><B>NetBackup Legacy Network service</B></TD>  
                        <TD><B>WIMRM Service</B></TD> 


                        <TD><B>RDP Services</B></TD> 
                        <TD><B>McAfee Service</B></TD>  
                        <TD><B>IBMTIVOLI Service</B></TD>  
                        <TD><B>BLADE Service</B></TD>  
                        <TD><B>Trueagent Acct</B></TD> 
                        <TD><B>WinCollect Service</B></TD>
                        <TD><B>Windows Firewall Service</B></TD>
                       
                        <TD><B>Local WPS user</B></TD>
                         <TD><B>ipv4 Address</B></TD>
                        
                                                 
                       </TR>"

                       

    Foreach($Entry in $Result)

    {

         # change the raw-data to %s

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

          $ip4s = "$($Entry.ipv4Address)"

          $LastKB ="$($Entry.LatestPatchInformation)"
          $cluster = "$($Entry.Cluster)"
          $netlogonservice = "$($Entry.netlogonservice)"
          $netbackupservice1 = "$($Entry.netbackupservice1)"
          $netbackupservice2 = "$($Entry.netbackupservice2)"
          $netbackupservice3 = "$($Entry.netbackupservice3)"
          $winrmservice = "$($Entry.winrmservice)"
          $RDP= "$($Entry.RDP)"
          $mcafee= "$($Entry.mcafee)"
          $IBMTIVOLI= "$($Entry.IBMTIVOLI)"
          $WinFirewall= "$($Entry.WinFirewall)"
          $BLADESvc= "$($Entry.BLADELOGICIC)"
          $Localuseracct = "$($Entry.Localuseracct)"
          $WinCollect = "$($Entry.wincollect)"
          $LocaluserWPS = "$($Entry.LocaluserWPS)"


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
              

            if(($Entry.OSVersion) -eq  "Microsoft Windows Server 2008 Standard")
          

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
# Cluster

          if(($Entry.cluster) -ge 3)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($cluster)</TD>"

          }

          elseif((($Entry.cluster) -ge 3) -and (($Entry.cluster) -lt 3))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($cluster)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($cluster)</TD>"

          }

#################################################################################

#################################################################################
# netlogon 

          if(($Entry.netlogonservice) -eq "Running")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center> $($netlogonservice)</TD>"

          }

          elseif((($Entry.netlogonservice) -ne "Running") -and (($Entry.netlogonservice) -ne "starting" ))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($netlogonservice)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($netlogonservice)</TD>"

          }

#################################################################################

#################################################################################
# netbackupservice1

          if(($Entry.netbackupservice1) -eq "Running")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($netbackupservice1)</TD>"

          }

          elseif((($Entry.netbackupservice1) -ne "Stopp") -and (($Entry.netbackupservice1) -ne "starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($netbackupservice1)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($netbackupservice1)</TD>"

          }

#################################################################################

#################################################################################
# netbackupservice2

          if(($Entry.netbackupservice2) -eq "Running")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($netbackupservice2)</TD>"

          }

          elseif((($Entry.netbackupservice2)-ne "Stopp") -and (($Entry.netbackupservice2)-ne "starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($netbackupservice2)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($netbackupservice2)</TD>"

          }

#################################################################################

#################################################################################
# netbackupservice3

          if(($Entry.netbackupservice3) -eq "Running")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($netbackupservice3)</TD>"

          }

          elseif((($Entry.netbackupservice3) -ne " ") -and (($Entry.netbackupservice3) -ne "starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($netbackupservice3)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($netbackupservice3)</TD>"

          }

#################################################################################
#################################################################################
# winrmservice 

          if(($Entry.winrmservice ) -eq "Running")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($winrmservice )</TD>"

          }

          elseif((($Entry.winrmservice ) -ne "Stopp") -and (($Entry.winrmservice )-ne "starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($winrmservice )</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($winrmservice )</TD>"

          }

#################################################################################

#################################################################################
# RDP 

          if(($Entry.RDP ) -eq "Running")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($RDP )</TD>"

          }

          elseif((($Entry.RDP ) -ne "Stopp") -and (($Entry.RDP ) -ne "starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($RDP )</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($RDP )</TD>"

          }

#################################################################################

#################################################################################
# mcafee 

          if(($Entry.mcafee ) -eq "Running")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($mcafee )</TD>"

          }

          elseif((($Entry.mcafee )  -ne "Stopp") -and (($Entry.mcafee ) -ne "starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($mcafee )</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($winrmservice )</TD>"

          }

#################################################################################


#################################################################################
# IBMTIVOLI 

          if(($Entry.IBMTIVOLI ) -eq "Running")

          {

              $OutputReport += "<TD bgcolor=lightgreen  align=center>$($IBMTIVOLI )</TD>"

          }

          elseif((($Entry.IBMTIVOLI )  -ne "Stoppd")-and (($Entry.IBMTIVOLI ) -ne "starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($IBMTIVOLI )</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($IBMTIVOLI )</TD>"

          }

#################################################################################
# BLADELOGICIC 

          if(($Entry.BLADELOGICIC ) -eq "Running")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($BLADESvc )</TD>"

          }

          elseif((($Entry.BLADELOGICIC ) -ne "Running") -and (($Entry.BLADELOGICIC ) -ne "Running"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($BLADESvc )</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($BLADESvc )</TD>"

          }



#################################################################################
# Localuseracct 

          if(($Entry.Localuseracct ) -eq "trueagent ")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($Localuseracct )</TD>"

          }

          elseif((($Entry.Localuseracct )  -ne " ") -and (($Entry.Localuseracct )-ne "- "))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($Localuseracct )</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($Localuseracct )</TD>"

          }




#################################################################################
# Wincollect 

          if(($Entry.Wincollect ) -eq "Running ")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($WinCollect )</TD>"

          }

          elseif((($Entry.Wincollect )  -ne "Stopped") -and (($Entry.Wincollect )-ne "Starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($WinCollect )</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($WinCollect )</TD>"

          }

#################################################################################
# WinFirewall 

          if(($Entry.WinFirewall ) -eq "Running ")

          {

              $OutputReport += "<TD bgcolor=lightgreen  align=center>$($WinFirewall )</TD>"

          }

          elseif((($Entry.WinFirewall )  -ne "Stopped") -and (($Entry.WinFirewall )-ne "Starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($WinFirewall )</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($WinFirewall )</TD>"

          }

#################################################################################
# LocaluserWPS

          if(($Entry.LocaluserWPS) -eq "WPS")

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($LocaluserWPS)</TD>"

          }

          elseif((($Entry.LocaluserWPS) -ne " ") -and (($Entry.LocaluserWPS) -ne "starting"))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($LocaluserWPS)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($LocaluserWPS)</TD>"

          }

#################################################################################



















#################################################################################
# IP address 

          if(($Entry.ipv4Address) -ge 3)

          {

              $OutputReport += "<TD bgcolor=E41B17 align=center>$($ip4s)</TD>"

          }

          elseif((($Entry.ipv4Address) -ge 3) -and (($Entry.ipv4Address) -lt 3))

          {

              $OutputReport += "<TD bgcolor=yellow align=center>$($ip4s)</TD>"

          }

          else

          {

              $OutputReport += "<TD bgcolor=lightgreen align=center>$($ip4s)</TD>"

          }



$endtime =Get-Date
$total= $endtime -$starttime



#################################################################################
#  






          $OutputReport += "</TR>"

    }

 sleep 2

    $OutputReport += "</Table></BODY>
    <p>Script started at: $starttime </p>
    <p>Script total time: $total</p></font>
   </HTML>"


}

 

$OutputReport | out-file $ReportFilePath


Write-host "Total Script time to run $total" -ForegroundColor Yellow | ft -AutoSize 

Invoke-Expression $ReportFilePath

