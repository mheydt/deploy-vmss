#
# Install_OctopusDSC.ps1
#
if (-not (Test-Path "C:\Program Files\WindowsPowerShell\Modules\OctopusDSC")) {
    mkdir c:\temp -ErrorAction SilentlyContinue | Out-Null
    $client = new-object system.Net.Webclient
    $client.DownloadFile("https://github.com/OctopusDeploy/OctopusDSC/releases/download/v3.0.45/default.OctopusDSC.3.0.45.zip","c:\temp\octopusdsc.zip")
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory("c:\temp\octopusdsc.zip", "c:\temp")
    cp -Recurse C:\temp\OctopusDSC "C:\Program Files\WindowsPowerShell\Modules\OctopusDSC" -Force
}