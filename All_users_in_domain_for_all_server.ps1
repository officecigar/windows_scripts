#$computers = "server1" , server2" 

$starttime = Get-Date
$host.UI.RawUI.WindowTitle = "List every user on every Server in domain." 

$starttime = Get-Date
$whatdomain = Get-ADDomain | Select-Object dnsroot | ForEach-Object {$_.dnsroot}


$ServerCount=(Get-ADComputer -Filter 'operatingsystem -like "Windows *server*" -and enabled -eq "true"').count
$adserverlist = Get-ADComputer -Filter 'operatingsystem -like "Windows *server*" -and enabled -eq "true"' ` -Properties dnshostname | Sort-Object -Property Operatingsystem |Select-Object -Property dnshostname | ForEach-Object {$_.dnshostname   }
$adserverlist | ft -AutoSize -HideTableHeaders | Out-File "C:\temp\$whatdomain.listeveryone.txt"
$computers =  Get-Content "C:\temp\$whatdomain.listeveryone.txt"


#############################

$computers | foreach {
$computername = $_
[ADSI]$S = "WinNT://$computername"
$S.children.where({$_.class -eq 'group'}) |
Select @{Name="Computername";Expression={$_.Parent.split("/")[-1] }},
@{Name="Name";Expression={$_.name.value}},
@{Name="Members";Expression={
[ADSI]$group = "$($_.Parent)/$($_.Name),group"
$members = $Group.psbase.Invoke("Members")
($members | ForEach-Object {
$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
}) -join ";"
}}
} | Export-CSV -path c:\temp\$whatdomain.localaudit.csv –notypeinformation


$endtime =Get-Date
$total= $endtime -$starttime
