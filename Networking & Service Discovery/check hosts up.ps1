#Read hosts from a host file list named hosts.txt, determine if each is Online 
#output the results inlcuding the number online to hostdata.txt with timestamp

$hosts = Get-content "C:\ModernScripting\hosts.txt"
$hostdata = "C:\ModernScripting\hostdata $(get-date -Format yyy-MM-dd).txt"
$totalhostsup = 0
foreach ($x in $hosts) {
  if (Test-Connection -ComputerName $x -Count 1 -ErrorAction SilentlyContinue) {
    Write-Host "$x, Online"
    $totalhostsup++
    Add-Content -Path $hostdata -Value "$x, Online"
}
  else {
    Write-Host "$x, Offline"
    Add-Content -Path $hostdata -Value "$x, Offline"
    }
}
Add-Content -Path $hostdata -Value "Total Hosts up: $totalhostsup"
