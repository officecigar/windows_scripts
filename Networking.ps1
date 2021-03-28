 <#
.SYNOPSIS
Creates a menu for scripts that you already have in a certain location. This will help you to centralize your scripts. You can aslo run your scripts from the menu, which will lauch a new powershell instance. 
.EXAMPLE

navagate to here and run script.
C:\temp\toolsbox\met1.ps1

.EXAMPLE 
Below is a screen example.

1. enableres.ps1
     
2. testgood.ps1

   Enter selection: 2

.EXAMPLE
 met1.ps1
.PARAMETER computername
one or more computername, or IP address... peace to America!
Think powershell think Mr-ITpro.com !!! FUN STUFF
.LINK
        http://www.mr-itpro.com
 #>



 $currentuser = whoami
Write-Host "                                                                                                                             "  
Write-Host "                                                                                                                             "  
Write-Host "                                                                                                                             "  
write-host -nonewline "Current user in ToolBox: " ; write-host -nonewline  -f yellow "$currentuser" 
Write-Host "                                                                                                                             "  
Write-Host "###########################################################"  
Write-Host "                          __________                                                                            " 
Write-Host "                         /  _/_  __/____  _________   "  
Write-Host "                         / /  / /  / __ \/ ___/ __ \  "  
Write-Host "                       _/ /  / /  / /_/ / /  / /_/ /   "  
Write-Host "                      /___/ /_/  / .___/_/   \____/   " 
Write-Host "                                /_/                                                                                          "  
#Write-Host "                                                           " -ForegroundColor Green -BackgroundColor black                                      
Write-Host "###########################################################"  
Write-Host "                                                           " -ForegroundColor white -BackgroundColor Red   
Write-Host "                                                           " -ForegroundColor green -BackgroundColor White   
Write-Host "                                                           " -ForegroundColor White -BackgroundColor Blue   
Write-Host "                                                                                "  

Write-Host "###########################################################"
Write-Host "  Please press Enter with NO selection To exit tool." -ForegroundColor Red
Write-Host "  "
Write-Host "###########################################################" 
Write-Host "  Please Enter a number for the script you want to run." -ForegroundColor green 
Write-Host "  "
Write-Host "###########################################################" 
Write-Host "  "
Write-Host "  "
 $host.UI.RawUI.WindowTitle = "Trouble-shooting Networking - ToolxBox (Netwok Stack)"
 

$processes =  ls -Path C:\scripts\TonyB\toolsbox\Networking
$menu = @{}
for ($i=1;$i -le $processes.count; $i++) {
    Write-Host "$i. $($processes[$i-1].name)"
    Write-Host ""
    $menu.Add($i,($processes[$i-1].name))
    }


[int]$ans = Read-Host 'Enter selection'
$selection = $menu.Item($ans)
Write-Host ""
if ($selection -eq $null){
            exit
                      }

Get-ChildItem -Path C:\scripts\TonyB\toolsbox\Networking  -name $selection | Start-Process PowerShell.exe -argument "-noexit -nologo -noprofile -command C:\scripts\TonyB\toolsbox\Networking\$selection"

powershell.exe C:\scripts\TonyB\toolsbox\networking.ps1 


#start-process powershell.exe -argument "-noexit -nologo -noprofile -command  c:\temp  $selection"