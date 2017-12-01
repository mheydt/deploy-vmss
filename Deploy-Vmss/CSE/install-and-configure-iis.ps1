#
# install_and_configure_iis.ps1
#
Install-WindowsFeature Net-Framework-45-Features
Install-WindowsFeature Web-Server, Web-Asp-Net45, NET-Framework-Features
Install-WindowsFeature Web-Mgmt-Console

Remove-Website "Default Web Site"

$key = "5NZYMJoyyrQLoEwcxGBlgDBdLMrnWsCx4BEwfsSdkM33QzgsmuXadz5gr3j8PIeBfeg1E9XqD473j9Nk2QYsRg=="
$shareName = "workspace-file-storage-pri"
$symDirPath = "c:\server\workspace\client"
$stgAcctName = "stgfiles1wspri"
$fileShareName = "workspace-file-storage-pri"
$symDirFolderName = "files"
$filesMountDrive = "Z"

$Logfile = "c:\script.log"

Function LogWrite
{
   Param ([string]$logstring)

   Add-content $Logfile -value $logstring
}

LogWrite("Starting map of AZF")
Try
{
	$acctKey = ConvertTo-SecureString -String $key -AsPlainText -Force
	$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "$Azure\$($stgAcctName)", $acctKey

	LogWrite("Mapping drive")
	New-PSDrive -Name $filesMountDrive -PSProvider FileSystem -Root "\\$($stgAcctName).file.core.windows.net\$($fileShareName)" -Credential $credential -Persist
	LogWrite("Mapped drive")

	New-Item $symDirPath -type directory -Force
	New-Item -ItemType SymbolicLink -Path "$($symDirPath)\$($symDirFolderName)" -Value "$($filesMountDrive):"
}
Catch
{
	LogWrite($_.Exception.Message)
}
