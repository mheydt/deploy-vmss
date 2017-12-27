param(
	[string]$octoUrl
)
Function Write-Log
{
	Param ([string]$logstring)

	$Logfile = "c:\config.log"
	Add-content $Logfile -value $logstring
}

Write-Log "Trusting PSGallery"
Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Write-Log("Installing OctopusDSC...")
. .\Install-OctopusDSC.ps1

Write-Log("Installing and configuring IIS")
. .\install-and-configure-iis.ps1

Write-Log("Configuring file shares")
. .\configure-file-share.ps1

Write-Log("Installing Web App with Octopus DSC")
. .\install-web-app-with-octo-dsc.ps1

Write-Log("All done configuration!")