#     ***Creates some security issues, run Nessus Postscan.ps1 to harden the system once scanning is complete***
#Execute this script on the target standalone host to set the conditions for a Windows 10 Machine to get properly scanned
#Sets conditions for remediation such as allowing .NET updates to install


#Set variable values
$ScannerIP = 0.0.0.0
$TargetIP = 0.0.0.0

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

#Allow traffic from Nessus scanner
New-NetFirewallRule -DisplayName "Nessus" -Direction Inbound -Profile Any -LocalAddress $TargetIP -RemoteAddress $ScannerIP
New-NetFirewallRule -DisplayName "Nessus" -Direction Outbound -Profile Any -LocalAddress $TargetIP -RemoteAddress $ScannerIP

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

#Set the Local Account Token Filter Policy
Set-ItemProperty -Path Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\ -Name "LocalAccountTokenFilterPolicy" -Value 1

#Set the Filter Administrator Token Policy
Set-ItemProperty -Path Registry::HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\ -Name "FilterAdministratorToken" -Value 1

#Fix the issue with .NET installers not being trusted by Windows
$Path = "Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing"
$PathExists = (Test-Path $Path)
If ($PathExists) {
  Set-ItemProperty -Path $Path -Name "State" -Type Dword -Value "146432"
}
Else {
  New-Item 'Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing" -Force
  Set-ItemProperty -Path $Path -Name "State" -Type Dword -Value "146432"
}

#Remediate the SSL 3.0 "Poodle" Vulnerability
$Path = "Registry::HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client"
$PathExists = (Test-Path $Path)
If ($PathExists) {
  Set-ItemProperty -Path $Path -Name "Enabled" -Value "0"
  Set-ItemProperty -Path $Path -Name "DisabledByDefault" -Value "1"
}
Else {
  New-Item $Path -Force
  Set-ItemProperty -Path $Path -Name "Enabled" -Value "0"
  Set-ItemProperty -Path $Path -Name "DisabledByDefault" -Value "1"
}
$Path = "Registry::HKLM\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server"
$PathExists = (Test-Path $Path)
If ($PathExists) {
  Set-ItemProperty -Path $Path -Name "Enabled" -Value "0"
  Set-ItemProperty -Path $Path -Name "DisabledByDefault" -Value "1"
}
Else {
  New-Item $Path -Force
  Set-ItemProperty -Path $Path -Name "Enabled" -Value "0"
  Set-ItemProperty -Path $Path -Name "DisabledByDefault" -Value "1"
}
