Import-Module -Name "ActiveDirectory"
New-ADServiceAccount -Name "s_8nxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_8nxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "8nxprsaeDB01" -ServiceAccount "s_8nxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_8nxprsaedb01$"



New-ADServiceAccount -Name "s_4ixprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_4ixprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "4ixprsaedb01" -ServiceAccount "s_4ixprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_4ixprsaedb01$"



New-ADServiceAccount -Name "s_2jxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_2jxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "2jxprsaedb01" -ServiceAccount "s_2jxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_2jxprsaedb01$"



New-ADServiceAccount -Name "s_6hxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_6hxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "6hxprsaedb01" -ServiceAccount "s_6hxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_6hxprsaedb01$"

Import-Module -Name "ActiveDirectory"
New-ADServiceAccount -Name "s_6uxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_6uxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "6uxprsaedb01" -ServiceAccount "s_6uxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_6uxprsaedb01$"

New-ADServiceAccount -Name "s_6bxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_6bxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "6bxprsaedb01" -ServiceAccount "s_6bxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_6bxprsaedb01$"


New-ADServiceAccount -Name "s_6zxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_6zxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "6zxprsaedb01" -ServiceAccount "s_6zxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_6zxprsaedb01$"


New-ADServiceAccount -Name "s_6iaprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_6iaprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "6iaprsaedb01" -ServiceAccount "s_6iaprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_6iaprsaedb01$"


New-ADServiceAccount -Name "s_2zxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_2zxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "2zxprsaedb01" -ServiceAccount "s_2zxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_2zxprsaedb01$"

New-ADServiceAccount -Name "s_3wxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_3wxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "3wxprsaedb01" -ServiceAccount "s_3wxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_3wxprsaedb01$"


New-ADServiceAccount -Name "s_4vxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_4vxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "4vxprsaedb01" -ServiceAccount "s_4vxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_4vxprsaedb01$"




New-ADServiceAccount -Name "s_3vxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_3vxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "3vxprsaedb01" -ServiceAccount "s_3vxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_3vxprsaedb01$"


New-ADServiceAccount -Name "s_8oxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_8oxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "8oxprsaedb01" -ServiceAccount "s_8oxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_8oxprsaedb01$"



New-ADServiceAccount -Name "s_2oxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_2oxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "2oxprsaedb01" -ServiceAccount "s_2oxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_2oxprsaedb01$"



New-ADServiceAccount -Name "s_3kxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_3kxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "3kxprsaedb01" -ServiceAccount "s_3kxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_3kxprsaedb01$"

New-ADServiceAccount -Name "s_4uxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_4uxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "4uxprsaedb01" -ServiceAccount "s_4uxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_4uxprsaedb01$"


New-ADServiceAccount -Name "s_6uxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_6uxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "6uxprsaedb01" -ServiceAccount "s_6uxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_6uxprsaedb01$"


New-ADServiceAccount -Name "s_4oxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_4oxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "4oxprsaedb01" -ServiceAccount "s_4oxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_4oxprsaedb01$"



New-ADServiceAccount -Name "s_4jxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_4jxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "4jxprsaedb01" -ServiceAccount "s_4jxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_4jxprsaedb01$"



New-ADServiceAccount -Name "s_6yxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_6yxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "6yxprsaedb01" -ServiceAccount "s_6yxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_6yxprsaedb01$"


New-ADServiceAccount -Name "s_4qxprsaedb01" -RestrictToSingleComputer -Enabled $true
Set-ADServiceAccount -Identity "s_4qxprsaedb01" -Replace @{employeeType="service managed"}
Add-ADComputerServiceAccount -Identity "4qxprsaedb01" -ServiceAccount "s_4qxprsaedb01"
Add-ADGroupMember  -Identity "USF Service Accounts" -Members "s_4qxprsaedb01$"
