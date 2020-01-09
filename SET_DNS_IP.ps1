 <#
.SYNOPSIS
Think powershell think like Mr-ITpro.com !!! FUN STUFF
.EXAMPLE
'one', 'two', 'three' TonyB_default.ps1
.EXAMPLE
TonyB_default.ps1  $Divcodes
.EXAMPLE
TonyB_default.ps1  one, two, three
.EXAMPLE
get-content <Somelist.txt> or <anylist.csv> | SET_DNS_IPs.ps1
.PARAMETER computername
one or more computername, or IP address... peace to America!
.LINK
        http://www.mr-itpro.com
 #>





[CmdletBinding(HelpURI='http://google.com')]
 Param(
                [Parameter(Mandatory=$true,ValuefromPipeline=$true)]
                [string []]$Servers,
                [string]$errorlogpath ='c:\temp\DNS_IP_error_.log'
 
 
)


begin{
        $host.UI.RawUI.WindowTitle = "Change DNS IP address."
        Write-Host " "
        import-Module ActiveDirectory  
        $starttime =Get-Date
       
    }


  process{
  foreach($Server in $Servers) {
     Write-Verbose "about to query $Servers"
         try    {
                    $serverislive =$true
                        
                    $who = Get-WMIObject Win32_ComputerSystem -computername $Server | Select-Object -ExpandProperty name ​
                      
                  }    catch      {
                                    $serverislive = $false
                                    Write-Verbose "$Server can not be reached.Please check firewall, network , or related issues. "
                                    Write-Verbose " Error was $MyErr"
                                    $Server | Out-File $errorlogpath -append         

                                 }
                              }       
  
            SearchOrderLocation = '10.1.1.1', '10.0.0.1'
            $Server
          
            #$Server = get-adcomputer -filter {name -like "*"} -searchbase "ou=servers,ou=location,dc=company,dc=com"

            foreach ($Server in $Servers){

                                            $config = Get-WmiObject -ComputerName $Server.name -class win32_networkadapterconfiguration | Where-Object { ($_.IPAddress -ne $null) }
                                            $config.SetDNSServerSearchOrder($strSearchOrderLocation)
                                            Write-Host $Server.name
                                            resolve-dnsname $Server.Name

  
                                        }
  
     
  }

  
      
End{

     $endtime =Get-Date
     $total= $endtime -$starttime
     Write-host "Total Script time to run $total" -ForegroundColor Yellow | ft -AutoSize 

  }