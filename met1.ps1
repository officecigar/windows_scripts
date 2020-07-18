Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black 
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black 
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black 
Write-Host "     __  _______          __________                                                                                                                        "  -ForegroundColor Green -BackgroundColor black
Write-Host "    /  |/  / __ \        /  _/_  __/____  _________    _________  ____ ___                                                                                  "  -ForegroundColor Green -BackgroundColor black
Write-Host "   / /|_/ / /_/ /______  / /  / /  / __ \/ ___/ __ \  / ___/ __ \/ __ `__ \                                                                                 "  -ForegroundColor Green -BackgroundColor black
Write-Host "  / /  / / _, _//_____/_/ /  / /  / /_/ / /  / /_/ /_/ /__/ /_/ / / / / / /                                                                                 "  -ForegroundColor Green -BackgroundColor black
Write-Host " /_/  /_/_/ |_|       /___/ /_/  / .___/_/   \____/(_)___/\____/_/ /_/ /_/                                                                                  "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                /_/                                                                                                                         "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black                                       
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black
Write-Host "                                                                                                                                                            "  -ForegroundColor Green -BackgroundColor black



$processes =  ls -Path C:\Temp\toolsbox\testmenulist
$menu = @{}
for ($i=1;$i -le $processes.count; $i++) {
    Write-Host "$i. $($processes[$i-1].name)"
    Write-Host ""
    $menu.Add($i,($processes[$i-1].name))
    }

[int]$ans = Read-Host 'Enter selection'
$selection = $menu.Item($ans)
Write-Host ""

Get-ChildItem -Path C:\Temp\toolsbox\testmenulist  -name $selection | Start-Process PowerShell.exe -argument "-noexit -nologo -noprofile -command c:\Temp\toolsbox\testmenulist\$selection"

powershell.exe C:\Temp\toolsbox\met1.ps1 
