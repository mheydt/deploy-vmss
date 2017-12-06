#
# configure_sql_server.ps1
#

Function Write-Log
{
   Param ([string]$logstring)

   $Logfile = "c:\configure-sql-server.log"
   Add-content $Logfile -value $logstring
}


Write-Log("Ran the config")
