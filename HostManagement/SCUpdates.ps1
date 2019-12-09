#Force a host to install available updates from SCCM Software Center
#UpdateName field can specify a single update, many or all of them

function Invoke-UpdateInstall
{
Param (
  [String][Parameter(Mandatory=$True, Position=1)] $ComputerName,
  [String][Parameter(Mandatory=$True, Position=2)] $UpdateName,
  )
Begin
{
  $AppEvalState = "0"
  $AppEvalState = "1"
  $ApplicationClass = [WmiClass]"root\ccm\clientSDK:CCM_SoftwareUpdatesManager"
}

Process
{
If ($UpdateName -like "All" -or $UpdateName -like "all")
{
  Foreach ($computer in $ComputerName)
  {
  $Application = (Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_SoftwareUpdate -ComputerName $Computer |
  Where-Object { $_.EvaluationState -like "*$($AppEvalState1)*"})
  
  Invoke-WmiMethod -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList (,$Application) -Namespace root/ccm/clientsdk -ComputerName $Computer
  }
  }
  Else
  
  {
  Foreach ($Computer in $ComputerName)
  {
  $Application = (Get-WmiObject -Namespace "root\ccm\clientSDK" -Class CCM_SoftwareUpdate -ComputerName $Computer |
  Where-Object { $_.EvaluationState -like "$($AppEvalState)*" -and $_.Name -like "*$($UpdateName)*"})
  
  Invoke-WmiMethod -Class CCM_SoftwareUpdatesManager -Name InstallUpdates -ArgumentList (,$Application) -Namespace root\ccm\clientsdk -ComputerName $Computer
  }
  
  }
  }
  end {}
  }
  
  Invoke-UpdateInstall -ComputerName Examplename -UpdateName All
