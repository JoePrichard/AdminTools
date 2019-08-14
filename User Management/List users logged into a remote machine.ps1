#WMI Method. Dependent services - DCOM Server Process Launcher, RPC, RPC endpoint mapper, Windows Management Instrumentation
Get-WMIObject -ComputerName ExampleHostName -Class Win32_ComputerSystem | Select-Object UserName

$CIM method.
Get-CIMInstance -ComputerName ExampleHostName -Class Win32_ComputerSystem | Select-Object UserName

#The best method
Query user /server:ExampleHostName
