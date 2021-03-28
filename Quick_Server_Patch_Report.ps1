#In the section below, edit these variables with your preferences:
=============================================================================================================================#>
$DateStamp = (Get-Date -Format D)
$DateStampCSV = (Get-Date -Format "MMM-dd-yyyy")
$FileDateStamp = Get-Date -Format yyyyMMdd
$ScriptPaths = set-Location "C:\Temp"
$ScriptPath = get-location 
$ServerList = Get-Content $ScriptPath\testServerList.txt
$ReportFileName = "$ScriptPath\ServerPatchReport-$FileDateStamp.html"
$ReportFileCSV = "$ScriptPath\ServerPatchReport.csv"
$IncludeCSV = "True"
$ReportTitle = "Server Patch Report"

$BGColorGood = "#4CBB17"
$BGColorWarn = "#FFFC33"
$BGColorCrit = "#FF0000"
$Warning = 30
$Critical = 90

<#=============================
Do not edit below this section
==============================#>
Clear


<#============
Begin MAIN
=============#>
# Create output file and nullify display output
New-Item -ItemType file $ReportFileName -Force > $null
New-Item -ItemType file $ReportFileCSV -Force > $null

<#=======================================
Write the HTML Header to the report files
========================================#>
Add-Content $ReportFileName "<html>"
Add-Content $ReportFileName "<head>"
Add-Content $ReportFileName "<meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1'>"
Add-Content $ReportFileName "<title>$ReportTitle</title>"
Add-Content $ReportFileName '<STYLE TYPE="text/css">'
Add-Content $ReportFileName "td {"
Add-Content $ReportFileName "font-family: Cambria;"
Add-Content $ReportFileName "font-size: 11px;"
Add-Content $ReportFileName "border-top: 1px solid #999999;"
Add-Content $ReportFileName "border-right: 1px solid #999999;"
Add-Content $ReportFileName "border-bottom: 1px solid #999999;"
Add-Content $ReportFileName "border-left: 1px solid #999999;"
Add-Content $ReportFileName "padding-top: 0px;"
Add-Content $ReportFileName "padding-right: 0px;"
Add-Content $ReportFileName "padding-bottom: 0px;"
Add-Content $ReportFileName "padding-left: 0px;"
Add-Content $ReportFileName "}"
Add-Content $ReportFileName "body {"
Add-Content $ReportFileName "margin-left: 5px;"
Add-Content $ReportFileName "margin-top: 5px;"
Add-Content $ReportFileName "margin-right: 5px;"
Add-Content $ReportFileName "margin-bottom: 10px;"
Add-Content $ReportFileName "table {"
Add-Content $ReportFileName "border: thin solid #000000;"
Add-Content $ReportFileName "}"
Add-Content $ReportFileName "</style>"
Add-Content $ReportFileName "</head>"
Add-Content $ReportFileName "<body>"
Add-Content $ReportFileName "<table width='75%' align=`"center`">"
Add-Content $ReportFileName "<tr bgcolor=$BGColorTbl>"
Add-Content $ReportFileName "<td colspan='3' height='25' align='center'>"
Add-Content $ReportFileName "<font face='Cambria' color='#003399' size='4'><strong>$ReportTitle<br></strong></font>"
Add-Content $ReportFileName "<font face='Cambria' color='#003399' size='2'>$DateStamp</font><br><br>"

#Add to CSV file
Add-Content $ReportFileCSV "$ReportTitle"
Add-Content $ReportFileCSV "$DateStampCSV`n"


# Add color descriptions
$Warn=$Warning+1
Add-content $ReportFileName "<table width='75%' align=`"center`">"  
Add-Content $ReportFileName "<tr>"  
Add-Content $ReportFileName "<td width='30%' bgcolor=$BGColorGood align='center'><strong>Patched <= $Warning Days</strong></td>"  
Add-Content $ReportFileName "<td width='30%' bgcolor=$BGColorWarn align='center'><strong>Patched $Warn - $Critical Days</strong></td>"  
Add-Content $ReportFileName "<td width='30%' bgcolor=$BGColorCrit align='center'><strong>Patched > $Critical Days</strong></td>"
Add-Content $ReportFileName "</tr>"
Add-Content $ReportFileName "</table>"

# Add Column Headers
Add-Content $ReportFileName "</td>"
Add-Content $ReportFileName "</tr>"
Add-Content $ReportFileName "<tr bgcolor=$BGColorTbl>"
Add-Content $ReportFileName "<td width='20%' align='center'><strong>Server Name</strong></td>"
Add-Content $ReportFileName "<td width='20%' align='center'><strong>Last Patch Date & Time</strong></td>"
Add-Content $ReportFileName "<td width='20%' align='center'><strong>Days Since Last Patch</strong></td>"
Add-Content $ReportFileName "</tr>"

#Add column headers to CSV file
Add-Content $ReportFileCSV "Server Name, Last Patch Date & Time, Days Since Last Patch"

<#===============================
Function to write the HTML footer
================================#>
Function writeHtmlFooter
{
	param($FileName)
	Add-Content $FileName "</table>"
	Add-content $FileName "<table width='75%' align=`"center`">"  
	Add-Content $FileName "<tr bgcolor=$BGColorTbl>"  
	Add-Content $FileName "<td width='75%' align='center'><strong>Total Servers: $ServerCount</strong></td>"
	Add-Content $FileName "</tr>"
	Add-Content $FileName "</table>"
	Add-Content $FileName "</body>"
	Add-Content $FileName "</html>"
	Add-Content $ReportFileCSV "`nEnd of Report"
}

<#==================================================
Function to write server update information to the
HTML report file
==================================================#>
Function writeUpdateData 
{
	param($FileName,$Server,$InstalledOn)
	Add-Content $FileName "<tr>"
	Add-Content $FileName "<td align='center'>$Server</td>"
	Add-Content $FileName "<td align='center'>$InstalledOn</td>"


# Color BG depending on $Warning and $Critical days set in script
    If ($InstalledOn -eq "Error collecting data") 
    { 
        $DaySpanDays = "Error"
    }
    Else
    {
        $System = (Get-Date -Format "MM/dd/yyyy hh:mm:ss")
        $DaySpan = New-TimeSpan -Start $InstalledOn -End $System
        $DaySpanDays = $DaySpan.Days
    }
	If ($InstalledOn -eq "Error collecting data" -or $DaySpan.Days -gt $Critical)
	{
    	# Red for Critical or Error retrieving data
		Add-Content $FileName "<td bgcolor=$BGColorCrit align='center'>$DaySpanDays</td>"
		Add-Content $FileName "</tr>"
		Add-Content $ReportFileCSV "$Server,$InstalledOn,$DaySpanDays"
	}
	ElseIf ($DaySpan.Days -le $Warning)
	{
	    # Green for Good
		Add-Content $FileName "<td bgcolor=$BGColorGood align=center>$DaySpanDays</td>"
		Add-Content $FileName "</tr>"
		Add-Content $ReportFileCSV "$Server,$InstalledOn,$DaySpanDays"
	}
	Else
	{
	    # Yellow for Warning
		Add-Content $FileName "<td bgcolor=$BGColorWarn align=center>$DaySpanDays</td>"
		Add-Content $FileName "</tr>"
		Add-Content $ReportFileCSV "$Server,$InstalledOn,$DaySpanDays"
	}

	 Add-Content $FileName "</tr>"
}


<#=====================================
Query servers for their update history
Try registry first, if error Get-Hotfix
======================================#>
Write-Host "Querying servers for installed updates..." -foreground "Yellow"
$ServerCount = 0
ForEach ($Server in $ServerList)
{
        $InstalledOn = ""
    Try
    {
        Write-host "Checking $Server..."
	$ServerCount++
        $key = "SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\Results\Install"
        $keytype = [Microsoft.Win32.RegistryHive]::LocalMachine 
        $RemoteBase = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey($keytype,$Server)
        $regKey = $RemoteBase.OpenSubKey($key)
        $KeyValue = ""
        $KeyValue = $regkey.GetValue("LastSuccessTime")
        $InstalledOn = ""
        $InstalledOn = Get-Date $KeyValue -Format 'MM/dd/yyyy hh:mm:ss'
    }

    Catch 
    {
        $ServerLastUpdate = (Get-HotFix -ComputerName $Server | Sort-Object -Descending -Property InstalledOn -ErrorAction SilentlyContinue | Select-Object -First 1)
		$InstalledOn = $ServerLastUpdate.InstalledOn
    }

   If ($InstalledOn -eq "")
   {
	$InstalledOn = "Error collecting data"
   }

    writeUpdateData $ReportFileName $Server $InstalledOn
}

Write-Host "Finishing report..." -ForegroundColor "Yellow"
writeHtmlFooter $ReportFileName

Invoke-Expression  $ReportFileName