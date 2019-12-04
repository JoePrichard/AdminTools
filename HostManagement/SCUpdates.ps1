#Force a host to install available updates from SCCM Software Center

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
