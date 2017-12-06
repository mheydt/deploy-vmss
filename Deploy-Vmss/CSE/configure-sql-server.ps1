#
# configure_sql_server.ps1
#

Function Write-Log
{
   Param ([string]$logstring)

   $Logfile = "c:\configure-sql-server.log"
   Add-content $Logfile -value $logstring
}

. .\configure-powershellget.ps1

Write-Log("Ran the config")
