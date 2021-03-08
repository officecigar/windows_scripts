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
                [Parameter(Mandatory=$true,ValuefromPipeline=$true, HelpMessage="Please enter the Server name or IP address you want to view info about")]
                [string []]$adusers,
                [string]$errorlogpath ='c:\temp\ManyUsersToFind_error_.log'
 
 
)


begin{
$host.UI.RawUI.WindowTitle = "Search users in your Domain "
Write-Host ""
import-Module ActiveDirectory  
$starttime =Get-Date


}


process{
    foreach ($aduser in $adusers) {
               #Get-ADUser -filter "name -like '$aduser'" -Properties SamAccountName , givenname, surname, Department, title, department } 
                
                
                #Get-ADUser -filter "name -like '$aduser'" | select SamAccountName , givenname, surname, Department, title, department
               
                Get-ADUser -filter "name -like '$aduser*'" -Properties SamAccountName , Department, DistinguishedName 
         
              
                }

                                    }
        


End{

                    $endtime =Get-Date
                    $total= $endtime -$starttime
                    Write-host "Total Script time to run $total" -ForegroundColor Yellow |ft -AutoSize 

}