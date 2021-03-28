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


[CmdletBinding(HelpURI='http://google.com')]
 Param(
                [Parameter(Mandatory=$true,ValuefromPipeline=$true)]
                [string []]$servers
                )


Begin {



}




Process{

foreach ($server in $servers) {

#$Localuseracct = Get-WmiObject  -Class Win32_UserAccount -ComputerName $Server -Filter "LocalAccount='True'" | Where {$_.name -eq "Trueagent"} | Select PSComputername, Name, Status

$localBootTime = Get-CimInstance -ClassName win32_operatingsystem -ComputerName $Server | select lastbootuptime

$LocalOS = (Get-WmiObject -class Win32_OperatingSystem -ComputerName $Server).Caption

#$sware =Get-WmiObject win32_product -ComputerName $Server | Where-Object {$_.Name -like "Microsoft Visual C++ 201*"} | select Name | FT -HideTableHeaders

$localCDrive  = Get-WMIObject Win32_Logicaldisk -ComputerName $Server -filter "deviceid='C:'"  | Select PSComputername,DeviceID, @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}}, @{Name="FreeGB";Expression={[math]::Round($_.Freespace/1GB,2)}}

$Server  = "dbnaaemo022.wpd.envoy.net"
$LatestPatchInformation = Get-Hotfix  -ComputerName $Server  | ?{$_.InstalledOn -gt "12/05/2019" }  | Sort-Object -Descending InstalledOn | select -first 03 | select Hotfixid 
$lastpatch =Get-Hotfix  -ComputerName $Server | ?{$_.InstalledOn -gt "12/05/2019" }  | Sort-Object -Descending InstalledOn | select -first 03 | select InstalledOn 



Start-Sleep -Seconds 1
write-host ""
$Comment1 = "FreeSpace : "
$comment2 = "Total disk space : " 
$Comment3 = "Server name : "
$comment4 = "Boot Time : "
$comment5 =  "Last 3 patches : "
$Comment6 = "Window Version : "
$Comment7 = "Required Software : "
$comment8 =  "Last 3 patch dates : "

$commet3 + $Server | ft -AutoSize
$comment5 + `
$LatestPatchInformation.Hotfixid -join ","
$comment8 + `
$lastpatch.InstalledOn
$comment4 + $localBootTime.lastbootuptime  | ft -AutoSize
$comment1 + $localCDrive.FreeGB  | ft -AutoSize
$comment2 + $localCDrive.SizeGB  | ft -AutoSize
$Comment6 + $LocalOS  | ft -AutoSize
#$sware | ft -AutoSize



                                }

                               

    }


End{


}
