#
# configure_sql_server.ps1
#

Function Write-Log
{
   Param ([string]$logstring)

   Add-Content -Path "c:\configure-sqlserver.log" -Value $logstring
} 

Try
{
	Write-Log "Trusting PSGallery"
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

	Write-Log "Installing AzureRM"
	Install-Module -Name AzureRM -Repository PSGallery
	Install-Module -Name xSqlServer -Repository PSGallery

	Write-Log "Starting configuration"

	$storageAccountKey = "463znlo22viNBm3ACyTCeHaZJDqHkCY6SH9oLMIv3yVr/7RzXphZKS2KCZxJ4eLwQkWThK2wBwXo42pHHkNDdw=="
	$storageAccountName = "stginstallerswspri"
	$containerName = "sqlserver"
	$sqlInstallBlobName = "en_sql_server_2016_enterprise_with_service_pack_1_x64_dvd_9542382.iso"
	$ssmsInstallBlobName = "SSMS-Setup-ENU.exe"
	$destinationSqlIso = "d:\sqlserver.iso"
	$destinationSSMS = "d:\SSMS-Setup-ENU.exe"

	$storageContext = New-AzureStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey
	Get-AzureStorageBlobContent -Blob $sqlInstallBlobName -Container $containerName -Destination $destinationSqlIso -Context $storageContext
	Get-AzureStorageBlobContent -Blob $ssmsInstallBlobName -Container $containerName -Destination $destinationSSMS -Context $storageContext
	Mount-DiskImage -ImagePath d:\sqlserver.iso 
	$sqlInstallDrive = (Get-DiskImage -ImagePath "d:\sqlserver.iso" | Get-Volume).DriveLetter

	Write-Log "Mounted sql server media"
	
	Write-Log "Starting SQL Server Install"
	. ./SqlStandaloneDSC
	SqlStandaloneDSC
	Start-DscConfiguration .\SqlStandaloneDSC -Verbose -wait

	Write-Log "Installed SQL Server"

	Write-Log "Installing SSMS"
	Start-Process "d:\SSMS-Setup-ENU.exe" "/install /quiet /norestart /log d:\ssms-log.txt" -Wait
	Write-Log "Installed SSMS"

	Write-Log "Cleaning up"
	Dismount-DiskImage -ImagePath d:\sqlserver.iso
	Write-Log "Cleaned up"
	Remove-Item -Path $destinationSqlIso
	Remove-Item -Path $destinationSSMS
    Remove-Item -Path d:\log*.txt
    Remove-Item -Path d:\ssms-*.txt

	Write-Log "All done!"
}
Catch
{
	Write-Log "Exception"
	Write-Log $_.Exception.Message
}