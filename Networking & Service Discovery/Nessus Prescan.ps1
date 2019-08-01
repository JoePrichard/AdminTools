#Execute this script on the target standalone host to set the conditions for a Windows 10 Machine to get properly scanned

#Set variable values

#IP address of connected Nessus scanner
$ScannerIP = 0.0.0.0

#Start Windows services
Start-Service RasAuto
Start-Service RasMan
Start-Service SessionEnv
Start-Service TermService
Start-Service UmRdpService
Start-Service RpcSs
Start-Service RpcLocator
Start-Service RemoteRegistry

#Routing and Remote Access service needs to be disabled to prevent a Nessus finding
Stop-Service RemoteAccess
Set-Service RemoteAccess -StartupType Disabled

#Windows Firewall Settings

#Allow inbound file and printer sharing. Check for key existence and create new if absent, this is necessary to avoid errors
$Path = "Registry::HKLM\Software\Poicies\Microsoft\WindowsFirewall\StandardProfile\Services\FileAndPrint"
$PathExists = (Test-Path $Path)
If (PathExists) {
  Set-ItemProperty -Path $Path -Name "Enabled" -Value "1"
  Set-ItemProperty -Path $Path -Name "RemoteAddresses" -Value $ScannerIP
}
Else {
  New-Item -Path "Registry::HKLM\Software\Policies\Microsoft\WindowsFirewall\StandardProfile\Services\" -Name "FileAndPrint" -Force
  Set-ItemProperty -Path $Path -Name "Enabled" -Value "1"
  Set-ItemProperty -Path $Path -Name "RemoteAddresses" -Value $ScannerIP
}
