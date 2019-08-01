#Display port information

Get-NetTCPConnection | ft state,l*port, l*address, r*port, r*address, OwningProcess –Auto
