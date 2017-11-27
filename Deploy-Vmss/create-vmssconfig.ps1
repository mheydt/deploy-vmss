#
# create_vmssconfig.ps1
#

$vmssIpConfigName = "pip-vmss"
$lbName = "lb-vmss"
$rgName = "rg-vmss"
$location = "WestUS"
$vnetName = "vnet-vmss"
$subnetName = "default"
$vmssNicConfigName = "vmss-nic"

$imageRefPub = "MicrosoftWindowsServer"
$imageRefOff = "WindowsServer"
$imageRefSku = "2016-Datacenter"
$imageRefVer = "latest"

$adminUserName = "adminuser"
$adminPassword = "Workspace!cc"
$vmssComputerNamePrefix = "vmssvm"

$vmScaleSetName = "vmss"

Import-AzureRmContext -Path "C:\dev\Deploy-Vmss\Deploy-Vmss\azureprofile1.json” #| Out-Null
Write-Host "Successfully logged in using saved profile file" -ForegroundColor Green
  
Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription  | Out-Null
Write-Host "Set Azure Subscription for session complete"  -ForegroundColor Green

$vmssConfig = New-AzureRmVmssConfig -Location $location -SkuCapacity 2 -SkuName Standard_B1ms -UpgradePolicyMode Automatic -ErrorAction Stop

$settings = @{
    "fileUris" = (,"https://raw.githubusercontent.com/iainfoulds/azure-samples/master/automate-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}

$vmssConfig | Add-AzureRmVmssExtension `
	-Name "MyExtension" `
	-Publisher "Microsoft.Compute" `
    -Type "CustomScriptExtension" `
    -TypeHandlerVersion 1.8 `
    -Setting $settings `
	-ErrorAction Stop | Out-Null

$loadBalancer = Get-AzureRmLoadBalancer -Name "lb-vmss" -ResourceGroupName $rgName -ErrorAction Stop
$backendPool = Get-AzureRmLoadBalancerBackendAddressPoolConfig -LoadBalancer $loadBalancer -Name "LB-Backend" -ErrorAction Stop
$inboundNATPool1 = Get-AzureRmLoadBalancerInboundNatPoolConfig -LoadBalancer $loadBalancer -Name "RDP" -ErrorAction Stop

$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgNet -ErrorAction Stop
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet -ErrorAction Stop

$vmssIpConfig = New-AzureRmVmssIpConfig -Name $vmssIpConfigName -LoadBalancerBackendAddressPoolsId $backendPool.Id -SubnetId $subnet.Id -LoadBalancerInboundNatPoolsId $inboundNATPool1.Id -ErrorAction Stop

# Attach the virtual network to the IP object
$nicConfig = Add-AzureRmVmssNetworkInterfaceConfiguration -VirtualMachineScaleSet $vmssConfig -Name $vmssNicConfigName -Primary $true -IPConfiguration $vmssIpConfig -ErrorAction Stop
Write-Output "Created vmss nic config"

# Reference a virtual machine image from the gallery
Set-AzureRmVmssStorageProfile $vmssConfig -ImageReferencePublisher $imageRefPub -ImageReferenceOffer $imageRefOff -ImageReferenceSku $imageRefSku -ImageReferenceVersion $imageRefVer -ErrorAction Stop
Write-Output "Set storage profile"

# Set up information for authenticating with the virtual machine
Set-AzureRmVmssOsProfile $vmssConfig -AdminUsername $adminUserName -AdminPassword $adminPassword -ComputerNamePrefix $vmssComputerNamePrefix -ErrorAction Stop
Write-Output "Set os profile"

# Create the scale set with the config object (this step might take a few minutes)
$vmss = New-AzureRmVmss -ResourceGroupName $rgName -Name $vmScaleSetName -VirtualMachineScaleSet $vmssConfig  -ErrorAction Stop
Write-Output "Created vmss"
$vmss
