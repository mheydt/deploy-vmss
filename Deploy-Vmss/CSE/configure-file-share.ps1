$key = "5NZYMJoyyrQLoEwcxGBlgDBdLMrnWsCx4BEwfsSdkM33QzgsmuXadz5gr3j8PIeBfeg1E9XqD473j9Nk2QYsRg=="
$shareName = "workspace-file-storage-pri"
$symDirPath = "c:\server\workspace\client"
$stgAcctName = "stgfiles1wspri"
$fileShareName = "workspace-file-storage-pri"
$symDirFolderName = "files"
$filesMountDrive = "Z"

Function Write-Log
{
	Param ([string]$logstring)

	$Logfile = "c:\config.log"
	Add-content $Logfile -value $logstring
}

Wite-Log("Starting map of AZF")
Try
{
	$acctKey = ConvertTo-SecureString -String $key -AsPlainText -Force
	$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$($stgAcctName)", $acctKey

	Write-Log("Mapping drive")
	Write-Log($filesMountDrive)
	Write-Log("\\$($stgAcctName).file.core.windows.net\$($fileShareName)")
    Write-Output($filesMountDrive)
	New-PSDrive -Name $filesMountDrive -PSProvider FileSystem -Root "\\$($stgAcctName).file.core.windows.net\$($fileShareName)" -Credential $credential -Persist -Scope Global
    Write-Output("mapped drive")
	Write-Log("Mapped drive")

    Write-Output("Creating sym link")
    Write-Log("Creating sym link")
	New-Item $symDirPath -type directory -Force
    Write-Output("Part 2")
	New-Item -ItemType SymbolicLink -Path "$($symDirPath)\$($symDirFolderName)" -Value "$($filesMountDrive):"
	Write-Log("Created sym link")
    Write-Output("created sym link")

    Write-Output("storing credentials")
    Write-Log("storing credentials")
    cmdkey /add:$stgAcctName.file.core.windows.net /user:AZURE\$stgAcctName /pass:$key
    Write-Output("stored credentials")
    Write-Log("stored credentials")
}
Catch
{
	Write-Log($_.Exception.Message)
}
Write-Log('Finished AZF config')

