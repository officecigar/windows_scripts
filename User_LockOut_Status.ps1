Get-ADDomain | select PDCEmulator
Get-WinEvent -FilterHashtable @{logname=’security’; id=4740} | fl  | Out-File -FilePath C:\Temp\lockout.txt