#
# create_ssc.ps1
#
$keyVaultName = "kv-svc-ws-pri"
$certName = "vmssweb"
$subjectName = "CN=www.workspace.cc"

Import-AzureRmContext -Path "C:\dev\Deploy-Vmss\Deploy-Vmss\azureprofile1.json” #| Out-Null
Write-Host "Successfully logged in using saved profile file" -ForegroundColor Green
  
Get-AzureRmSubscription –SubscriptionName $subscriptionName | Select-AzureRmSubscription  | Out-Null
Write-Host "Set Azure Subscription for session complete"  -ForegroundColor Green

$policy = New-AzureKeyVaultCertificatePolicy `
    -SubjectName $subjectName `
    -SecretContentType "application/x-pkcs12" `
    -IssuerName Self `
    -ValidityInMonths 12
Write-Output "Created Cert"

Add-AzureKeyVaultCertificate `
    -VaultName $keyVaultName `
    -Name $certName `
    -CertificatePolicy $policy
Write-Output "Saved cert in KV"