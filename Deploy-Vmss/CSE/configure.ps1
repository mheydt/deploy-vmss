Write-Host "Installing OctopusDSC..."
.\Install-OctopusDSC.ps1

Write-Host "Installing and configuring IIS"
.\install-and-configure-iis.ps1

.\configure-file-share.ps1

Write-Host "Installing Web App with Octopus DSC"
.\install-web-app-with-octo-dsc.ps1
