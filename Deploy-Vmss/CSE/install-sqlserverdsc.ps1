#
# installsqlserverdsc.ps1
#

Function Write-Log
{
   Param ([string]$logstring)

   $Logfile = "c:\install-sqlserverdsc.log"
   Add-content $Logfile -value $logstring
}

Write-Log("Installing SqlServerDSC")
Find-Module -Name SqlServerDsc -Repository PSGallery | Install-Module
Write-Log("Installed SqlServerDSC")
