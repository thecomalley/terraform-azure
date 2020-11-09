<#
    .DESCRIPTION
        An example runbook which gets all the ARM resources using the Run As Account (Service Principal)

    .NOTES
        AUTHOR: Azure Automation Team
        LASTEDIT: Mar 14, 2016
#>

#authentication
$connectionName = "AzureRunAsConnection"

# Import-Module Az.Accounts
Import-Module -Name Az.Accounts -RequiredVersion 2.1.2 

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

#elete untagged resources
$resources = Get-AzResource

foreach($resource in $resources)
{
    if ($resource.Tags['deployment'] -eq $null)
    {
        write-host "removing resource:" $resource.name
        #Remove-AzResource -ResourceId $resource.id -Force
    }
}