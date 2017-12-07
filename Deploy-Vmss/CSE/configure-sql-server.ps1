#
# configure_sql_server.ps1
#

Function Write-Log
{
   Param ([string]$logfile, [string]$logstring)

   Add-content $logfile -value $logstring
} 

try
{
	Write-Log("c:\configure-sqlserver.log", "Trusting PSGallery")
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

	Write-Log("c:\configure-sqlserver.log", "Installing AzureRM")
	Install-Module -Name AzureRM -Repository PSGallery

	Write-Log("c:\configure-sqlserver.log", "Starting configuration")

	. .\install-powershellget.ps1
	. .\get-sqlservermedia.ps1
	. .\install-sqlserverdsc.ps1

	Write-Log("c:\configure-sqlserver.log", "Ran the config")
}
catch
{

}