#
# install_and_configure_iis.ps1
#
Install-WindowsFeature Web-Server
Install-WindowsFeature Web-Asp-Net45
Install-WindowsFeature Web-Mgmt-Console

Add-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)