## https://www.powershellgallery.com/packages/AzureADIncidentResponse/4.0
## Install AzureADIncident Response Module from MS DART Team


Install-Module -Name AzureADIncidentResponse -Scope CurrentUser
Get-Command -Module AzureADIncidentResponse

$domainname = "verboon.online"
$TenantID =   (Get-AzureADIRTenantId -DomainName $domainname)
 
Connect-AzureADIR -TenantId $TenantID
Get-AzureADIRConditionalAccessPolicy -All -TenantId $TenantID
Get-AzureADIRMfaAuthMethodAnalysis -TenantId $TenantID 
Get-AzureADIRUserLastSignInActivity -TenantId $TenantID -StaleThreshold 90 
Get-AzureADIRPermission -TenantId $TenantID
