#
# install_and_configure_iis.ps1
#

$username = "stgfiles1wspri"
$password = ConvertTo-SecureString "5NZYMJoyyrQLoEwcxGBlgDBdLMrnWsCx4BEwfsSdkM33QzgsmuXadz5gr3j8PIeBfeg1E9XqD473j9Nk2QYsRg=="
New-LocalUser -Name $username -Password $password -PasswordNeverExpires -UserMayNotChangePassword -AccountNeverExpires

Install-WindowsFeature Net-Framework-45-Features
Install-WindowsFeature Web-Server, Web-Asp-Net45, NET-Framework-Features
Install-WindowsFeature Web-Mgmt-Console

Remove-Website "Default Web Site" 