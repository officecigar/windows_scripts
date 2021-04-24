

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
[string []]$servers

 
 
)
 begin{$host.UI.RawUI.WindowTitle = "Cleaning C drive "

      }

process{

 Start-Transcript -Path c:\temp\DiskSpaceLog.txt 
 # please add your text file to the line Below. 
 #$servers =  #Get-Content -Path C:\Temp\clean_disk_list.txt
 foreach($server in $servers){

 write-host  "Checking -computername  $server for you now." -ForegroundColor Cyan


 Invoke-Command -ComputerName $Server -ScriptBlock {
 $localCDrive  = Get-WMIObject Win32_Logicaldisk -ComputerName $Server -filter "deviceid='C:'"  | Select PSComputername,DeviceID, @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}}, @{Name="FreeGB";Expression={[math]::Round($_.Freespace/1GB,2)}}
 $localCDrive 
######################################################## delete files in dir C:\Windows\SoftwareDistribution\Download
$foldersToCheck = dir C:\Windows\SoftwareDistribution\ | where {$_.PSiscontainer} | sort -Descending | where{$_.Name -eq "Download"}

$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum
    switch ($bytecount)
    {

        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
     }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}
$results

Get-ChildItem -Path C:\Windows\SoftwareDistribution\Download\ -File | Remove-Item -Verbose



######################################################## delete files in dir C:\Windows\PCHealth\ErrorRep\UserDumps 
$foldersToCheck = dir C:\Windows\PCHealth\ErrorRep\ | where {$_.PSiscontainer}  | sort -Descending | where{$_.Name -eq "UserDumps"}



$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    {
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}

$results 
Get-ChildItem -Path C:\Windows\PCHealth\ErrorRep\UserDumps\ -File | Remove-Item -Verbose





######################################################## delete files in dir C:\Windows\PCHealth\ErrorRep\QSIGNOFF
$foldersToCheck = dir C:\Windows\PCHealth\ErrorRep\ | where {$_.PSiscontainer}  | sort -Descending | where{$_.Name -eq "QSIGNOFF"}



$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    {
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}

$results 
Get-ChildItem -Path C:\Windows\PCHealth\ErrorRep\QSIGNOFF\ -File | Remove-Item -Verbose


######################################################## delete files in dir C:\Windows\system32\CCM\Cache
$foldersToCheck = dir C:\Windows\system32\CCM\ | where {$_.PSiscontainer}  | sort -Descending | where{$_.Name -eq "Cache"}



$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    {
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}

$results
Get-ChildItem -Path C:\Windows\system32\CCM\Cache\ -File | Remove-Item -Verbose




######################################################## delete files in dir C:\Windows\SysWOW64\CCM\Cache
$foldersToCheck = dir C:\Windows\SysWOW64\CCM\ | where {$_.PSiscontainer}  | sort -Descending | where{$_.Name -eq "Cache"}



$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    {
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}

$results 
Get-ChildItem -Path C:\Windows\SysWOW64\CCM\Cache -File | Remove-Item -Verbose


######################################################## delete files in dir C:\Windows\Propatches\Patches
$foldersToCheck = dir C:\Windows\Propatches\ | where {$_.PSiscontainer} | where{$_.Name -eq "Patches"}



$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    {
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}

$results 
Get-ChildItem -Path C:\Windows\Propatches\Patches -File | Remove-Item -Verbose


######################################################## delete files in dir C:\inetpub\logs\LogFiles
$foldersToCheck = dir C:\inetpub\logs\ | where {$_.PSiscontainer} | where{$_.Name -eq "LogFiles"}

$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    {
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}

$results 


#Get-ChildItem -Path C:\inetpub\logs\LogFiles -File | Remove-Item -Verbose
$locations = set-Location   'C:\inetpub\logs\LogFiles'
$GetFilesToDelete = (Get-Date).AddDays(-30)
$FilesToDelete = Get-ChildItem -Path $locations -file | Where-Object { $_.Name -like '*.log' } | Where-Object {$_.CreationTime -le $GetFilesToDelete  } | select -Property FullName,LastWriteTime
$FilesToDelete.count
$FilesToDelete
Get-ChildItem -Path $locations -file | Where-Object { $_.Name -like '*.log' } | Where-Object {$_.CreationTime -le $GetFilesToDelete  } | Remove-Item



######################################################## delete files in dir C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp
$foldersToCheck = dir C:\Windows\ServiceProfiles\NetworkService\AppData\Local | where {$_.PSiscontainer}  | where{$_.Name -eq "Temp"}




$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    {
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}

$results 
Get-ChildItem -Path C:\Windows\ServiceProfiles\NetworkService\AppData\Local\Temp -File | Remove-Item -Verbose

######################################################## delete files in dir C:\ProgramData\Microsoft\Windows\WER\ReportArchive
$foldersToCheck = dir C:\ProgramData\Microsoft\Windows\WER\ | where {$_.PSiscontainer}  | where{$_.Name -eq "ReportArchive"}



$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    {
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}

$results 
Get-ChildItem -Path C:\ProgramData\Microsoft\Windows\WER\ReportArchive -File | Remove-Item -Verbose


######################################################## delete files in dir C:\ProgramData\Microsoft\Windows\WER\ReportQueue
$foldersToCheck = dir C:\ProgramData\Microsoft\Windows\WER\ | where {$_.PSiscontainer}  | where{$_.Name -eq "ReportQueue"}



$results = foreach ($folder in $foldersToCheck) {
    $bytecount = (dir $folder.fullname -recurse  | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    {
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        Name = $folder
        Size = $size
    }
}

$results 
Get-ChildItem -Path C:\ProgramData\Microsoft\Windows\WER\ReportQueue -File | Remove-Item -Verbose



 
######################################################## List Top Users with the most disk usage

 write-host  "Top disks space users from profiles." -ForegroundColor yellow

$foldersToCheck = dir C:\Users | where {$_.PSiscontainer} 
$results = foreach ($folder in $foldersToCheck) {

    $bytecount = (dir $folder.fullname -recurse | Where-Object { -not $_.PSIsContainer } | Measure-Object -property length -sum).sum 
    switch ($bytecount)
    { 
         {$_ -lt 1MB} { $size = "{0:N2} MB" -f ($_ / 1MB); break } 
        {$_ -lt 1TB} { $size = "{0:N2} GB" -f ($_ / 1GB); break } 
        #{$_ -lt 1PB} { $size = "{0:N2} TB" -f ($_ / 1TB); break } 
        #default { $size = "{0:N2} PB" -f ($_ / 1PB) }
 
    }
    [PSCustomObject]@{
        
        Name = $folder
        Size = $size
    }
}

$results | sort size  -Descending |  select -first 15 |ft -AutoSize

######################################################## #Empty recycle bin 

Clear-RecycleBin -DriveLetter C -Force

}
$mydriveTemp =Set-Location c:\temp
$cdrivesize =Get-Location


}


}


End {

$localCDrive  = Get-WMIObject Win32_Logicaldisk -ComputerName $Server -filter "deviceid='C:'"  | Select PSComputername,DeviceID, @{Name="SizeGB";Expression={$_.Size/1GB -as [int]}}, @{Name="FreeGB";Expression={[math]::Round($_.Freespace/1GB,2)}}
$localCDrive 
$cdrivesize.Drive |ft -AutoSize
Stop-Transcript 

}