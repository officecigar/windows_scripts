#comment 4 - This command gets all IP routes, 
Get-NetRoute | Where-Object –FilterScript { $_.ValidLifetime -Eq ([TimeSpan]::MaxValue) }