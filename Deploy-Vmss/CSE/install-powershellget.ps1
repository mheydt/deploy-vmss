#
# install_powershellget.ps1
#
Function Write-Log
{
   Param ([string]$logstring)
 
   $Logfile = "c:\install-powershellget.log"
   Add-content $Logfile -value $logstring
}

try
{
	Write-Log("Updating package provider")
		Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	Write-Log("Installing powershell get")
	if (-not (Test-Path "C:\Program Files\WindowsPowerShell\Modules\PowerShellGet")) {
		mkdir c:\temp -ErrorAction SilentlyContinue | Out-Null
		$client = new-object system.Net.Webclient
		$client.DownloadFile("https://github.com/PowerShell/PowerShellGet/archive/1.6.0.zip","c:\temp\powershellget.zip")
		Add-Type -AssemblyName System.IO.Compression.FileSystem
		[System.IO.Compression.ZipFile]::ExtractToDirectory("c:\temp\powershellget.zip", "c:\temp")
		#cp -Recurse C:\temp\OctopusDSC "C:\Program Files\WindowsPowerShell\Modules\OctopusDSC" -Force
		Import-Module c:\temp\powershellget-1.6.0\powershellget
	}
	Write-Log("Installed powershell get")
}
catch
{
	Write-Log('Exception installing')
	Write-Log($_)
}
