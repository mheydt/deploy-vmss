#
# install_and_configure_iis.ps1
#

Function Write-Log
{
	Param ([string]$logstring)

	$Logfile = "c:\config.log"
	Add-content $Logfile -value $logstring
}

Write-Log("Starting installation of IIS")

Write-Log('Creating local use to access AZF')
$username = "stgfiles1wspri"
$password = ConvertTo-SecureString -String "5NZYMJoyyrQLoEwcxGBlgDBdLMrnWsCx4BEwfsSdkM33QzgsmuXadz5gr3j8PIeBfeg1E9XqD473j9Nk2QYsRg==" -AsPlainText -Force
New-LocalUser -Name $username -Password $password -PasswordNeverExpires -UserMayNotChangePassword -AccountNeverExpires
Write-Log('User created')

Write-Log('Configuring .NET 4.5')
Install-WindowsFeature Net-Framework-45-Features
Write-Log('Configuring Web Server, ASP.NET 4.5')
Install-WindowsFeature Web-Server, Web-Asp-Net45, NET-Framework-Features
Write-Log("Installing management console")
Install-WindowsFeature Web-Mgmt-Console

Write-Log('Removing default web site')
Remove-Website "Default Web Site" 
Write-Log('IIS config complete')