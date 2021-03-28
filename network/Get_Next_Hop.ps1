#comment 1 - Get the next hop for the default route 
Get-NetRoute –DestinationPrefix "0.0.0.0/0" | Select-Object –ExpandProperty "NextHop"
