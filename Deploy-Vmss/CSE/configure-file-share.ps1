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
	$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$($stgAcctName)", $acctKey

	LogWrite("Mapping drive")
	LogWrite($filesMountDrive)
	LogWrite("\\$($stgAcctName).file.core.windows.net\$($fileShareName)")
    Write-Output($filesMountDrive)
	New-PSDrive -Name $filesMountDrive -PSProvider FileSystem -Root "\\$($stgAcctName).file.core.windows.net\$($fileShareName)" -Credential $credential -Persist -Scope Global
    Write-Output("mapped drive")
	LogWrite("Mapped drive")

    Write-Output("Creating sym link")
    LogWrite("Creating sym link")
	New-Item $symDirPath -type directory -Force
    Write-Output("Part 2")
	New-Item -ItemType SymbolicLink -Path "$($symDirPath)\$($symDirFolderName)" -Value "$($filesMountDrive):"
	LogWrite("Created sym link")
    Write-Output("created sym link")

    Write-Output("storing credentials")
    LogWrite("storing credentials")
    cmdkey /add:$stgAcctName.file.core.windows.net /user:AZURE\$stgAcctName /pass:$key
    Write-Output("stored credentials")
    LogWrite("stored credentials")
}
Catch
{
	LogWrite($_.Exception.Message)
}

