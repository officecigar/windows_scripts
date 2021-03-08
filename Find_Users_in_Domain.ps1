$host.UI.RawUI.WindowTitle = "Search users in your Domain "
import-Module ActiveDirectory   

$aduser = Read-Host "enter user you are searching for"
Get-ADUser -filter "name -like '$aduser*'" -Properties SamAccountName , Department, DistinguishedName
