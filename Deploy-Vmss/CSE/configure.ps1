Write-Host "Installing Chocolatey..."
.\install.ps1

Write-Host "Installing OctopusDSC..."
.\Install-OctopusDSC.ps1

Write-Host "Installing and configuring IIS"
.\install-and-configure-iis.ps1