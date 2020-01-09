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

#$DIVCODE = read-host "enter code" 

$vcorepassword = Get-Credential -message "Please enter vCORE-team root password." # password USFOOD gave to vCORE team

$USFPassword = Get-Credential -message "Please enter USFOODs root password."  # USF password that is in keypass

}




process {
$host.UI.RawUI.WindowTitle = "ESXI HOST PASSWORD CHANGE"

Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black 
Write-Host "  UUUUUUUU     UUUUUUUU   SSSSSSSSSSSSSSS      FFFFFFFFFFFFFFFFFFFFFF     OOOOOOOOO          OOOOOOOOO     DDDDDDDDDDDDD           SSSSSSSSSSSSSSS          " -ForegroundColor Green -BackgroundColor black 
Write-Host "  U::::::U     U::::::U SS:::::::::::::::S     F::::::::::::::::::::F   OO:::::::::OO      OO:::::::::OO   D::::::::::::DDD      SS:::::::::::::::S         " -ForegroundColor Green -BackgroundColor black
Write-Host "  U::::::U     U::::::US:::::SSSSSS::::::S     F::::::::::::::::::::F OO:::::::::::::OO  OO:::::::::::::OO D:::::::::::::::DD   S:::::SSSSSS::::::S         " -ForegroundColor Green -BackgroundColor black
Write-Host "  UU:::::U     U:::::UUS:::::S     SSSSSSS     FF::::::FFFFFFFFF::::FO:::::::OOO:::::::OO:::::::OOO:::::::ODDD:::::DDDDD:::::D  S:::::S     SSSSSSS         " -ForegroundColor Green -BackgroundColor black
Write-Host "   U:::::U     U:::::U S:::::S                   F:::::F       FFFFFFO::::::O   O::::::OO::::::O   O::::::O  D:::::D    D:::::D S:::::S                     " -ForegroundColor Green -BackgroundColor black
Write-Host "   U:::::D     D:::::U S:::::S                   F:::::F             O:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::DS:::::S                     " -ForegroundColor Green -BackgroundColor black
Write-Host "   U:::::D     D:::::U  S::::SSSS                F::::::FFFFFFFFFF   O:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D S::::SSSS                  " -ForegroundColor Green -BackgroundColor black
Write-Host "   U:::::D     D:::::U   SS::::::SSSSS           F:::::::::::::::F   O:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D  SS::::::SSSSS             " -ForegroundColor Green -BackgroundColor black
Write-Host "   U:::::D     D:::::U     SSS::::::::SS         F:::::::::::::::F   O:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D    SSS::::::::SS           " -ForegroundColor Green -BackgroundColor black
Write-Host "   U:::::D     D:::::U        SSSSSS::::S        F::::::FFFFFFFFFF   O:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D       SSSSSS::::S          " -ForegroundColor Green -BackgroundColor black
Write-Host "   U:::::D     D:::::U             S:::::S       F:::::F             O:::::O     O:::::OO:::::O     O:::::O  D:::::D     D:::::D            S:::::S         " -ForegroundColor Green -BackgroundColor black 
Write-Host "   U::::::U   U::::::U             S:::::S       F:::::F             O::::::O   O::::::OO::::::O   O::::::O  D:::::D    D:::::D             S:::::S         " -ForegroundColor Green -BackgroundColor black
Write-Host "   U:::::::UUU:::::::U SSSSSSS     S:::::S     FF:::::::FF           O:::::::OOO:::::::OO:::::::OOO:::::::ODDD:::::DDDDD:::::D  SSSSSSS     S:::::S         " -ForegroundColor Green -BackgroundColor black
Write-Host "    UU:::::::::::::UU  S::::::SSSSSS:::::S     F::::::::FF            OO:::::::::::::OO  OO:::::::::::::OO D:::::::::::::::DD   S::::::SSSSSS:::::S         " -ForegroundColor Green -BackgroundColor black
Write-Host "      UU:::::::::UU    S:::::::::::::::SS      F::::::::FF              OO:::::::::OO      OO:::::::::OO   D::::::::::::DDD     S:::::::::::::::SS          " -ForegroundColor Green -BackgroundColor black
Write-Host "        UUUUUUUUU       SSSSSSSSSSSSSSS        FFFFFFFFFFF                OOOOOOOOO          OOOOOOOOO     DDDDDDDDDDDDD         SSSSSSSSSSSSSSS            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black 
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host " 																   by US-FOODs Engineering Team Member: $TeamMemberName" -ForegroundColor Yellow
Write-Host ""
Write-Host ""
Write-Host ""

Write-Host ""


#1. New_vSAN_Deployment_for_New_Division_

#2. Replacement_Deployment_for_Existing_Division_

#Connect-VIServer -server $name 




 #$vmhost1lastname = "xtresxsc01.usfqa.adqa.usfood.local"
 #$vmhost2lastname = "xtresxsc02.usfqa.adqa.usfood.local"
 #$vmhost3lastname = "xtresxsc03.usfqa.adqa.usfood.local"

#$esxihost1Fullname = -join ($DIVCODE, $vmhost1lastname)
#$esxihost2Fullname = -join ($DIVCODE, $vmhost2lastname )
#$esxihost3Fullname = -join ($DIVCODE, $vmhost3lastname )

#$esxihosts = $esxihost1Fullname #, $esxihost2Fullname #, $esxihost3Fullname 


#$name = Read-Host "please enter vCenter servername "

ForEach($esxihost in $esxihosts){ Connect-VIServer -Server $esxihost  -Credential $vcorepassword -NotDefault;

                                    Set-VMHostAccount -Server $esxihost -UserAccount root -Password $USFPassword.GetNetworkCredential().Password

                                 }


}

end {




}