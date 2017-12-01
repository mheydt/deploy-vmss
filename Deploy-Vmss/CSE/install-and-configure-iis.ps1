#
# install_and_configure_iis.ps1
#
Install-WindowsFeature Net-Framework-45-Features
Install-WindowsFeature Web-Server, Web-Asp-Net45, NET-Framework-Features
Install-WindowsFeature Web-Mgmt-Console

Remove-Website "Default Web Site"

#Add-Content -Path "C:\inetpub\wwwroot\Default.htm" -Value $($env:computername)

$key = "5NZYMJoyyrQLoEwcxGBlgDBdLMrnWsCx4BEwfsSdkM33QzgsmuXadz5gr3j8PIeBfeg1E9XqD473j9Nk2QYsRg=="
$shareName = "workspace-file-storage-pri"
$symDirPath = "c:\server\workspace\client"
$stgAcctName = "stgfiles1wspri"
$fileShareName = "workspace-file-storage-pri"
$symDirFolderName = "files"
$filesMountDrive = "D"

$Logfile = "D:\Apps\Logs\$(gc env:computername).log"

$acctKey = ConvertTo-SecureString -String $key -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "$Azure\$($stgAcctName)", $acctKey
New-PSDrive -Name $filesMountDrive -PSProvider FileSystem -Root "\\$($stgAcctName).file.core.windows.net\$($fileShareName)" -Credential $credential -Persist

New-Item $symDirPath -type directory -Force
New-Item -ItemType SymbolicLink -Path "$($symDirPath)\$($symDirFolderName)" -Value "$($filesMountDrive):"