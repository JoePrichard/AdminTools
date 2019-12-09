#Script pulls a list of hosts from hosts.txt and uses Test-Connection function on each host. 
#The result for each host is written to a timestamped text file with a count of online machines at the bottom
#Another script will compare the text files to expose consistently offline machines
#Could be tailored to run in certain time windows by scheduling when the script runs

$hosts = Get-Content "C:\ModernScripting\hosts.txt"
$hostdata = "C:\ModernScripting\hostdata $(Get-Date -Format yyyy-MM-dd).txt"
$totalhostsup = 0

foreach ($x in $hosts) {
  if (Test-Connection -ComputerName $x -Count 1 -ErrorAction SilentlyContinue) {
    Write-Host "$x, Online"
}
  else {
    Write-Host "$x, Offline"
    Add-Content -Path $hostdata -Value "x, Offline"
    }
}
Add-Content -Path $hostdata -Value "Total Hosts Up: $totalhostsup"
