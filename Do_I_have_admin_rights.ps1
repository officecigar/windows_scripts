 $user=whoami
 
 If ( ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{"$user ...you have admin rights "
#maybe put admin stuf here for team

}
ELSE{"Not an Admin!"}

