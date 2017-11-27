#
# Script.ps1
#
#Login-AzureRmAccount
#Save-AzureRmContext -Path “C:\Users\michaelheydt\Source\Repos\CreateVmss\CreateVmss\azureprofile1.json” 

#$rgNet = "rg-net-ws-pri"
#$rgWeb = "rg-webvmss-ws-pri"
$rgNet = "rg-vmss"
$rgWeb = "rg-vmss"

$location = "WestUS"

#$subnetName = "sn-web-ws-pri"
#$vnetName = "vnet-ws-pri"
$subnetName = "default"
$vnetName = "vnet-vmss"

#$pipName = "pip-web-ws-pri"
#$lbName = "lb-web-ws-pri"

$pipName = "pip-vmss"
$lbName = "lb-vmss"

#$vmssIpConfigName = "vmssip-web-ws-pri"
#$vmssNicConfigName = "vmssnic-web-ws-pri"
$vmssIpConfigName = "vmss-ip"
$vmssNicConfigName = "vmss-nic"

#$vmssName = "vmss-web-ws-pri"
$vmssName = "vmss-test"

$adminUserName = "adminuser"
$adminPassword = "P@ssw0rd!"

$vmssComputerNamePrefix = "vmssvm"

$imageRefPub = "MicrosoftWindowsServer"
$imageRefOff = "WindowsServer"
$imageRefSku = "2016-Datacenter"
$imageRefVer = "latest"

$subscriptionName = "Windows Azure MSDN - Visual Studio Ultimate"

Import-AzureRmContext -Path "C:\dev\Deploy-Vmss\Deploy-Vmss\azureprofile1.json” #| Out-Null
Write-Host "Successfully logged in using saved profile file" -ForegroundColor Green
  
Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription  | Out-Null
Write-Host "Set Azure Subscription for session complete"  -ForegroundColor Green

# get destination vnet and subnet
Write-Output "Getting vnet"
$vnet = Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgNet -ErrorAction Stop
#Write-Output $vnet

Write-Output "Getting subnet"
$subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -VirtualNetwork $vnet -ErrorAction Stop
#Write-Output $subnet2

## Load balancer
Write-Output "Getting pip"
$pip = Get-AzureRmPublicIpAddress -Name $pipName -ResourceGroupName $rgNet -ErrorAction Stop
 
$frontendIP = New-AzureRmLoadBalancerFrontendIpConfig -Name "LB-Frontend" -PublicIpAddress $pip -ErrorAction Stop
Write-Output "Created front end IP config"

$backendPool = New-AzureRmLoadBalancerBackendAddressPoolConfig -Name "LB-backend" -ErrorAction Stop
Write-Output "Created backend pool config"

$probe = New-AzureRmLoadBalancerProbeConfig -Name "HealthProbe" -Protocol Tcp -Port 80 -IntervalInSeconds 15 -ProbeCount 2 -ErrorAction Stop
Write-Output "Created lb probe config"

$inboundNATRule1= New-AzureRmLoadBalancerRuleConfig -Name "webserver" -FrontendIpConfiguration $frontendIP -Protocol Tcp -FrontendPort 80 -BackendPort 80 -IdleTimeoutInMinutes 15 -Probe $probe -BackendAddressPool $backendPool -ErrorAction Stop
Write-Output "Created lb web server rule config"

$inboundNATPool1 = New-AzureRmLoadBalancerInboundNatPoolConfig -Name "RDP" -FrontendIpConfigurationId $frontendIP.Id -Protocol TCP -FrontendPortRangeStart 53380 -FrontendPortRangeEnd 53390 -BackendPort 3389 -ErrorAction Stop
Write-Output "Created lb rdp rule config"

$lb = New-AzureRmLoadBalancer -ResourceGroupName $rgWeb -Name $lbName -Location $location -FrontendIpConfiguration $frontendIP -LoadBalancingRule $inboundNATRule1 -InboundNatPool $inboundNATPool1 -BackendAddressPool $backendPool -Probe $probe -ErrorAction Stop
#Write-Output "Created load balancer"

<#

# Create a config object
$vmssConfig = New-AzureRmVmssConfig -Location $location -SkuCapacity 2 -SkuName Standard_A0 -UpgradePolicyMode Automatic -ErrorAction Stop
Write-Output "Created vmss config"

## IP address config
$vmssIpConfig = New-AzureRmVmssIpConfig -Name $vmssIpConfigName -LoadBalancerBackendAddressPoolsId $backendPool.Id -SubnetId $subnet.Id -LoadBalancerInboundNatPoolsId $inboundNATPool1.Id -ErrorAction Stop
Write-Output "Created vmssIpConfig"

# Attach the virtual network to the IP object
$nicConfig = Add-AzureRmVmssNetworkInterfaceConfiguration -VirtualMachineScaleSet $vmssConfig -Name $vmssNicConfigName -Primary $true -IPConfiguration $vmssIpConfig -ErrorAction Stop
Write-Output "Created vmss nic config"

# Reference a virtual machine image from the gallery
Set-AzureRmVmssStorageProfile $vmssConfig -ImageReferencePublisher $imageRefPub -ImageReferenceOffer $imageRefOff -ImageReferenceSku $imageRefSku -ImageReferenceVersion $imageRefVer -ErrorAction Stop
Write-Output "Set storage profile"

# Set up information for authenticating with the virtual machine
Set-AzureRmVmssOsProfile $vmssConfig -AdminUsername $adminUserName -AdminPassword $adminPassword -ComputerNamePrefix $vmssComputerNamePrefix -ErrorAction Stop
Write-Output "Set os profile"

$settings = @{
    "fileUris" = (,"https://raw.githubusercontent.com/iainfoulds/azure-samples/master/automate-iis.ps1");
    "commandToExecute" = "powershell -ExecutionPolicy Unrestricted -File automate-iis.ps1"
}


# Create the scale set with the config object (this step might take a few minutes)
$vmss = New-AzureRmVmss -ResourceGroupName $rgWeb -Name $ssName -VirtualMachineScaleSet $vmssConfig  -ErrorAction Stop
Write-Output "Created vmss"



<#


# Reference a virtual machine image from the gallery
Set-AzureRmVmssStorageProfile $vmssConfig -ImageReferencePublisher MicrosoftWindowsServer `
										  -ImageReferenceOffer WindowsServer `
										  -ImageReferenceSku 2016-Datacenter `
										  -ImageReferenceVersion latest

# Set up information for authenticating with the virtual machine
Set-AzureRmVmssOsProfile $vmssConfig -AdminUsername azureuser -AdminPassword P@ssw0rd! -ComputerNamePrefix webvmssvm


$vnet = New-AzureRmVirtualNetwork -Name "my-network" -ResourceGroupName $rg -Location $location -AddressPrefix 10.0.0.0/16 -Subnet $subnet



Set-AzureRmVMCustomScriptExtension -ResourceGroupName myResourceGroup `
	-VMName myVM `
	-Location myLocation `
	-FileUri myURL `
	-Run 'myScript.ps1' `
	-Name DemoScriptExtension

	#>