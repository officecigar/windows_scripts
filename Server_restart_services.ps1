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
                [string []]$serviceSrv_restart
                )


Begin {

$host.UI.RawUI.WindowTitle = "Restart Services on servers" 

#$day = Read-Host "how many days do you want to go back for patches"


#Write-Host "Please wait this may take a few Minutes..."


}
Process {

                              #enter your name here    # or un comment the line below 
$services_name = Read-Host " enter your service name " # enter your service name
Foreach ($service_restart in $serviceSrv_restart) {
Get-Service -Name $services_name  -ComputerName $service_restart | Restart-Service


                                                 }

         }

end{




}

