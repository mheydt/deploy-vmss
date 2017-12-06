#
# Script1.ps1
#

Write-Output "HI"
$Conn = Get-AzureAutomationConnection -AutomationAccountName 'ws-automation'

workflow MyFirstRunbook-Workflow
{
    Param(
        [string]$VMName,
        [string]$ResourceGroupName,
        [string]$SubscriptionId
    )

    $Conn = Get-AutomationConnection -Name AzureRunAsConnection
    Add-AzureRMAccount -ServicePrincipal -Tenant $Conn.TenantID `
        -ApplicationId $Conn.ApplicationID -CertificateThumbprint $Conn.CertificateThumbprint

    Start-AzureRmVM -Name $VMName -ResourceGroupName $ResourceGroupName
}