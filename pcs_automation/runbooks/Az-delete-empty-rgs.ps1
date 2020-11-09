<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Azure Automation Team
        LASTEDIT: Mar 14, 2016
#>

#authentication
$connectionName = "AzureRunAsConnection"

# Load Az version 3.6.1
Import-Module -Name Az -RequiredVersion 3.6.1

try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Connect-AzAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

#Get Azure Resource Groups 
$rgs = Get-AzResourceGroup; 
    
if(!$rgs){ 
    Write-Output "No resource groups in your subscription"; 
} 
else{ 
        
    Write-Output "You have $($(Get-AzResourceGroup).Count) resource groups in your subscription"; 
        
    foreach($resourceGroup in $rgs){ 
        $name=  $resourceGroup.ResourceGroupName; 
        $count = (Get-AzResource | where { $_.ResourceGroupName -match $name }).Count; 
        if($count -eq 0){ 
            Write-Output "The resource group $name has $count resources. Deleting it..."; 
            Remove-AzResourceGroup -Name $name -Force; 
        } 
        else{ 
            Write-Output "The resource group $name has $count resources"; 
        } 
    } 
        
    Write-Output "Now you have $((Get-AzResourceGroup).Count) resource group(s) in your subscription"; 

}