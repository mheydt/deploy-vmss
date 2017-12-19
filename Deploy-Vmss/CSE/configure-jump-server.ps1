#
# configure_jump_server.ps1
#

Function Write-Log
{
   Param ([string]$logstring)

   Add-Content -Path "c:\configure.log" -Value $logstring
} 

Try
{
	<#
	Write-Log "Trusting PSGallery"
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

	Write-Log "Installing AzureRM"
	Install-Module -Name AzureRM -Repository PSGallery

	$storageAccountKey = "463znlo22viNBm3ACyTCeHaZJDqHkCY6SH9oLMIv3yVr/7RzXphZKS2KCZxJ4eLwQkWThK2wBwXo42pHHkNDdw=="
	$storageAccountName = "stginstallerswspri"
	$containerName = "sqlserver"
	$ssmsInstallBlobName = "SSMS-Setup-ENU.exe"
	$destinationSSMS = "d:\SSMS-Setup-ENU.exe"

	Write-Log "Retriving SSMS"

	$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
	Get-AzureStorageBlobContent -Blob $ssmsInstallBlobName -Container $containerName -Destination $destinationSSMS -Context $storageContext

	Write-Log "Retrieved SSMS"
	
	Write-Log "Installing SSMS"
	Start-Process "d:\SSMS-Setup-ENU.exe" "/install /quiet /norestart /log d:\ssms-log.txt" -Wait
	Write-Log "Installed SSMS"

	Write-Log "Cleaning up"
	Remove-Item -Path $destinationSSMS
    Remove-Item -Path d:\log*.txt
    Remove-Item -Path d:\ssms-*.txt
	#>
	Write-Log "All done!"
}
Catch
{
	Write-Log "Exception"
	Write-Log $_.Exception.Message
}