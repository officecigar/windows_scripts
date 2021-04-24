


#Write-Host "  "
#Write-Host "###########################################################" 
#Write-Host "  "

$locations = set-Location   'C:\Scripts\Tonyb\Toolsbox' 
$GetFilesToDelete = (Get-Date).AddDays(-15)
$FilesToDelete = Get-ChildItem -Path $locations  -Recurse  -file  | Where-Object {$_.LastWriteTime -ge $GetFilesToDelete  } | select -Property FullName,LastWriteTime




Write-Host "##################################################################" -ForegroundColor yellow 
Write-Host "#            What's changed in my ToolBox?                       #"
Write-Host "# Files that has been written/changed since" $GetFilesToDelete". #" -ForegroundColor yellow 
Write-Host "# "$FilesToDelete.count" "total files has been changed."                            #"  -ForegroundColor yellow 
Write-Host "##################################################################" -ForegroundColor yellow 
$FilesToDelete