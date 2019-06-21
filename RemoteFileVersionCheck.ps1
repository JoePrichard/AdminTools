#Remotely check the version of a file. In this case Acrobat Reader DC
Invoke-Command -ComputerName ExampleName -ScriptBlock {Get-Item -Path "C:\Program Files (x86)\Adobe\Acrobat Reader DC\Reader\AcroRd32.exe").VersionInfo)
