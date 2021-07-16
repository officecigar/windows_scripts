[int]$movefile = Read-Host "How many time to move files?"
[int]$time = Read-Host "How many  minutes do you want to run this program?"

                $d = gci -directory "D:\rand0"  | resolve-path  |  get-random -count 1
                $d
                  Move-Item  C:\temp\yoursecretfile.txt $d -ErrorAction SilentlyContinue
                  $A = $d 

For($i=1; $i -le $movefile; $i++) {  

              Write-Host $i   
                $d = gci -directory "D:\rand0"  | resolve-path  |  get-random -count 1
                $d
                  Move-Item  -Path $a"\yoursecretfile.txt" -Destination $d -ErrorAction SilentlyContinue
                  $A = $d 
                   
              write-host "Should have moved " -ForegroundColor Cyan
 
#get-childitem $a | select name

              write-host $a.ProviderPath  "is here" -ForegroundColor Yellow
              Write-Host "It has been done $I times so far." -ForegroundColor Green
              [int]$seconds = "60"
              $times =   $seconds * $time
              sleep  $times
}

