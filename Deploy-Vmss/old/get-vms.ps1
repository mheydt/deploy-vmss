#
# get_vms.ps1
#
# Get current scale set

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

# Loop through the instanaces in your scale set
for ($i=1; $i -le ($vmss.Sku.Capacity - 1); $i++) {
    Get-AzureRmVmssVM -ResourceGroupName $rgName `
      -VMScaleSetName $vmssName `
      -InstanceId $i
}