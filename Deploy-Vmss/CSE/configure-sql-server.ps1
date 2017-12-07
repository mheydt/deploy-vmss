#
# configure_sql_server.ps1
#

Function Write-Log
{
   Param ([string]$logstring)

   $Logfile = "c:\configure-sql-server.log"
   Add-content $Logfile -value $logstring
}

Write-Log("Starting configuration")

. .\install-powershellget.ps1
. .\install-sqlserverdsc.ps1

Write-Log("Ran the config")
