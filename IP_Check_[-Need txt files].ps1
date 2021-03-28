
Start-Transcript -Path c:\temp\log.txt 
(Get-Content c:\temp\IPAddress.txt) | ForEach {Write-Host $_, "-", ([System.Net.NetworkInformation.Ping]::new().Send($_)).Status}
Stop-Transcript
