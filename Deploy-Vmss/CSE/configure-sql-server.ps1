#
# configure_sql_server.ps1
#

Function Write-Log
{
   Param ([string]$logfile, [string]$logstring)

   Add-content $logfile -value $logstring
} 

try
{
	Write-Log("c:\configure-sqlserver.log", "Trusting PSGallery")
	Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
	Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

	Write-Log("c:\configure-sqlserver.log", "Installing AzureRM")
	Install-Module -Name AzureRM -Repository PSGallery
	Install-Module -Name xSqlServer -Repository PSGallery

	Write-Log("c:\configure-sqlserver.log", "Starting configuration")

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

	Write-Log("c:\configure-sqlserver.log", "Mounted sql server media")
	
	Write-Log("c:\configure-sqlserver.log", "Starting SQL Server Install")
	. ./SqlStandaloneDSC
	SqlStandaloneDSC
	Start-DscConfiguration .\SqlStandaloneDSC -Verbose -wait

	Write-Log("c:\configure-sqlserver.log", "Installed SQL Server")

	Write-Log("c:\configure-sqlserver.log", "Installing SSMS")
	d:\SSMS-Setup-ENU.exe /install /quiet /norestart
	Write-Log("c:\configure-sqlserver.log", "Installed SSMS")

	Write-Log("c:\configure-sqlserver.log", "Cleaning up")
	Dismount-DiskImage -ImagePath d:\sqlserver.iso
	Write-Log("c:\configure-sqlserver.log", "Cleaned up")
	Remove-Item -Path $destinationSqlIso
	Remove-Item -Path $destinationSSMS

	Write-Log("c:\configure-sqlserver.log", "All done!")
}
catch
{
	Write-Log("c:\configure-sqlserver.log", "Exception")
	Write-Log("c:\configure-sqlserver.log", $_)
}