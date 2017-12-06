#
# install_powershellget.ps1
#
if (-not (Test-Path "C:\Program Files\WindowsPowerShell\Modules\PowerShellGet")) {
    mkdir c:\temp -ErrorAction SilentlyContinue | Out-Null
    $client = new-object system.Net.Webclient
    $client.DownloadFile("https://github.com/PowerShell/PowerShellGet/archive/1.6.0.zip","c:\temp\powershellget.zip")
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\temp\powershellget.zip", "c:\temp")
    #cp -Recurse C:\temp\OctopusDSC "C:\Program Files\WindowsPowerShell\Modules\OctopusDSC" -Force
	Import-Module c:\temp\powershellget-1.6.0\powershellget
}