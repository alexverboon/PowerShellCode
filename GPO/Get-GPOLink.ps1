## https://mikefrobbins.com/2013/11/14/determine-what-active-directory-organization-units-a-group-policy-is-linked-to-with-powershell/
#Requires -Modules GroupPolicy 
 
function Get-GPOLink {
<#
.SYNOPSIS
    Returns the Active Directory (AD) Organization Units (OU's) that a Group Policy Object (GPO) is linked to.
 
.DESCRIPTION
    Get-GPOLink is a function that returns the Active Directory Organization Units (OU's) that a Group Policy
Object (GPO) is linked to.
 
.PARAMETER Name
    The Name of the Group Policy Object.
 
.EXAMPLE
    Get-GPOLink -Name 'Default Domain Policy'
 
.EXAMPLE
    Get-GPOLink -Name 'Default Domain Policy', 'Default Domain Controllers Policy'
 
.EXAMPLE
    'Default Domain Policy' | Get-GPOLink
 
.EXAMPLE
    'Default Domain Policy', 'Default Domain Controllers Policy' | Get-GPOLink
 
.EXAMPLE
    Get-GPO -All | Get-GPO-Link
 
.INPUTS
    System.String, Microsoft.GroupPolicy.Gpo
 
.OUTPUTS
    PSCustomObject
#>
 
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,
                   ValueFromPipeline,
                   ValueFromPipelineByPropertyName)]
        [Alias('DisplayName')]
        [string[]]$Name
    )
 
    PROCESS {
 
        foreach ($n in $Name) {            
            $problem = $false
 
            try {
                Write-Verbose -Message "Attempting to produce XML report for GPO: $n"
 
                [xml]$report = Get-GPOReport -Name $n -ReportType Xml -ErrorAction Stop
            }
            catch {
                $problem = $true
                Write-Warning -Message "An error occured while attempting to query GPO: $n"
            }
 
            if (-not($problem)) {
                Write-Verbose -Message "Returning results for GPO: $n"
 
                [PSCustomObject]@{
                    'GPOName' = $report.GPO.Name
                    'LinksTo' = $report.GPO.LinksTo.SOMName
                    'Enabled' = $report.GPO.LinksTo.Enabled
                    'NoOverride' = $report.GPO.LinksTo.NoOverride
                    'CreatedDate' = ([datetime]$report.GPO.CreatedTime).ToShortDateString()
                    'ModifiedDate' = ([datetime]$report.GPO.ModifiedTime).ToShortDateString()
                }
 
            }
 
        }
 
    }
 
}