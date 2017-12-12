#
# Install_OctopusDSC.ps1
#
Function Write-Log
{
	Param ([string]$logstring)

	$Logfile = "c:\config.log"
	Add-content $Logfile -value $logstring
}

Write-Log('Starting install of Octopus DSC')

if (-not (Test-Path "C:\Program Files\WindowsPowerShell\Modules\OctopusDSC")) {
	Write-Log('OctopusDSC not found.  Downloading...')
    mkdir c:\temp -ErrorAction SilentlyContinue | Out-Null
    $client = new-object system.Net.Webclient
    $client.DownloadFile("https://github.com/OctopusDeploy/OctopusDSC/releases/download/v3.0.45/default.OctopusDSC.3.0.45.zip","c:\temp\octopusdsc.zip")
	Write-Log('Downloaded - Unzipping')
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\temp\octopusdsc.zip", "c:\temp")
    cp -Recurse C:\temp\OctopusDSC "C:\Program Files\WindowsPowerShell\Modules\OctopusDSC" -Force
	Write-Log('Unzipped')
}

Write-Log('Finished install of Octopus DSC')