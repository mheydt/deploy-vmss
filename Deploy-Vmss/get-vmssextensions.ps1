#
# get_vmssextensions.ps1
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

Write-Output "Updating extensions"

# Update the scale set and apply the Desired State Configuration extension to the VM instances
Update-AzureRmVmss `
    -ResourceGroupName $rgName `
    -Name $vmssName `
    -VirtualMachineScaleSet $vmss

Write-Output "Updated extensions"