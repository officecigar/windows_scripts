
$allhosts = "9zxtresxsc02.usfqa.adqa.usfood.local"


foreach($onehost in $allhosts) { 
$allhostsip = Test-Connection $allhosts -Count 1 | select IPV4Address | ft -HideTableHeaders 
$LastOctet = $allhostsip.
$LastOctet


} 

Get-VsanDisk


foreach($onehost in $onehostss) {
Get-VDSwitch -Name vDS-$2DigCodeName"-sc-DVUplinks" | Add-VDSwitchVMHost -VMHost $onehost
sleep 7

}


foreach($onehost in $allhosts) { 
$IP4Address = Test-Connection -Computer $onehost -Count 1 | Select IPV4Address -ExpandProperty IPV4Address
$test1  = ([ipaddress]$IP4Address).GetAddressBytes()[3]
$static3 ="10.10.10." 

$newvmotion = $static3 + $test1
$newvmotion



New-VMHostNetworkAdapter -VMHost $onehost  -PortGroup pg-$2DigCodeName"-vmotion"  -VirtualSwitch vDS-$2DigCodeName"-sc-DVUplinks" -IP $newvmotion  -SubnetMask 255.255.255.0 -VMotionEnabled:$true

}