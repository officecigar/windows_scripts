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
                [string []]$DnsServers2ToFlush
                )


#$DNSSrvToFlush= Get-Content c:\temp\DNSservertoflush.txt

Begin {



}

Process{
foreach ($servers in $DnsServers2ToFlush) {

Invoke-WmiMethod -class Win32_process -name Create -ArgumentList ("cmd.exe /c ipconfig /flushdns") -ComputerName $servers


}
}


End{


}
