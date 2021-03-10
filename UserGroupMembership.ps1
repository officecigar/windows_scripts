$host.UI.RawUI.WindowTitle = "Group Membership in your Domain "
import-Module ActiveDirectory   

$usermembership = Read-Host "Enter user's ID to find it's Group membership."
Get-ADPrincipalGroupMembership $usermembership | select name