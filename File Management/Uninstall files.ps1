#Use powershells Uninstall() method
$app = Get-WmiObject -Class Win32_Product | Where-Object {
  $_.Name -match "Adobe Acrobat*"
}
$app.Uninstall()
