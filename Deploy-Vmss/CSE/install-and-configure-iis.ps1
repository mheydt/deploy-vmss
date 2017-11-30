#
# install_and_configure_iis.ps1
#
Install-WindowsFeature Net-Framework-45-Features
Install-WindowsFeature Web-Server, Web-Asp-Net45, NET-Framework-Features
Install-WindowsFeature Web-Mgmt-Console

Add-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)