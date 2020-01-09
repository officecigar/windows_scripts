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
        http://www.mr-itpro.com
 #>


[CmdletBinding(HelpURI='http://google.com')]
 Param(
                [Parameter(Mandatory=$true,ValuefromPipeline=$true, HelpMessage="Please enter the server name or IP address you want to view info about")]
                [string []]$esxihosts   #,
               # [string]$errorlogpath ='c:\temp\PWErrors_.log'
      )





begin{

Add-PSSnapin VMWARE* 



$OLDpassword = Get-Credential -message "Please enter OLD root password." # password you gave to someone

$NEWpassword = Get-Credential -message "Please enter NEW root password."  # password that is kept in a vault
}




process {
$host.UI.RawUI.WindowTitle = "ESXI HOST PASSWORD CHANGE"



ForEach($esxihost in $esxihosts){ Connect-VIServer -Server $esxihost  -Credential $OLDpassword -NotDefault;

                                    Set-VMHostAccount -Server $esxihost -UserAccount root -Password $NEWpassword.GetNetworkCredential().Password

                                 }


}

end {




}
