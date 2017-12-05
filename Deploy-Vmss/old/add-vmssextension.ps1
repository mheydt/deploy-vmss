#
# add_vmssextension.ps1
#

$subscriptionName = "Windows Azure MSDN - Visual Studio Ultimate"
$rgName = "rg-webvmss-ws-pri"
$vmssName = "vmss-web-ws-pri"

Import-AzureRmContext -Path "C:\dev\Deploy-Vmss\Deploy-Vmss\azureprofile1.json” #| Out-Null
Write-Host "Successfully logged in using saved profile file" -ForegroundColor Green
         
Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription  | Out-Null
Write-Host "Set Azure Subscription for session complete"  -ForegroundColor Green

# Get information about the scale set
$vmss = Get-AzureRmVmss `
                -ResourceGroupName $rgName `
                -VMScaleSetName $vmssName

Write-Output "Got vmss"

<#
# Define the script for your Desired Configuration to download and run
$dscConfig = @{
  "wmfVersion" = "latest";
  "configuration" = @{
    "url" = "https://github.com/iainfoulds/azure-samples/raw/master/dsc.zip";
    "script" = "configure-http.ps1";
    "function" = "WebsiteTest";
  };
}
#>

$settings = @{
    "fileUris" = (,"https://raw.githubusercontent.com/iainfoulds/azure-samples/master/automate-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}

Write-Output "Adding vmss extension"
<#
$vmss = Add-AzureRmVmssExtension `
    -VirtualMachineScaleSet $vmss `
    -Publisher Microsoft.Powershell `
    -Type DSC `
    -TypeHandlerVersion 2.24 `
    -Name "DSC" `
    -Setting $dscConfig
#>

# Use Custom Script Extension to install IIS and configure basic website
Add-AzureRmVmssExtension `
	-VirtualMachineScaleSet $vmss `
    -Name "customScript" `
    -Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.8 `
    -Setting $settings

Write-Output "Added vmss extension"

<#
# Update the scale set and apply the Desired State Configuration extension to the VM instances
Update-AzureRmVmss `
    -ResourceGroupName "myResourceGroup" `
    -Name "myScaleSet"  `
    -VirtualMachineScaleSet $vmss

Write-Output "Updated vmss"
#>